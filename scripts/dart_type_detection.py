#!/usr/bin/env python3
"""
Dart Type Detection Module

This module provides mechanisms for automatically detecting Dart field types
based on PostgreSQL column information and analyzing existing Dart entity patterns.
"""

from typing import Dict, List, Any, Tuple, Optional
import re
import json

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

# Types that should be treated as lists when containing array data
LIST_TYPES = {"json", "jsonb"}

# Custom value objects that should be used instead of primitive types
CUSTOM_VALUE_OBJECTS = {
    "email": "Email",
    "location": "Location",
    "money": "Money",
    "phone_number": "PhoneNumber"
}

def dart_type(pg_type: str) -> str:
    """Convert PostgreSQL type to Dart type."""
    return TYPE_MAPPING.get(pg_type.lower(), "dynamic")

def needs_list_type(pg_type: str, column_name: str = "") -> bool:
    """Check if the type should be treated as a list based on PostgreSQL type and column name patterns."""
    # Direct type-based detection
    if pg_type.lower() in LIST_TYPES:
        return True
    
    # Name-based pattern detection for common list fields
    list_patterns = [
        "fallback_drivers", "cities", "states", "tags", "categories",
        "items", "options", "permissions", "roles", "addresses"
    ]
    
    if any(pattern in column_name.lower() for pattern in list_patterns):
        return True
    
    return False

def is_dynamic_type(pg_type: str, column_name: str = "") -> bool:
    """Check if the type should be treated as dynamic."""
    # Direct type-based detection
    if pg_type.lower() in ["json", "jsonb"]:
        return True
    
    # Name-based pattern detection for common dynamic fields
    dynamic_patterns = [
        "metadata", "data", "payload", "config", "settings", 
        "attributes", "properties", "old_values", "new_values",
        "polygon_coordinates", "card_data", "pix_data", "device_info"
    ]
    
    if any(pattern in column_name.lower() for pattern in dynamic_patterns):
        return True
    
    return False

def is_custom_value_object(column_name: str, pg_type: str) -> Optional[str]:
    """Check if the column should use a custom value object instead of a primitive type."""
    # Check if column name suggests a custom value object
    for key, value_object in CUSTOM_VALUE_OBJECTS.items():
        if key in column_name.lower():
            # Additional check for appropriate types
            if pg_type.lower() in ["text", "character varying", "varchar"]:
                return value_object
    
    return None

def is_nullable_type(column_info: Dict[str, Any]) -> bool:
    """Determine if a column should be nullable in Dart."""
    nullable = column_info.get("nullable", True)
    return nullable

def is_primary_key(column_name: str, nullable: bool) -> bool:
    """Determine if a column is a primary key."""
    return column_name == 'id' and not nullable

def determine_field_type_and_behavior(
    column_info: Dict[str, Any]
) -> Tuple[str, bool, bool, bool, Optional[str]]:
    """
    Determine the Dart type and behavior for a database column.
    
    Returns:
        Tuple of (dart_type, is_list, is_dynamic, is_nullable, custom_value_object)
    """
    column_name = column_info["name"]
    pg_type = column_info["type"]
    nullable = is_nullable_type(column_info)
    is_pk = is_primary_key(column_name, not nullable)
    
    # Check for custom value objects first
    custom_value_object = is_custom_value_object(column_name, pg_type)
    
    # Determine base Dart type
    if custom_value_object:
        base_dart_type = custom_value_object
    else:
        base_dart_type = dart_type(pg_type)
    
    # Check if it should be a list
    is_list = needs_list_type(pg_type, column_name)
    
    # Check if it should be dynamic
    is_dynamic = is_dynamic_type(pg_type, column_name)
    
    # Override type if dynamic
    if is_dynamic:
        base_dart_type = "dynamic"
    
    # For list types, we need to specify the element type
    if is_list and not is_dynamic:
        # For JSON/JSONB list types, elements are typically dynamic
        if pg_type.lower() in LIST_TYPES:
            element_type = "dynamic"
        else:
            element_type = base_dart_type
        base_dart_type = element_type
    
    # Primary keys are never nullable, others depend on database schema
    final_nullable = not is_pk and nullable
    
    return base_dart_type, is_list, is_dynamic, final_nullable, custom_value_object

