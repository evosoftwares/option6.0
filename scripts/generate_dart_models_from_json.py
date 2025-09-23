#!/usr/bin/env python3

import os
import sys
import json
from typing import Dict, List, Any

# Dart generation configuration
DART_OUTPUT_DIR = "lib/backend/supabase/database/tables"
IGNORED_TABLES = {
    "pg_stat_statements", "pg_stat_statements_info", 
    "pg_buffercache", "pgstattuple",
    # Add any other system tables you want to ignore
}

# Mapping PostgreSQL types to Dart types
TYPE_MAPPING = {
    "bigint": "int",
    "integer": "int",
    "smallint": "int",
    "decimal": "double",
    "numeric": "double",
    "real": "double",
    "double precision": "double",
    "serial": "int",
    "bigserial": "int",
    "boolean": "bool",
    "text": "String",
    "character varying": "String",
    "varchar": "String",
    "character": "String",
    "char": "String",
    "uuid": "String",
    "date": "DateTime",
    "timestamp without time zone": "DateTime",
    "timestamp with time zone": "DateTime",
    "time without time zone": "DateTime",
    "time with time zone": "DateTime",
    "interval": "DateTime",
    "json": "dynamic",
    "jsonb": "dynamic",
    # Add more mappings as needed
}

# Special naming cases mapping
SPECIAL_NAMING_CASES = {
    'currentUser_UID_Firebase': 'currentUserUidFirebase',
    # Add more special cases here as needed
}

# Types that should be treated as lists when containing array data
LIST_TYPES = {"json", "jsonb"}

# Name-based pattern detection for common list fields
LIST_PATTERNS = [
    "fallback_drivers", "cities", "states", "tags", "categories",
    "items", "options", "permissions", "roles", "addresses",
    "target_cities", "target_categories", "passenger_rating_tags",
    "driver_rating_tags", "shared_with_users"
]

# Specific element types for common list fields
LIST_ELEMENT_TYPES = {
    "fallback_drivers": "String",
    "cities": "String",
    "states": "String",
    "tags": "String",
    "categories": "String",
    "items": "String",
    "options": "String",
    "permissions": "String",
    "roles": "String",
    "addresses": "String",
    "target_cities": "String",
    "target_categories": "String",
    "passenger_rating_tags": "String",
    "driver_rating_tags": "String",
    "shared_with_users": "String"
}

# Name-based pattern detection for common dynamic fields
DYNAMIC_PATTERNS = [
    "metadata", "data", "payload", "config", "settings", 
    "attributes", "properties", "old_values", "new_values",
    "polygon_coordinates", "card_data", "pix_data", "device_info"
]

def load_schema_from_json(json_file_path: str) -> Dict[str, List[Dict[str, Any]]]:
    """Load schema information from a JSON file."""
    try:
        with open(json_file_path, 'r') as f:
            return json.load(f)
    except Exception as e:
        print(f"Error loading schema from JSON: {e}")
        return {}

def to_camel_case(snake_str: str) -> str:
    """Convert snake_case to camelCase with special case handling."""
    # Check for special cases first
    if snake_str in SPECIAL_NAMING_CASES:
        return SPECIAL_NAMING_CASES[snake_str]
    
    if not snake_str:
        return snake_str
    components = snake_str.split('_')
    return components[0] + ''.join(x.capitalize() for x in components[1:])

def to_pascal_case(snake_str: str) -> str:
    """Convert snake_case to PascalCase."""
    if not snake_str:
        return snake_str
    components = snake_str.split('_')
    return ''.join(x.capitalize() for x in components)

def dart_type(pg_type: str) -> str:
    """Convert PostgreSQL type to Dart type."""
    return TYPE_MAPPING.get(pg_type.lower(), "dynamic")

def get_list_element_type(column_name: str) -> str:
    """Get the element type for list fields."""
    # Check for specific element types first
    for pattern, element_type in LIST_ELEMENT_TYPES.items():
        if pattern in column_name.lower():
            return element_type
    
    # Default to dynamic for unknown list types
    return "dynamic"

def needs_list_type(pg_type: str, column_name: str = "") -> bool:
    """Check if the type should be treated as a list based on PostgreSQL type and column name patterns."""
    # Name-based pattern detection takes precedence
    if any(pattern in column_name.lower() for pattern in LIST_PATTERNS):
        return True
    
    # Direct type-based detection for JSON/JSONB types
    if pg_type.lower() in LIST_TYPES:
        # But not if it's also a dynamic field pattern
        if any(pattern in column_name.lower() for pattern in DYNAMIC_PATTERNS):
            return False
        return True
    
    return False

