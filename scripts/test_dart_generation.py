#!/usr/bin/env python3
"""
Test suite to validate that the generated Dart code conforms to existing patterns.
"""

import unittest
import tempfile
import os
import json
from generate_dart_models_from_json import (
    to_camel_case, to_pascal_case, dart_type, needs_list_type, 
    is_dynamic_type, is_primary_key, generate_dart_file, get_list_element_type
)

class TestDartGeneration(unittest.TestCase):
    
    def test_camel_case_conversion(self):
        """Test camelCase conversion with special cases."""
        test_cases = [
            ("id", "id"),
            ("user_id", "userId"),
            ("full_name", "fullName"),
            ("created_at", "createdAt"),
            ("currentUser_UID_Firebase", "currentUserUidFirebase"),  # Special case - exact match
            ("vehicle_brand", "vehicleBrand"),
            ("is_online", "isOnline"),
            ("accepts_pet", "acceptsPet"),
            ("fallback_drivers", "fallbackDrivers"),  # List field
        ]
        
        for input_str, expected in test_cases:
            with self.subTest(input_str=input_str):
                result = to_camel_case(input_str)
                self.assertEqual(result, expected)
    
    def test_pascal_case_conversion(self):
        """Test PascalCase conversion."""
        test_cases = [
            ("app_users", "AppUsers"),
            ("drivers", "Drivers"),
            ("activity_logs", "ActivityLogs"),
            ("driver_excluded_zones_stats", "DriverExcludedZonesStats"),
        ]
        
        for input_str, expected in test_cases:
            with self.subTest(input_str=input_str):
                result = to_pascal_case(input_str)
                self.assertEqual(result, expected)
    
    def test_type_mapping(self):
        """Test PostgreSQL to Dart type mapping."""
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
        
        for input_str, expected in test_cases:
            with self.subTest(input_str=input_str):
                result = dart_type(input_str)
                self.assertEqual(result, expected)
    
    def test_list_type_detection(self):
        """Test list type detection."""
        # Test name-based pattern detection (takes precedence)
        list_field_names = [
            "fallback_drivers", "cities", "states", "tags", "categories",
            "items", "options", "permissions", "roles", "addresses",
            "target_cities", "target_categories", "passenger_rating_tags",
            "driver_rating_tags", "shared_with_users"
        ]
        
        for field_name in list_field_names:
            with self.subTest(field_name=field_name):
                self.assertTrue(needs_list_type("text", field_name))
        
        # Test direct type-based detection for JSON/JSONB (when not dynamic)
        self.assertTrue(needs_list_type("json", "some_other_field"))
        self.assertTrue(needs_list_type("jsonb", "another_field"))
        
        # Test that dynamic patterns override JSON/JSONB list detection
        self.assertFalse(needs_list_type("json", "metadata"))  # metadata is dynamic
        self.assertFalse(needs_list_type("jsonb", "data"))     # data is dynamic
    
    def test_list_element_type_detection(self):
        """Test list element type detection."""
        # Test specific element types
        test_cases = [
            ("fallback_drivers", "String"),
            ("cities", "String"),
            ("states", "String"),
            ("tags", "String"),
            ("categories", "String"),
            ("items", "String"),
            ("options", "String"),
            ("permissions", "String"),
            ("roles", "String"),
            ("addresses", "String"),
            ("target_cities", "String"),
            ("target_categories", "String"),
            ("passenger_rating_tags", "String"),
            ("driver_rating_tags", "String"),
            ("shared_with_users", "String"),
            ("unknown_list_field", "dynamic"),  # Default case
        ]
        
        for field_name, expected in test_cases:
            with self.subTest(field_name=field_name):
                result = get_list_element_type(field_name)
                self.assertEqual(result, expected)
    
    def test_dynamic_type_detection(self):
        """Test dynamic type detection."""
        # Test direct type-based detection
        self.assertTrue(is_dynamic_type("json", "metadata"))
        self.assertTrue(is_dynamic_type("jsonb", "data"))
        self.assertFalse(is_dynamic_type("text", "name"))
        
        # Test name-based pattern detection
        dynamic_field_names = [
            "metadata", "data", "payload", "config", "settings", 
            "attributes", "properties", "old_values", "new_values",
            "polygon_coordinates", "card_data", "pix_data", "device_info"
        ]
        
        for field_name in dynamic_field_names:
            with self.subTest(field_name=field_name):
                self.assertTrue(is_dynamic_type("text", field_name))
    
    def test_primary_key_detection(self):
        """Test primary key detection."""
        # Primary key: id + not nullable
        self.assertTrue(is_primary_key("id", False))
        
        # Not primary key: id + nullable
        self.assertFalse(is_primary_key("id", True))
        
        # Not primary key: user_id + not nullable
        self.assertFalse(is_primary_key("user_id", False))
        
        # Not primary key: name + not nullable
        self.assertFalse(is_primary_key("name", False))
    
    def test_generate_simple_table(self):
        """Test generating a simple table with various field types."""
        table_name = "test_table"
        columns = [
            {"name": "id", "type": "uuid", "nullable": False},  # Primary key
            {"name": "name", "type": "text", "nullable": True},  # Nullable string
            {"name": "count", "type": "integer", "nullable": True},  # Nullable int
            {"name": "is_active", "type": "boolean", "nullable": True},  # Nullable bool
            {"name": "created_at", "type": "timestamp with time zone", "nullable": True},  # Nullable DateTime
        ]
        
        generated_code = generate_dart_file(table_name, columns)
        
        # Check that the code contains expected patterns
        self.assertIn("class TestTableTable extends SupabaseTable<TestTableRow>", generated_code)
        self.assertIn("class TestTableRow extends SupabaseDataRow", generated_code)
        self.assertIn("String get id => getField<String>('id')!;", generated_code)
        self.assertIn("String? get name => getField<String>('name');", generated_code)
        self.assertIn("int? get count => getField<int>('count');", generated_code)
        self.assertIn("bool? get isActive => getField<bool>('is_active');", generated_code)
        self.assertIn("DateTime? get createdAt => getField<DateTime>('created_at');", generated_code)
    
    def test_generate_table_with_list_fields(self):
        """Test generating a table with list fields."""
        table_name = "test_list_table"
        columns = [
            {"name": "id", "type": "uuid", "nullable": False},  # Primary key
            {"name": "fallback_drivers", "type": "jsonb", "nullable": True},  # List field (name-based)
            {"name": "cities", "type": "json", "nullable": True},  # List field (name-based)
        ]
        
        generated_code = generate_dart_file(table_name, columns)
        
        # Check that the code contains expected list patterns with correct element types
        self.assertIn("List<String> get fallbackDrivers => getListField<String>('fallback_drivers');", generated_code)
        self.assertIn("List<String> get cities => getListField<String>('cities');", generated_code)
        self.assertIn("set fallbackDrivers(List<String>? value) => setListField<String>('fallback_drivers', value);", generated_code)
        self.assertIn("set cities(List<String>? value) => setListField<String>('cities', value);", generated_code)
    
    def test_generate_table_with_dynamic_fields(self):
        """Test generating a table with dynamic fields."""
        table_name = "test_dynamic_table"
        columns = [
            {"name": "id", "type": "uuid", "nullable": False},  # Primary key
            {"name": "metadata", "type": "jsonb", "nullable": True},  # Dynamic field
            {"name": "config", "type": "json", "nullable": True},  # Dynamic field
        ]
        
        generated_code = generate_dart_file(table_name, columns)
        
        # Check that the code contains expected dynamic patterns
        self.assertIn("dynamic? get metadata => getField<dynamic>('metadata');", generated_code)
        self.assertIn("dynamic? get config => getField<dynamic>('config');", generated_code)
        self.assertIn("set metadata(dynamic? value) => setField<dynamic>('metadata', value);", generated_code)
        self.assertIn("set config(dynamic? value) => setField<dynamic>('config', value);", generated_code)

if __name__ == "__main__":
    unittest.main()