def get_field_getter_setter(
    column_name: str,
    dart_type: str,
    is_list: bool,
    is_dynamic: bool,
    is_nullable: bool,
    is_primary_key: bool,
    custom_value_object: Optional[str],
    camel_case_name: str
) -> Tuple[List[str], List[str]]:
    """
    Generate getter and setter code for a field based on its properties.
    """
    
    if is_list:
        # For list types, use getListField/setListField
        getter = [
            f"  List<{dart_type}> get {camel_case_name} => getListField<{dart_type}>('{column_name}');"
        ]
        setter = [
            f"  set {camel_case_name}(List<{dart_type}>? value) => setListField<{dart_type}>('{column_name}', value);"
        ]
    elif is_primary_key:
        # Primary key - non-nullable with ! assertion
        getter = [
            f"  {dart_type} get {camel_case_name} => getField<{dart_type}>('{column_name}')!;"
        ]
        setter = [
            f"  set {camel_case_name}({dart_type} value) => setField<{dart_type}>('{column_name}', value);"
        ]
    else:
        # Regular field - nullable or not based on database schema
        type_annotation = f"{dart_type}{'?' if is_nullable else ''}"
        getter = [
            f"  {type_annotation} get {camel_case_name} => getField<{dart_type}>('{column_name}'){'' if is_nullable else '!'};"
        ]
        setter = [
            f"  set {camel_case_name}({type_annotation} value) => setField<{dart_type}>('{column_name}', value);"
        ]
    
    return getter, setter

def to_camel_case(snake_str: str) -> str:
    """Convert snake_case to camelCase."""
    if not snake_str:
        return snake_str
    components = snake_str.split('_')
    # Handle special case for Firebase UID field
    if snake_str == "currentuser_uid_firebase":
        return "currentUserUidFirebase"
    return components[0] + ''.join(x.capitalize() for x in components[1:])

def to_pascal_case(snake_str: str) -> str:
    """Convert snake_case to PascalCase."""
    if not snake_str:
        return snake_str
    components = snake_str.split('_')
    return ''.join(x.capitalize() for x in components)

def is_primary_key(column_name: str, nullable: bool) -> bool:
    """Determine if a column is a primary key."""
    # Primary keys are non-nullable columns named 'id'
    return column_name == 'id' and not nullable

def analyze_existing_dart_entities(entities_dir: str) -> Dict[str, Any]:
    """
    Analyze existing Dart entity files to understand patterns and improve type detection.
    
    This function would parse Dart files to extract:
    - Common field naming patterns
    - Custom value object usage
    - Type usage patterns
    - List vs dynamic usage patterns
    """
    # This is a simplified implementation - in practice, this would parse Dart files
    patterns = {
        "list_patterns": ["fallback_drivers", "cities", "states", "tags"],
        "dynamic_patterns": ["metadata", "oldValues", "newValues", "polygonCoordinates"],
        "custom_objects": ["Email", "Location", "Money"],
        "common_types": ["String", "int", "double", "bool", "DateTime", "dynamic"]
    }
    
    return patterns

# Example usage
if __name__ == "__main__":
    # Example column information
    example_columns = [
        {"name": "id", "type": "uuid", "nullable": False},
        {"name": "email", "type": "text", "nullable": True},
        {"name": "fallback_drivers", "type": "jsonb", "nullable": True},
        {"name": "metadata", "type": "jsonb", "nullable": True},
        {"name": "balance", "type": "numeric", "nullable": False},
        {"name": "is_active", "type": "boolean", "nullable": True},
        {"name": "created_at", "type": "timestamp with time zone", "nullable": True}
    ]
    
    print("Dart Type Detection Analysis:")
    print("=" * 50)
    
    for column in example_columns:
        dart_type_result, is_list, is_dynamic, is_nullable, custom_obj = determine_field_type_and_behavior(column)
        is_pk = is_primary_key(column["name"], not column["nullable"])
        camel_name = to_camel_case(column["name"])
        
        print(f"\nColumn: {column['name']}")
        print(f"  PostgreSQL Type: {column['type']}")
        print(f"  Dart Type: {dart_type_result}")
        print(f"  Is List: {is_list}")
        print(f"  Is Dynamic: {is_dynamic}")
        print(f"  Is Nullable: {is_nullable}")
        print(f"  Is Primary Key: {is_pk}")
        print(f"  Custom Value Object: {custom_obj or 'None'}")
        
        getter, setter = get_field_getter_setter(
            column["name"], dart_type_result, is_list, is_dynamic, 
            is_nullable, is_pk, custom_obj, camel_name
        )
        
        print(f"  Getter: {getter[0]}")
        print(f"  Setter: {setter[0]}")