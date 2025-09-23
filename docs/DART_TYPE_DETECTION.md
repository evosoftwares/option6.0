# Dart Type Detection Mechanism

This document explains how the automatic Dart type detection works in the Python generator.

## Overview

The type detection mechanism analyzes database column information to determine:
1. What Dart type to use (String, int, double, bool, DateTime, dynamic, etc.)
2. Whether a field should be treated as a list
3. Whether a field should be treated as dynamic
4. Whether a field should use a custom value object
5. Whether a field is nullable
6. Whether a field is a primary key

## Type Detection Logic

### 1. Primitive Types

Primitive types are determined by mapping PostgreSQL types to Dart types:

```python
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
```

### 2. List Types

Fields are treated as lists when:
1. The PostgreSQL type is `json` or `jsonb` AND the data contains arrays
2. The column name matches common list patterns:
   - `fallback_drivers`
   - `cities`
   - `states`
   - `tags`
   - `categories`
   - `items`
   - `options`
   - `permissions`
   - `roles`
   - `addresses`

### 3. Dynamic Types

Fields are treated as dynamic when:
1. The PostgreSQL type is `json` or `jsonb`
2. The column name matches common dynamic patterns:
   - `metadata`
   - `data`
   - `payload`
   - `config`
   - `settings`
   - `attributes`
   - `properties`
   - `old_values`
   - `new_values`
   - `polygon_coordinates`
   - `card_data`
   - `pix_data`
   - `device_info`

### 4. Custom Value Objects

Fields use custom value objects when the column name suggests a specific type:
- `email` → `Email`
- `location` → `Location`
- `money` → `Money`
- `phone_number` → `PhoneNumber`

This only applies to text-based columns.

### 5. Nullability

Fields are nullable based on the database schema, except for primary keys which are never nullable.

### 6. Primary Keys

Fields are considered primary keys when:
- Column name is `id`
- Column is not nullable

## Code Generation Patterns

### Regular Fields

```dart
// Nullable field
String? get fieldName => getField<String>('field_name');

// Non-nullable field (primary key)
String get id => getField<String>('id')!;

// Setter for nullable field
set fieldName(String? value) => setField<String>('field_name', value);
```

### List Fields

```dart
// List field
List<String> get fallbackDrivers => getListField<String>('fallback_drivers');
set fallbackDrivers(List<String>? value) => setListField<String>('fallback_drivers', value);
```

### Dynamic Fields

```dart
// Dynamic field
dynamic get metadata => getField<dynamic>('metadata');
set metadata(dynamic value) => setField<dynamic>('metadata', value);
```

## Usage

The type detection is used in both generators:
1. `generate_dart_models.py` - Connects directly to Supabase
2. `generate_dart_models_from_json.py` - Uses JSON schema file

Both use the same `determine_field_type_and_behavior` function to analyze columns and the `get_field_getter_setter` function to generate appropriate code.

## Examples

### Example 1: Simple String Field
```json
{"name": "email", "type": "text", "nullable": true}
```
Result:
```dart
String? get email => getField<String>('email');
set email(String? value) => setField<String>('email', value);
```

### Example 2: List Field
```json
{"name": "fallback_drivers", "type": "jsonb", "nullable": true}
```
Result:
```dart
List<dynamic> get fallbackDrivers => getListField<dynamic>('fallback_drivers');
set fallbackDrivers(List<dynamic>? value) => setListField<dynamic>('fallback_drivers', value);
```

### Example 3: Dynamic Field
```json
{"name": "metadata", "type": "jsonb", "nullable": true}
```
Result:
```dart
dynamic get metadata => getField<dynamic>('metadata');
set metadata(dynamic value) => setField<dynamic>('metadata', value);
```

### Example 4: Primary Key
```json
{"name": "id", "type": "uuid", "nullable": false}
```
Result:
```dart
String get id => getField<String>('id')!;
set id(String value) => setField<String>('id', value);
```

### Example 5: Custom Value Object
```json
{"name": "email_address", "type": "text", "nullable": true}
```
Result:
```dart
Email? get emailAddress => getField<Email>('email_address');
set emailAddress(Email? value) => setField<Email>('email_address', value);
```