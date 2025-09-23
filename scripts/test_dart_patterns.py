#!/usr/bin/env python3

def test_camel_case_conversion():
    """Test the camelCase conversion function."""
    test_cases = [
        ("id", "id"),
        ("user_id", "userId"),
        ("full_name", "fullName"),
        ("created_at", "createdAt"),
        ("currentuser_uid_firebase", "currentUserUidFirebase"),
        ("vehicle_brand", "vehicleBrand"),
        ("is_online", "isOnline"),
        ("accepts_pet", "acceptsPet"),
    ]
    
    print("Testing camelCase conversion:")
    for input_str, expected in test_cases:
        # Import the function from our main script
        from generate_dart_models_from_json import to_camel_case
        result = to_camel_case(input_str)
        status = "✓" if result == expected else "✗"
        print(f"  {status} {input_str} -> {result} (expected: {expected})")

def test_pascal_case_conversion():
    """Test the PascalCase conversion function."""
    test_cases = [
        ("app_users", "AppUsers"),
        ("drivers", "Drivers"),
        ("activity_logs", "ActivityLogs"),
        ("driver_excluded_zones_stats", "DriverExcludedZonesStats"),
    ]
    
    print("Testing PascalCase conversion:")
    for input_str, expected in test_cases:
        # Import the function from our main script
        from generate_dart_models_from_json import to_pascal_case
        result = to_pascal_case(input_str)
        status = "✓" if result == expected else "✗"
        print(f"  {status} {input_str} -> {result} (expected: {expected})")

def test_type_mapping():
    """Test the PostgreSQL to Dart type mapping."""
    test_cases = [
        ("uuid", "String"),
        ("text", "String"),
        ("integer", "int"),
        ("bigint", "int"),
        ("boolean", "bool"),
        ("timestamp with time zone", "DateTime"),
        ("json", "dynamic"),
        ("jsonb", "dynamic"),
        ("double precision", "double"),
        ("numeric", "double"),
    ]
    
    print("Testing type mapping:")
    for input_str, expected in test_cases:
        # Import the function from our main script
        from generate_dart_models_from_json import dart_type
        result = dart_type(input_str)
        status = "✓" if result == expected else "✗"
        print(f"  {status} {input_str} -> {result} (expected: {expected})")

def test_list_type_detection():
    """Test the list type detection."""
    test_cases = [
        ("json", True),
        ("jsonb", True),
        ("text", False),
        ("integer", False),
        ("uuid", False),
        ("timestamp with time zone", False),
    ]
    
    print("Testing list type detection:")
    for input_str, expected in test_cases:
        # Import the function from our main script
        from generate_dart_models_from_json import needs_list_type
        result = needs_list_type(input_str)
        status = "✓" if result == expected else "✗"
        print(f"  {status} {input_str} -> {result} (expected: {expected})")

def test_primary_key_detection():
    """Test the primary key detection."""
    test_cases = [
        ("id", False, True),   # id + not nullable = primary key
        ("id", True, False),   # id + nullable = not primary key
        ("user_id", False, False),  # user_id + not nullable = not primary key
        ("user_id", True, False),   # user_id + nullable = not primary key
        ("name", False, False),     # name + not nullable = not primary key
    ]
    
    print("Testing primary key detection:")
    for col_name, nullable, expected in test_cases:
        # Import the function from our main script
        from generate_dart_models_from_json import is_primary_key
        # Note: is_primary_key expects (col_name, nullable) where we want True when NOT nullable
        result = is_primary_key(col_name, nullable)
        status = "✓" if result == expected else "✗"
        print(f"  {status} {col_name}, nullable={nullable} -> {result} (expected: {expected})")

def main():
    """Run all tests."""
    print("Running pattern validation tests...\\n")
    
    test_camel_case_conversion()
    print()
    
    test_pascal_case_conversion()
    print()
    
    test_type_mapping()
    print()
    
    test_list_type_detection()
    print()
    
    test_primary_key_detection()
    print()
    
    print("Pattern validation tests completed.")

if __name__ == "__main__":
    main()