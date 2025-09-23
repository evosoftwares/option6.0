#!/usr/bin/env python3

import os
import json
from typing import Dict, List, Any

# Configuration
DART_OUTPUT_DIR = "lib/backend/supabase/database/tables"

# Reserved property names that conflict with SupabaseDataRow
RESERVED_PROPERTIES = {
    'data', 'table', 'toJson', 'toString', 'hashCode', 'runtimeType'
}

# Type mapping
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
}

def to_camel_case(snake_str: str) -> str:
    """Convert snake_case to camelCase."""
    components = snake_str.split('_')
    return components[0] + ''.join(word.capitalize() for word in components[1:])

def to_pascal_case(snake_str: str) -> str:
    """Convert snake_case to PascalCase."""
    return ''.join(word.capitalize() for word in snake_str.split('_'))

def dart_type(pg_type: str) -> str:
    """Convert PostgreSQL type to Dart type."""
    return TYPE_MAPPING.get(pg_type, "String")

def is_primary_key(column_name: str, nullable: bool) -> bool:
    """Check if column is a primary key."""
    return column_name == "id" and not nullable

def fix_dynamic_types_in_file(file_path: str):
    """Fix dynamic? types to just dynamic in a Dart file."""
    try:
        with open(file_path, 'r') as f:
            content = f.read()
        
        # Replace dynamic? with dynamic
        content = content.replace('dynamic?', 'dynamic')
        
        # Fix conflicting property names
        for reserved in RESERVED_PROPERTIES:
            camel_reserved = to_camel_case(reserved)
            # Replace getter/setter for reserved properties
            content = content.replace(
                f"get {camel_reserved} =>",
                f"get {camel_reserved}Field =>"
            )
            content = content.replace(
                f"set {camel_reserved}(",
                f"set {camel_reserved}Field("
            )
        
        with open(file_path, 'w') as f:
            f.write(content)
        
        print(f"Fixed {file_path}")
    except Exception as e:
        print(f"Error fixing {file_path}: {e}")

def fix_all_dart_files():
    """Fix all Dart files in the tables directory."""
    if not os.path.exists(DART_OUTPUT_DIR):
        print(f"Directory {DART_OUTPUT_DIR} does not exist")
        return
    
    dart_files = [f for f in os.listdir(DART_OUTPUT_DIR) if f.endswith('.dart')]
    
    for dart_file in dart_files:
        file_path = os.path.join(DART_OUTPUT_DIR, dart_file)
        fix_dynamic_types_in_file(file_path)
    
    print(f"Fixed {len(dart_files)} Dart files")

def regenerate_problematic_files():
    """Regenerate files that have known issues."""
    problematic_files = [
        'test_entities.dart',
        'test_table.dart',
        'comprehensive_test.dart'
    ]
    
    # Load schema
    schema_file = "supabase_schema_complete.json"
    if not os.path.exists(schema_file):
        print(f"Schema file {schema_file} not found")
        return
    
    with open(schema_file, 'r') as f:
        schema = json.load(f)
    
    for file_name in problematic_files:
        table_name = file_name.replace('.dart', '')
        if table_name in schema:
            file_path = os.path.join(DART_OUTPUT_DIR, file_name)
            generate_fixed_dart_file(table_name, schema[table_name], file_path)

def generate_fixed_dart_file(table_name: str, columns: List[Dict[str, Any]], output_path: str):
    """Generate a fixed Dart file for a table."""
    class_name = to_pascal_case(table_name)
    
    # File header
    content = ["import '../database.dart';", ""]
    
    # Table class
    content.extend([
        f"class {class_name}Table extends SupabaseTable<{class_name}Row> {{",
        "  @override",
        f"  String get tableName => '{table_name}';",
        "",
        "  @override",
        f"  {class_name}Row createRow(Map<String, dynamic> data) => {class_name}Row(data);",
        "}",
        ""
    ])
    
    # Row class
    content.extend([
        f"class {class_name}Row extends SupabaseDataRow {{",
        f"  {class_name}Row(Map<String, dynamic> data) : super(data);",
        "",
        "  @override",
        f"  SupabaseTable get table => {class_name}Table();",
        ""
    ])
    
    # Generate getters and setters
    for col in columns:
        col_name = col["name"]
        col_type = dart_type(col["type"])
        nullable = col["nullable"]
        is_pk = is_primary_key(col_name, nullable)
        
        # Skip reserved property names or rename them
        camel_name = to_camel_case(col_name)
        if camel_name in RESERVED_PROPERTIES:
            camel_name = f"{camel_name}Field"
        
        # Handle dynamic types (never nullable)
        if col_type == "dynamic":
            content.extend([
                f"  dynamic get {camel_name} => getField<dynamic>('{col_name}');",
                f"  set {camel_name}(dynamic value) => setField<dynamic>('{col_name}', value);",
                ""
            ])
        elif is_pk:
            # Primary key - non-nullable
            content.extend([
                f"  {col_type} get {camel_name} => getField<{col_type}>('{col_name}')!;",
                f"  set {camel_name}({col_type} value) => setField<{col_type}>('{col_name}', value);",
                ""
            ])
        else:
            # Regular field
            type_annotation = f"{col_type}{'?' if nullable else ''}"
            null_assertion = '' if nullable else '!'
            content.extend([
                f"  {type_annotation} get {camel_name} => getField<{col_type}>('{col_name}'){null_assertion};",
                f"  set {camel_name}({type_annotation} value) => setField<{col_type}>('{col_name}', value);",
                ""
            ])
    
    content.append("}")
    
    # Write file
    with open(output_path, 'w') as f:
        f.write("\n".join(content))
    
    print(f"Regenerated {output_path}")

def main():
    """Main function to fix Dart generation issues."""
    print("Fixing Dart generation issues...")
    
    # Fix existing files
    fix_all_dart_files()
    
    # Regenerate problematic files
    regenerate_problematic_files()
    
    print("\nDone! Run 'flutter analyze lib/backend/supabase/database/' to check for remaining issues.")

if __name__ == "__main__":
    main()