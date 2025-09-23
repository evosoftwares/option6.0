#!/bin/bash

# Setup script for Supabase to Dart Models Generator

echo "Setting up Supabase to Dart Models Generator..."

# Check if requirements.txt exists
if [[ ! -f "requirements.txt" ]]; then
    echo "Error: requirements.txt not found. Please make sure you're running this script from the project root."
    exit 1
fi

# Install required Python packages
echo "Installing required Python packages..."
pip install -r requirements.txt

# Make the main script executable
echo "Making generate_dart_models.sh executable..."
chmod +x generate_dart_models.sh

echo "Setup complete!"
echo ""
echo "To use the generator, you need to set the following environment variables:"
echo "  export SUPABASE_URL='https://your-project-ref.supabase.co'"
echo "  export SUPABASE_SERVICE_KEY='your-service-key'"
echo ""
echo "Then run the generator with:"
echo "  ./generate_dart_models.sh"