def is_dynamic_type(pg_type: str, column_name: str = "") -> bool:
    """Check if the type should be treated as dynamic."""
    # Direct type-based detection
    if pg_type.lower() in ["json", "jsonb"]:
        return True
    
    # Name-based pattern detection for common dynamic fields
    if any(pattern in column_name.lower() for pattern in DYNAMIC_PATTERNS):
        return True
    
    return False

def is_primary_key(column_name: str, nullable: bool) -> bool:
    """Determine if a column is a primary key."""
    # Primary keys are non-nullable columns named 'id'
    return column_name == 'id' and not nullable

def generate_dart_file(table_name: str, columns: List[Dict[str, Any]]) -> str:
    """Generate Dart file content for a table following the exact patterns in the existing files."""
    class_name = to_pascal_case(table_name)
    
    # Generate imports - exactly as in existing files
    imports = [
        "import '../database.dart';",
        ""
    ]
    
    # Generate table class - exactly as in existing files
    table_class = [
        f"class {class_name}Table extends SupabaseTable<{class_name}Row> {{",
        f"  @override",
        f"  String get tableName => '{table_name}';",
        "",
        f"  @override",
        f"  {class_name}Row createRow(Map<String, dynamic> data) => {class_name}Row(data);",
        "}",
        ""
    ]
    
    # Generate row class - exactly as in existing files
    row_class = [
        f"class {class_name}Row extends SupabaseDataRow {{",
        f"  {class_name}Row(Map<String, dynamic> data) : super(data);",
        "",
        f"  @override",
        f"  SupabaseTable get table => {class_name}Table();",
        ""
    ]
    
    # Generate getters and setters for each column - exactly as in existing files
    for column in columns:
        col_name = column["name"]
        col_type = dart_type(column["type"])
        nullable = column.get("nullable", True)  # Default to True if not specified
        is_list = needs_list_type(column["type"], col_name)
        is_dynamic = is_dynamic_type(column["type"], col_name)
        is_pk = is_primary_key(col_name, not nullable)
        
        # Override type if dynamic
        if is_dynamic:
            col_type = "dynamic"
        
        # Handle list types specially (like cities, states in driver_excluded_zones_stats)
        if is_list:
            # Get specific element type for the list
            element_type = get_list_element_type(col_name)
            # For JSON/JSONB list types, elements are typically dynamic unless specified
            if column["type"].lower() in LIST_TYPES and element_type == "dynamic":
                element_type = "dynamic"
            
            # For JSON/JSONB fields that are lists, use getListField/setListField
            getter = [
                f"  List<{element_type}> get {to_camel_case(col_name)} => getListField<{element_type}>('{col_name}');"
            ]
            setter = [
                f"  set {to_camel_case(col_name)}(List<{element_type}>? value) => setListField<{element_type}>('{col_name}', value);"
            ]
        else:
            # For regular fields
            if is_pk:
                # Primary key - non-nullable with ! assertion
                getter = [
                    f"  {col_type} get {to_camel_case(col_name)} => getField<{col_type}>('{col_name}')!;"
                ]
                setter = [
                    f"  set {to_camel_case(col_name)}({col_type} value) => setField<{col_type}>('{col_name}', value);"
                ]
            else:
                # Regular field - nullable with ? 
                type_annotation = f"{col_type}{'?' if nullable else ''}"
                null_assertion = '' if nullable else '!'
                getter = [
                    f"  {type_annotation} get {to_camel_case(col_name)} => getField<{col_type}>('{col_name}'){null_assertion};"
                ]
                setter = [
                    f"  set {to_camel_case(col_name)}({type_annotation} value) => setField<{col_type}>('{col_name}', value);"
                ]
        
        row_class.extend(getter)
        row_class.extend(setter)
        row_class.append("")
    
    # Close the row class
    row_class.append("}")
    
    # Combine all parts with exact spacing as in existing files
    content = imports + table_class + row_class
    
    return "\n".join(content)

