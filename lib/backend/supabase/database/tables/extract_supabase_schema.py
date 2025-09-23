#!/usr/bin/env python3

import os
import json
import psycopg2
from typing import Dict, List

# Tables to ignore explicitly (rarely needed when filtering by schema/kinds)
IGNORED_TABLES = {
    "pg_stat_statements", "pg_stat_statements_info",
    "pg_buffercache", "pgstattuple",
}

PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))
ENV_FILE_PATH = os.path.join(PROJECT_ROOT, ".env")


def load_env_file(path: str = ENV_FILE_PATH) -> None:
    """Load environment variables from a .env file if present (non-invasive)."""
    if not os.path.exists(path):
        return
    try:
        with open(path, "r") as f:
            for line in f:
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if "=" not in line:
                    continue
                key, value = line.split("=", 1)
                key = key.strip()
                value = value.strip().strip('"').strip("'")
                if key and key not in os.environ:
                    os.environ[key] = value
    except Exception:
        # Silent fallback: do not fail extraction due to .env parsing issues
        pass


def _mask_conn_str(conn_str: str) -> str:
    """Mask credentials in a connection string for safe logging."""
    try:
        # Very simple masking: hide text between '://' and '@'
        if "://" in conn_str and "@" in conn_str:
            prefix, rest = conn_str.split("://", 1)
            creds, host = rest.split("@", 1)
            return f"{prefix}://***:***@{host.split('?')[0]}"
    except Exception:
        pass
    return "***"


def build_candidate_connection_urls() -> List[str]:
    """Build a list of candidate PostgreSQL connection URLs for Supabase."""
    candidates: List[str] = []

    # 1) Direct DATABASE_URL if provided (preferred)
    db_url = os.getenv("DATABASE_URL") or os.getenv("SUPABASE_DATABASE_URL")
    if db_url:
        candidates.append(db_url)

    # 2) From Supabase project reference + password
    supabase_url = os.getenv("SUPABASE_URL", "")
    db_password = (
        os.getenv("SUPABASE_DB_PASSWORD")
        or os.getenv("DB_PASSWORD")
        or os.getenv("POSTGRES_PASSWORD")
        or os.getenv("PASSWORD")
    )
    service_key = os.getenv("SUPABASE_SERVICE_KEY")  # fallback ONLY if no DB password present

    project_ref = ""
    if "supabase.co" in supabase_url:
        try:
            project_ref = supabase_url.split("//")[1].split(".")[0]
        except Exception:
            project_ref = ""

    def add_with_password(pw: str):
        if not project_ref or not pw:
            return
        # Standard direct host
        candidates.append(f"postgresql://postgres:{pw}@db.{project_ref}.supabase.co:5432/postgres")
        # Supabase connection pooler hosts
        candidates.append(f"postgresql://postgres:{pw}@aws-0-{project_ref}.pooler.supabase.com:6543/postgres")
        candidates.append(f"postgresql://postgres:{pw}@aws-0-{project_ref}.pooler.supabase.com:5432/postgres")

    # Prefer explicit DB password, then (as last resort) the service key
    if db_password:
        add_with_password(db_password)
    elif service_key:
        add_with_password(service_key)

    return [c for c in candidates if c]


def get_supabase_connection():
    """Create a connection to the Supabase database using best-effort discovery."""
    load_env_file()

    candidates = build_candidate_connection_urls()
    if not candidates:
        raise ValueError(
            "No database connection information found. Provide DATABASE_URL or SUPABASE_URL + SUPABASE_DB_PASSWORD in the environment/.env"
        )

    last_err = None
    for url in candidates:
        try:
            masked = _mask_conn_str(url)
            print(f"Trying connection: {masked}")
            conn = psycopg2.connect(url)
            print("Connection successful!")
            return conn
        except Exception as e:
            last_err = e
            print(f"Connection failed: {type(e).__name__}: {e}")
            continue

    raise RuntimeError(f"All connection attempts failed. Last error: {last_err}")


def extract_supabase_schema() -> Dict[str, List[Dict[str, object]]]:
    """Extract schema (tables -> columns with exact PostgreSQL types and nullability) from 'public' and 'auth' schemas.

    - Public tables are kept unprefixed (e.g., trips)
    - Auth tables are prefixed with 'auth.' (e.g., auth.users)
    """
    conn = None
    try:
        conn = get_supabase_connection()
        cur = conn.cursor()

        # Use pg_catalog to get precise/pretty types (includes length, array, domains, enums)
        # relkind 'r' = ordinary table, 'p' = partitioned table
        query = """
            SELECT
                n.nspname AS schema_name,
                c.relname AS table_name,
                a.attname AS column_name,
                format_type(a.atttypid, a.atttypmod) AS data_type,
                NOT a.attnotnull AS is_nullable
            FROM pg_attribute a
            JOIN pg_class c ON a.attrelid = c.oid
            JOIN pg_namespace n ON c.relnamespace = n.oid
            WHERE a.attnum > 0
              AND NOT a.attisdropped
              AND n.nspname IN ('public','auth')
              AND c.relkind IN ('r','p')
            ORDER BY n.nspname, c.relname, a.attnum
        """
        cur.execute(query)
        rows = cur.fetchall()

        schema: Dict[str, List[Dict[str, object]]] = {}
        for schema_name, table_name, column_name, data_type, is_nullable in rows:
            if table_name in IGNORED_TABLES:
                continue
            # Prefix auth tables, keep public unprefixed for backward-compat
            key = f"auth.{table_name}" if schema_name == "auth" else table_name
            schema.setdefault(key, []).append({
                "name": column_name,
                "type": data_type,
                "nullable": bool(is_nullable),
            })

        cur.close()
        conn.close()
        return schema
    except Exception as e:
        if conn:
            try:
                conn.close()
            except Exception:
                pass
        print(f"Error extracting schema: {type(e).__name__}: {e}")
        return {}


def main():
    print("Extracting Supabase schema (tables, columns, exact data types) including 'auth'...")

    schema = extract_supabase_schema()
    if not schema:
        print("No schema data extracted.")
        return

    # Save comprehensive schema
    output_file = "supabase_schema_complete.json"
    with open(output_file, "w") as f:
        json.dump(schema, f, indent=2)
    print(f"Schema extracted and saved to {output_file}")

    # Also save/refresh simplified alias file for compatibility
    with open("supabase_schema.json", "w") as f:
        json.dump(schema, f, indent=2)
    print("Also updated supabase_schema.json")

    print(f"Found {len(schema)} tables:")
    for table_name in sorted(schema.keys()):
        print(f"  - {table_name} ({len(schema[table_name])} columns)")


if __name__ == "__main__":
    main()