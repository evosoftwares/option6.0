#!/bin/bash

# Supabase to Dart Models Generator
# This script automates the process of extracting schema from Supabase and generating Dart models

set -e  # Exit on any error

echo "Supabase to Dart Models Generator"
echo "================================="

# Check if required environment variables are set
if [[ -z "$SUPABASE_URL" || -z "$SUPABASE_SERVICE_KEY" ]]; then
    echo "Error: SUPABASE_URL and SUPABASE_SERVICE_KEY environment variables must be set."
    echo "Please set them before running this script:"
    echo "  export SUPABASE_URL='https://your-project-ref.supabase.co'"
    echo "  export SUPABASE_SERVICE_KEY='your-service-key'"
    exit 1
fi

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not found."
    exit 1
fi

# Check if required Python packages are installed
if ! python3 -c "import psycopg2" &> /dev/null; then
    echo "Installing required Python packages..."
    pip install -r requirements.txt
fi

# Extract schema from Supabase
echo "Extracting schema from Supabase..."
python3 extract_supabase_schema.py

# Check if schema file was created
if [[ ! -f "supabase_schema.json" ]]; then
    echo "Error: Failed to extract schema from Supabase."
    exit 1
fi

# Generate Dart models from schema
echo "Generating Dart models from schema..."
python3 generate_dart_models_from_json.py

echo "Done! Dart models have been generated."