# Supabase to Dart Models Generator

This tool automatically generates Dart model files for your Supabase database tables that match the exact patterns used in your existing `lib/backend/supabase/database/` files.

## Features

- Generates Dart model files that exactly match your existing code patterns
- Automatically updates the `database.dart` file with new table exports
- Handles various PostgreSQL data types with appropriate Dart equivalents
- Supports nullable and non-nullable fields
- Properly handles primary keys and list types
- Excludes system tables automatically

## Prerequisites

1. Python 3.6+
2. Supabase project with database tables

## Installation

1. Install the required Python packages:

```bash
pip install -r requirements.txt
```

## Configuration

The script requires two environment variables:

1. `SUPABASE_URL` - Your Supabase project URL (e.g., `https://your-project-ref.supabase.co`)
2. `SUPABASE_SERVICE_KEY` - Your Supabase service key (found in Settings > API)

You can set these in your terminal:

```bash
export SUPABASE_URL="https://your-project-ref.supabase.co"
export SUPABASE_SERVICE_KEY="your-service-key-here"
```

## Usage Options

### Option 1: Direct Database Connection (Recommended)

This method connects directly to your Supabase database and generates models for all tables:

```bash
python generate_dart_models.py
```

### Option 2: From JSON Schema File

If you prefer to work with a JSON schema file:

1. First, extract your schema to a JSON file:
   ```bash
   python extract_supabase_schema.py
   ```

2. Then generate Dart models from the JSON:
   ```bash
   python generate_dart_models_from_json.py
   ```

You can also specify a custom JSON file:
```bash
python generate_dart_models_from_json.py path/to/your/schema.json
```

## How it Works

### Generated File Structure

For each table in your database, the script generates two Dart classes:

1. **Table Class** (e.g., `AppUsersTable`) - Extends `SupabaseTable<RowType>`
2. **Row Class** (e.g., `AppUsersRow`) - Extends `SupabaseDataRow` with getters and setters

### Example Output

For a table named `app_users`, the generated file would look like:

```dart
import '../database.dart';

class AppUsersTable extends SupabaseTable<AppUsersRow> {
  @override
  String get tableName => 'app_users';

  @override
  AppUsersRow createRow(Map<String, dynamic> data) => AppUsersRow(data);
}

class AppUsersRow extends SupabaseDataRow {
  AppUsersRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppUsersTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get email => getField<String>('email');
  set email(String? value) => setField<String>('email', value);

  String? get fullName => getField<String>('full_name');
  set fullName(String? value) => setField<String>('full_name', value);
  // ... other fields
}
```

## Customization

You can modify the scripts to:

1. Ignore specific tables by adding them to the `IGNORED_TABLES` set
2. Add more PostgreSQL to Dart type mappings in the `TYPE_MAPPING` dictionary
3. Change the output directory by modifying `DART_OUTPUT_DIR`

## Troubleshooting

### Connection Issues

If you encounter connection issues:

1. Verify your `SUPABASE_URL` and `SUPABASE_SERVICE_KEY` are correct
2. Ensure your Supabase project allows connections from your IP address
3. Check that you're using the service key (not the anon key) for database access

### Permission Errors

If you get permission errors:

1. Make sure you're using a service key with sufficient privileges
2. Verify that your database user has access to the `information_schema` tables

### Generated Files Not Appearing

If generated files don't appear in your project:

1. Check that the `DART_OUTPUT_DIR` path is correct
2. Ensure you have write permissions to the output directory
3. Verify that the script is running from the correct working directory

## File Structure

After running the scripts, you'll have:

```
lib/
└── backend/
    └── supabase/
        └── database/
            ├── tables/
            │   ├── table1.dart
            │   ├── table2.dart
            │   └── ...
            ├── database.dart
            ├── row.dart
            └── table.dart
```

The `database.dart` file will be automatically updated to include exports for any new tables.