def update_database_exports(tables: List[str]):
    """Update the database.dart file to include new table exports."""
    database_file = os.path.join(DART_OUTPUT_DIR, "..", "database.dart")
    
    if not os.path.exists(database_file):
        print(f"Warning: {database_file} not found. Skipping export update.")
        return
    
    try:
        with open(database_file, "r") as f:
            content = f.read()
        
        # Split content into lines
        lines = content.split("\n")
        
        # Find where table exports end (look for the last table export)
        insert_index = -1
        for i in range(len(lines) - 1, -1, -1):
            if lines[i].startswith("export 'tables/"):
                insert_index = i + 1
                break
        
        # If we couldn't find where to insert, add before the last line
        if insert_index == -1:
            insert_index = len(lines) - 1
            
        # Generate new export lines for tables that don't already exist
        existing_exports = set()
        for line in lines:
            if line.startswith("export 'tables/"):
                table_name = line.split("/")[-1].replace(".dart';", "")
                existing_exports.add(table_name)
        
        new_exports = []
        for table in tables:
            if table not in existing_exports:
                new_exports.append(f"export 'tables/{table}.dart';")
        
        if not new_exports:
            print("No new tables to add to exports")
            return
            
        # Sort new exports alphabetically
        new_exports.sort()
        
        # Insert the new exports
        lines = lines[:insert_index] + new_exports + lines[insert_index:]
        
        # Write back to file
        with open(database_file, "w") as f:
            f.write("\n".join(lines))
            
        print(f"Updated {database_file} with {len(new_exports)} new table exports")
        
    except Exception as e:
        print(f"Warning: Could not update {database_file}: {e}")

def create_sample_schema_file():
    """Create a sample schema JSON file."""
    sample_schema = {
        "app_users": [
            {"name": "id", "type": "uuid", "nullable": False},
            {"name": "email", "type": "text", "nullable": True},
            {"name": "full_name", "type": "text", "nullable": True},
            {"name": "phone", "type": "text", "nullable": True},
            {"name": "photo_url", "type": "text", "nullable": True},
            {"name": "user_type", "type": "text", "nullable": True},
            {"name": "status", "type": "text", "nullable": True},
            {"name": "created_at", "type": "timestamp with time zone", "nullable": True},
        ],
        "drivers": [
            {"name": "id", "type": "uuid", "nullable": False},
            {"name": "user_id", "type": "uuid", "nullable": True},
            {"name": "vehicle_brand", "type": "text", "nullable": True},
            {"name": "vehicle_model", "type": "text", "nullable": True},
            {"name": "vehicle_year", "type": "integer", "nullable": True},
            {"name": "vehicle_color", "type": "text", "nullable": True},
            {"name": "vehicle_plate", "type": "text", "nullable": True},
            {"name": "vehicle_category", "type": "text", "nullable": True},
        ]
    }
    
    with open("supabase_schema.json", "w") as f:
        json.dump(sample_schema, f, indent=2)
    
    print("Created sample schema file: supabase_schema.json")
    print("Modify this file to match your actual database schema.")

def main():
    """Main function to generate Dart models from JSON schema."""
    print("Generating Dart models from JSON schema...")
    
    # Check if schema file is provided as argument
    if len(sys.argv) > 1:
        schema_file = sys.argv[1]
    else:
        schema_file = "supabase_schema.json"
        # If schema file doesn't exist, create a sample one
        if not os.path.exists(schema_file):
            create_sample_schema_file()
    
    # Check if schema file exists
    if not os.path.exists(schema_file):
        print(f"Schema file {schema_file} not found.")
        return
    
    # Load schema from JSON
    schema = load_schema_from_json(schema_file)
    
    if not schema:
        print("No schema data found.")
        return
    
    # Create output directory if it doesn't exist
    os.makedirs(DART_OUTPUT_DIR, exist_ok=True)
    
    # Filter out ignored tables
    filtered_schema = {k: v for k, v in schema.items() if k not in IGNORED_TABLES}
    
    if not filtered_schema:
        print("No tables found in schema.")
        return
    
    # Generate Dart files for each table
    generated_tables = []
    for table_name, columns in filtered_schema.items():
        try:
            # Skip tables with no columns
            if not columns:
                continue
                
            # Generate file content
            content = generate_dart_file(table_name, columns)
            
            # Write to file
            file_path = os.path.join(DART_OUTPUT_DIR, f"{table_name}.dart")
            with open(file_path, "w") as f:
                f.write(content)
            
            generated_tables.append(table_name)
            print(f"Generated {file_path}")
            
        except Exception as e:
            print(f"Error generating {table_name}.dart: {e}")
    
    # Update database.dart exports
    if generated_tables:
        update_database_exports(generated_tables)
    
    print(f"Successfully generated {len(generated_tables)} Dart model files")

if __name__ == "__main__":
    main()