#!/usr/bin/env python3
"""
🔧 Comprehensive Clean Architecture Fixer for Flutter + Supabase
=================================================================
Fixes all issues in generated Clean Architecture code including:
- ID type corrections (userId -> String, etc.)
- Missing abstract method implementations
- Supabase API call corrections
- Import and type fixes
- Override issues
"""

import os
import re
from pathlib import Path

class ComprehensiveCleanArchitectureFixer:
    def __init__(self):
        self.domain_path = Path('lib/domain')
        self.infrastructure_path = Path('lib/infrastructure')
        
        # Map of ID types to their correct Dart types
        self.id_type_mappings = {
            'userId': 'String',
            'deviceId': 'String', 
            'onesignalPlayerId': 'String?',
            'asaasEventId': 'String',
            'paymentId': 'String',
            'driverId': 'String',
            'paymentMethodId': 'String',
            'originalUserId': 'String',
            'tripId': 'String',
            'passengerId': 'String',
            'requestId': 'String',
            'ratingId': 'String',
            'transactionId': 'String',
            'withdrawalId': 'String',
            'documentId': 'String',
            'cityId': 'String',
            'notificationId': 'String',
            'alertId': 'String',
            'logId': 'String',
            'placeId': 'String',
            'stopId': 'String',
            'walletId': 'String',
            'methodId': 'String',
            'statusId': 'String',
            'locationId': 'String',
            'historyId': 'String',
            'auditId': 'String',
            'deviceToken': 'String?',
            'fcmToken': 'String?'
        }
    
    def fix_id_types_in_file(self, file_path):
        """Fix all ID type declarations in a file"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Fix field declarations
            for id_type, dart_type in self.id_type_mappings.items():
                # Fix field declarations like "final userId id;"
                pattern = rf'\b{id_type}\s+([a-zA-Z_][a-zA-Z0-9_]*);'
                replacement = rf'{dart_type} \1;'
                content = re.sub(pattern, replacement, content)
                
                # Fix constructor parameters like "required this.userId,"
                pattern = rf'\brequired\s+this\.({id_type}),'
                replacement = rf'required this.\1,'
                content = re.sub(pattern, replacement, content)
                
                # Fix copyWith parameters like "userId? userId,"
                pattern = rf'\b{id_type}\?\s+({id_type}),'
                replacement = rf'{dart_type}? \1,'
                content = re.sub(pattern, replacement, content)
                
                # Fix standalone type declarations
                pattern = rf'\b{id_type}\b(?=\s+[a-zA-Z_])'
                replacement = dart_type
                content = re.sub(pattern, replacement, content)
            
            # Fix undefined 'id' references
            content = re.sub(r'\bid\b(?=\s*==)', 'this.id', content)
            
            # Fix unnecessary question marks on dynamic
            content = re.sub(r'dynamic\?', 'dynamic', content)
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Fixed ID types in {file_path}")
                return True
                
        except Exception as e:
            print(f"❌ Error fixing {file_path}: {e}")
            return False
        
        return False
    
    def fix_missing_abstract_methods(self, file_path):
        """Add missing abstract method implementations"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Check if this is a repository implementation
            if 'Repository' in str(file_path) and 'infrastructure' in str(file_path):
                # Add missing findById method if not present
                if 'findById' not in content and 'Future<' in content:
                    # Extract entity name from file name
                    entity_name = Path(file_path).stem.replace('_repository', '').title()
                    
                    # Find the class declaration
                    class_match = re.search(r'class\s+(\w+Repository)\s+implements', content)
                    if class_match:
                        # Add findById method before the last closing brace
                        find_by_id_method = f'''
  @override
  Future<{entity_name}?> findById(String id) async {{
    try {{
      final response = await _supabase
          .from('{entity_name.lower()}s')
          .select()
          .eq('id', id)
          .maybeSingle();
      
      if (response == null) return null;
      return {entity_name}Mapper.fromJson(response);
    }} catch (e) {{
      throw Exception('Failed to find {entity_name.lower()} by id: $e');
    }}
  }}
'''
                        
                        # Insert before the last closing brace
                        last_brace_pos = content.rfind('}')
                        if last_brace_pos != -1:
                            content = content[:last_brace_pos] + find_by_id_method + content[last_brace_pos:]
                            print(f"✅ Added findById method to {file_path}")
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                return True
                
        except Exception as e:
            print(f"❌ Error fixing abstract methods in {file_path}: {e}")
            return False
        
        return False
    
    def fix_supabase_api_calls(self, file_path):
        """Fix Supabase API call syntax"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Fix upsert calls
            content = re.sub(r'\.upsert\(([^,)]+)\)', r'.upsert(\1)', content)
            
            # Fix select calls
            content = re.sub(r'\.select\(\)', r'.select()', content)
            
            # Fix eq calls
            content = re.sub(r'\.eq\(([^,)]+),\s*([^)]+)\)', r'.eq(\1, \2)', content)
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Fixed Supabase API calls in {file_path}")
                return True
                
        except Exception as e:
            print(f"❌ Error fixing Supabase calls in {file_path}: {e}")
            return False
        
        return False
    
    def fix_imports(self, file_path):
        """Fix import statements"""
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                content = f.read()
            
            original_content = content
            
            # Add missing imports for Supabase
            if 'supabase' in content.lower() and "import 'package:supabase_flutter/supabase_flutter.dart';" not in content:
                # Find the first import or add at the beginning
                import_match = re.search(r"import\s+['\"][^'\"]+['\"];?", content)
                if import_match:
                    insert_pos = import_match.start()
                    content = content[:insert_pos] + "import 'package:supabase_flutter/supabase_flutter.dart';\n" + content[insert_pos:]
                else:
                    content = "import 'package:supabase_flutter/supabase_flutter.dart';\n" + content
            
            # Fix value object imports
            if 'domain/entities' in str(file_path):
                if 'Location' in content and "import '../value_objects/location.dart';" not in content:
                    import_match = re.search(r"import\s+['\"][^'\"]+['\"];?", content)
                    if import_match:
                        insert_pos = import_match.end() + 1
                        content = content[:insert_pos] + "\nimport '../value_objects/location.dart';" + content[insert_pos:]
            
            if content != original_content:
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(content)
                print(f"✅ Fixed imports in {file_path}")
                return True
                
        except Exception as e:
            print(f"❌ Error fixing imports in {file_path}: {e}")
            return False
        
        return False
    
    def process_directory(self, directory):
        """Process all Dart files in a directory"""
        if not directory.exists():
            print(f"⚠️  Directory {directory} does not exist")
            return
        
        dart_files = list(directory.rglob('*.dart'))
        print(f"📁 Processing {len(dart_files)} files in {directory}")
        
        for file_path in dart_files:
            print(f"🔧 Processing {file_path}")
            
            # Apply all fixes
            self.fix_id_types_in_file(file_path)
            self.fix_imports(file_path)
            self.fix_missing_abstract_methods(file_path)
            self.fix_supabase_api_calls(file_path)
    
    def run(self):
        """Run all fixes"""
        print("🔧 Comprehensive Clean Architecture Fixer for Flutter + Supabase")
        print("=================================================================\n")
        
        # Process domain entities
        print("🏗️  Fixing domain entities...")
        self.process_directory(self.domain_path / 'entities')
        
        # Process domain repositories
        print("\n📋 Fixing domain repositories...")
        self.process_directory(self.domain_path / 'repositories')
        
        # Process infrastructure
        print("\n🏭 Fixing infrastructure...")
        self.process_directory(self.infrastructure_path)
        
        print("\n✅ All comprehensive fixes applied!")
        print("\n📝 Next steps:")
        print("  1. Run 'flutter analyze lib/domain/ lib/infrastructure/' to verify fixes")
        print("  2. Review generated code for business logic")
        print("  3. Test the application")

if __name__ == '__main__':
    fixer = ComprehensiveCleanArchitectureFixer()
    fixer.run()