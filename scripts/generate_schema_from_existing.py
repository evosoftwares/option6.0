#!/usr/bin/env python3

import os
import json
import re
from typing import Dict, List, Any

# Directory containing existing Dart table files
TABLES_DIR = "lib/backend/supabase/database/tables"

def extract_columns_from_dart_file(file_path: str) -> List[Dict[str, Any]]:
    """Extract column information from a Dart table file."""
    columns = []
    
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Look for getter methods that represent columns
        # Pattern: Type? get columnName => getField<Type>('column_name');
        getter_pattern = r'(\w+(?:\?|<[^>]+>)?)\s+get\s+(\w+)\s*=>\s*getField<[^>]+>\([\'"]([^\'"]*)[\'"]\'?'
        
        matches = re.findall(getter_pattern, content)
        
        for match in matches:
            dart_type, getter_name, column_name = match
            
            # Convert Dart type to PostgreSQL type
            pg_type = dart_to_pg_type(dart_type)
            nullable = '?' in dart_type or 'dynamic' in dart_type
            
            columns.append({
                "name": column_name,
                "type": pg_type,
                "nullable": nullable
            })
    
    except Exception as e:
        print(f"Error reading {file_path}: {e}")
    
    return columns

def dart_to_pg_type(dart_type: str) -> str:
    """Convert Dart type to PostgreSQL type."""
    # Remove nullable marker and generics
    clean_type = dart_type.replace('?', '').strip()
    
    # Handle List types
    if clean_type.startswith('List<'):
        return 'jsonb'
    
    # Basic type mapping
    type_mapping = {
        'int': 'integer',
        'double': 'double precision',
        'String': 'text',
        'bool': 'boolean',
        'DateTime': 'timestamp with time zone',
        'dynamic': 'jsonb'
    }
    
    return type_mapping.get(clean_type, 'text')

def generate_schema_from_existing_files() -> Dict[str, List[Dict[str, Any]]]:
    """Generate schema by analyzing existing Dart table files."""
    schema = {}
    
    if not os.path.exists(TABLES_DIR):
        print(f"Directory {TABLES_DIR} does not exist")
        return schema
    
    # Get all .dart files in the tables directory
    dart_files = [f for f in os.listdir(TABLES_DIR) if f.endswith('.dart')]
    
    for dart_file in dart_files:
        table_name = dart_file.replace('.dart', '')
        file_path = os.path.join(TABLES_DIR, dart_file)
        
        print(f"Analyzing {dart_file}...")
        columns = extract_columns_from_dart_file(file_path)
        
        if columns:
            schema[table_name] = columns
            print(f"  Found {len(columns)} columns")
        else:
            print(f"  No columns found")
    
    return schema

def create_comprehensive_schema() -> Dict[str, List[Dict[str, Any]]]:
    """Create a comprehensive schema with all known tables."""
    # Start with existing schema if available
    existing_schema_file = "supabase_schema.json"
    schema = {}
    
    if os.path.exists(existing_schema_file):
        try:
            with open(existing_schema_file, 'r') as f:
                schema = json.load(f)
            print(f"Loaded existing schema with {len(schema)} tables")
        except Exception as e:
            print(f"Error loading existing schema: {e}")
    
    # Add tables from existing Dart files
    dart_schema = generate_schema_from_existing_files()
    
    # Merge schemas (Dart files take precedence)
    for table_name, columns in dart_schema.items():
        if table_name not in schema or len(columns) > len(schema.get(table_name, [])):
            schema[table_name] = columns
    
    # Add common tables that might be missing
    common_tables = {
        "trips": [
            {"name": "id", "type": "uuid", "nullable": False},
            {"name": "passenger_id", "type": "uuid", "nullable": True},
            {"name": "driver_id", "type": "uuid", "nullable": True},
            {"name": "origin_address", "type": "text", "nullable": True},
            {"name": "destination_address", "type": "text", "nullable": True},
            {"name": "status", "type": "text", "nullable": True},
            {"name": "created_at", "type": "timestamp with time zone", "nullable": True}
        ],
        "passengers": [
            {"name": "id", "type": "uuid", "nullable": False},
            {"name": "user_id", "type": "uuid", "nullable": True},
            {"name": "rating", "type": "double precision", "nullable": True},
            {"name": "total_trips", "type": "integer", "nullable": True},
            {"name": "created_at", "type": "timestamp with time zone", "nullable": True}
        ],
        "ratings": [
            {"name": "id", "type": "uuid", "nullable": False},
            {"name": "trip_id", "type": "uuid", "nullable": True},
            {"name": "rater_id", "type": "uuid", "nullable": True},
            {"name": "rated_id", "type": "uuid", "nullable": True},
            {"name": "rating", "type": "integer", "nullable": True},
            {"name": "comment", "type": "text", "nullable": True},
            {"name": "created_at", "type": "timestamp with time zone", "nullable": True}
        ]
    }
    
    # Add common tables if not already present
    for table_name, columns in common_tables.items():
        if table_name not in schema:
            schema[table_name] = columns
    
    return schema

def main():
    """Main function to generate comprehensive schema."""
    print("Generating comprehensive Supabase schema...")
    
    # Generate comprehensive schema
    schema = create_comprehensive_schema()
    
    if not schema:
        print("No schema data generated.")
        return
    
    # Save schema to JSON file
    output_file = "supabase_schema_complete.json"
    with open(output_file, "w") as f:
        json.dump(schema, f, indent=2)
    
    print(f"\nComprehensive schema saved to {output_file}")
    print(f"Found {len(schema)} tables:")
    for table_name in sorted(schema.keys()):
        print(f"  - {table_name} ({len(schema[table_name])} columns)")
    
    # Also update the original schema file
    with open("supabase_schema.json", "w") as f:
        json.dump(schema, f, indent=2)
    print(f"\nUpdated supabase_schema.json with complete schema")

if __name__ == "__main__":
    main()