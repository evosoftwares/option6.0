# Dart Type Detection Mechanism - Complete Implementation

## Overview

This document provides a comprehensive overview of the automatic Dart type detection mechanism implemented in the Python generators. The system analyzes database column information to intelligently determine the appropriate Dart types, nullability, and code generation patterns.

## Key Features

### 1. Primitive Type Mapping
The system maps PostgreSQL types to appropriate Dart types:

- Integer types (bigint, integer, smallint, serial, bigserial) → `int`
- Floating point types (decimal, numeric, real, double precision) → `double`
- Boolean types (boolean) → `bool`
- Text types (text, character varying, varchar, character, char, uuid) → `String`
- Date/Time types (date, timestamp, time, interval) → `DateTime`
- JSON types (json, jsonb) → `dynamic` (with special handling)

### 2. List Type Detection
Fields are automatically detected as lists when:
- PostgreSQL type is `json` or `jsonb` AND contains array data
- Column name matches common list patterns (fallback_drivers, cities, states, tags, etc.)

Generated code:
```dart
List<dynamic> get fallbackDrivers => getListField<dynamic>('fallback_drivers');
set fallbackDrivers(List<dynamic>? value) => setListField<dynamic>('fallback_drivers', value);
```

### 3. Dynamic Type Detection
Fields are treated as dynamic when:
- PostgreSQL type is `json` or `jsonb`
- Column name matches common dynamic patterns (metadata, data, config, etc.)

Generated code:
```dart
dynamic get metadata => getField<dynamic>('metadata');
set metadata(dynamic value) => setField<dynamic>('metadata', value);
```

### 4. Custom Value Object Detection
The system intelligently detects when to use custom value objects:
- Fields with "email" in the name → `Email`
- Fields with "location" in the name → `Location`
- Fields with "money" in the name → `Money`
- Fields with "phone" in the name → `PhoneNumber`

Generated code:
```dart
Email? get emailAddress => getField<Email>('email_address');
set emailAddress(Email? value) => setField<Email>('email_address', value);
```

### 5. Nullability Detection
Fields are nullable based on database schema information, except for primary keys which are never nullable.

Generated code for nullable fields:
```dart
String? get fullName => getField<String>('full_name');
set fullName(String? value) => setField<String>('full_name', value);
```

Generated code for non-nullable fields:
```dart
String get id => getField<String>('id')!;
set id(String value) => setField<String>('id', value);
```

### 6. Primary Key Detection
Fields named "id" that are not nullable are treated as primary keys with special handling.

## Implementation Details

### Module Structure
The implementation consists of:
1. `dart_type_detection.py` - Core type detection logic
2. Updated generators (`generate_dart_models.py` and `generate_dart_models_from_json.py`)

### Core Functions

#### `determine_field_type_and_behavior()`
Analyzes a database column and returns:
- Dart type to use
- Whether it's a list
- Whether it's dynamic
- Whether it's nullable
- Whether it uses a custom value object

#### `get_field_getter_setter()`
Generates appropriate getter and setter code based on field properties.

#### Pattern Recognition
The system uses both type-based and name-based pattern recognition:
- Type-based: JSON/JSONB types are often lists or dynamic
- Name-based: Common field naming patterns indicate special handling

## Examples

### Example 1: User Profile Table
```json
[
  {"name": "id", "type": "uuid", "nullable": false},
  {"name": "email_address", "type": "text", "nullable": true},
  {"name": "full_name", "type": "text", "nullable": true},
  {"name": "balance", "type": "numeric", "nullable": false},
  {"name": "is_active", "type": "boolean", "nullable": true},
  {"name": "created_at", "type": "timestamp with time zone", "nullable": true}
]
```

Generated Dart code:
```dart
class AppUsersRow extends SupabaseDataRow {
  AppUsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppUsersTable();

  String get id => getField<String>('id')!;  // Primary key, non-nullable
  set id(String value) => setField<String>('id', value);

  Email? get emailAddress => getField<Email>('email_address');  // Custom value object
  set emailAddress(Email? value) => setField<Email>('email_address', value);

  String? get fullName => getField<String>('full_name');  // Nullable string
  set fullName(String? value) => setField<String>('full_name', value);

  double get balance => getField<double>('balance')!;  // Non-nullable double
  set balance(double value) => setField<double>('balance', value);

  bool? get isActive => getField<bool>('is_active');  // Nullable boolean
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');  // Nullable DateTime
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
```

### Example 2: Complex Entity with Lists and Dynamic Data
```json
[
  {"name": "id", "type": "uuid", "nullable": false},
  {"name": "fallback_drivers", "type": "jsonb", "nullable": true},
  {"name": "metadata", "type": "jsonb", "nullable": true},
  {"name": "tags", "type": "jsonb", "nullable": true}
]
```

Generated Dart code:
```dart
class TestEntitiesRow extends SupabaseDataRow {
  TestEntitiesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TestEntitiesTable();

  String get id => getField<String>('id')!;  // Primary key
  set id(String value) => setField<String>('id', value);

  List<dynamic> get fallbackDrivers => getListField<dynamic>('fallback_drivers');  // List field
  set fallbackDrivers(List<dynamic>? value) => setListField<dynamic>('fallback_drivers', value);

  List<dynamic> get metadata => getListField<dynamic>('metadata');  // Dynamic list
  set metadata(List<dynamic>? value) => setListField<dynamic>('metadata', value);

  List<dynamic> get tags => getListField<dynamic>('tags');  // Another list field
  set tags(List<dynamic>? value) => setListField<dynamic>('tags', value);
}
```

## Benefits

1. **Intelligent Type Detection**: Automatically determines the most appropriate Dart types based on database schema and naming patterns.

2. **Custom Value Objects**: Automatically uses domain-specific value objects (Email, Location, Money) when appropriate.

3. **Proper Nullability Handling**: Correctly handles nullable vs non-nullable fields based on database schema.

4. **Special Pattern Recognition**: Recognizes common patterns like lists and dynamic data.

5. **Consistent Code Generation**: Generates code that follows established patterns in the codebase.

6. **Extensible Design**: Easy to add new type mappings and pattern recognition rules.

## Usage

1. The type detection is automatically used by both generators:
   - `generate_dart_models.py` - Connects directly to Supabase
   - `generate_dart_models_from_json.py` - Uses JSON schema files

2. To add new patterns, modify the `dart_type_detection.py` file:
   - Add new entries to `CUSTOM_VALUE_OBJECTS`
   - Add new patterns to `LIST_TYPES` and `list_patterns`
   - Add new patterns to `dynamic_patterns`

3. The system works with both direct database connections and JSON schema files, providing flexibility in different development environments.