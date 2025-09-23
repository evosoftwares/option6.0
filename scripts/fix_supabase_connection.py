#!/usr/bin/env python3

import os
import json
import psycopg2
from psycopg2 import sql

# Configuration - Update these values with your Supabase details
SUPABASE_URL = os.getenv("SUPABASE_URL", "")
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_KEY", "")

# Tables to ignore
IGNORED_TABLES = {
    "pg_stat_statements", "pg_stat_statements_info", 
    "pg_buffercache", "pgstattuple",
    # Add any other system tables you want to ignore
}

def get_supabase_connection():
    """Create a connection to the Supabase database."""
    if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
        raise ValueError("SUPABASE_URL and SUPABASE_SERVICE_KEY environment variables must be set")
    
    # Parse the Supabase URL to extract connection details
    # Supabase URL format: https://[project-ref].supabase.co
    # Database connection: postgresql://postgres:[service-key]@db.[project-ref].supabase.co:5432/postgres
    if "supabase.co" in SUPABASE_URL:
        # Extract project reference from URL
        project_ref = SUPABASE_URL.split("//")[1].split(".")[0]
        # Try different connection formats
        connection_urls = [
            f"postgresql://postgres:{SUPABASE_SERVICE_KEY}@db.{project_ref}.supabase.co:5432/postgres",
            f"postgresql://postgres.{project_ref}:{SUPABASE_SERVICE_KEY}@aws-0-{project_ref}.pooler.supabase.com:5432/postgres",
            f"postgresql://postgres.{project_ref}:{SUPABASE_SERVICE_KEY}@aws-0-{project_ref}.pooler.supabase.com:6543/postgres"
        ]
    else:
        raise ValueError("Invalid Supabase URL format")
    
    for db_url in connection_urls:
        try:
            print(f"Trying connection: {db_url[:50]}...")
            conn = psycopg2.connect(db_url)
            print("Connection successful!")
            return conn
        except Exception as e:
            print(f"Connection failed: {e}")
            continue
    
    print("All connection attempts failed")
    return None

def extract_supabase_schema() -> dict:
    """Extract schema information from Supabase and save as JSON."""
    conn = get_supabase_connection()
    if not conn:
        print("Could not connect to Supabase.")
        return {}
    
    try:
        cursor = conn.cursor()
        
        # Query to get table schema information
        query = """
        SELECT 
            table_name, 
            column_name, 
            data_type, 
            is_nullable
        FROM information_schema.columns 
        WHERE table_schema = 'public'
        ORDER BY table_name, ordinal_position
        """
        
        cursor.execute(query)
        rows = cursor.fetchall()
        
        # Organize data by table
        schema = {}
        for row in rows:
            table_name, column_name, data_type, is_nullable = row
            
            # Skip ignored tables
            if table_name in IGNORED_TABLES:
                continue
                
            # Initialize table entry if not exists
            if table_name not in schema:
                schema[table_name] = []
            
            # Add column information
            schema[table_name].append({
                "name": column_name,
                "type": data_type,
                "nullable": is_nullable == "YES"
            })
        
        cursor.close()
        conn.close()
        
        return schema
    except Exception as e:
        print(f"Error fetching schema: {e}")
        if conn:
            conn.close()
        return {}

def main():
    """Main function to extract Supabase schema and save as JSON."""
    print("Extracting Supabase schema...")
    
    # Check if required environment variables are set
    if not SUPABASE_URL or not SUPABASE_SERVICE_KEY:
        print("Error: SUPABASE_URL and SUPABASE_SERVICE_KEY environment variables are not set.")
        print("Please set them to connect to your Supabase instance.")
        return
    
    # Extract schema
    schema = extract_supabase_schema()
    
    if not schema:
        print("No schema data extracted.")
        return
    
    # Save schema to JSON file
    output_file = "supabase_schema_complete.json"
    with open(output_file, "w") as f:
        json.dump(schema, f, indent=2)
    
    print(f"Schema extracted and saved to {output_file}")
    print(f"Found {len(schema)} tables:")
    for table_name in sorted(schema.keys()):
        print(f"  - {table_name} ({len(schema[table_name])} columns)")

if __name__ == "__main__":
    main()