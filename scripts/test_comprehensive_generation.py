#!/usr/bin/env python3

import json
from generate_dart_models_from_json import generate_dart_file

def test_comprehensive_generation():
    # Teste abrangente para verificar todos os tipos de campos
    table_name = "comprehensive_test"
    columns = [
        {"name": "id", "type": "uuid", "nullable": False},  # Primary key
        {"name": "user_id", "type": "uuid", "nullable": True},  # Nullable UUID
        {"name": "full_name", "type": "text", "nullable": True},  # Nullable String
        {"name": "email", "type": "text", "nullable": False},  # Non-nullable String
        {"name": "age", "type": "integer", "nullable": True},  # Nullable int
        {"name": "balance", "type": "numeric", "nullable": False},  # Non-nullable double
        {"name": "rating", "type": "double precision", "nullable": True},  # Nullable double
        {"name": "is_active", "type": "boolean", "nullable": False},  # Non-nullable bool
        {"name": "created_at", "type": "timestamp with time zone", "nullable": True},  # Nullable DateTime
        {"name": "updated_at", "type": "timestamp without time zone", "nullable": True},  # Nullable DateTime
        {"name": "profile_data", "type": "jsonb", "nullable": True},  # Dynamic field
        {"name": "tags", "type": "json", "nullable": True},  # List field
        {"name": "fallback_drivers", "type": "jsonb", "nullable": True},  # List field
        {"name": "cities", "type": "json", "nullable": True},  # List field
        {"name": "preferences", "type": "jsonb", "nullable": True},  # Dynamic list field
    ]
    
    generated_code = generate_dart_file(table_name, columns)
    
    print("=== Análise do Código Gerado ===")
    
    # Verificar estrutura básica
    assert "class ComprehensiveTestTable extends SupabaseTable<ComprehensiveTestRow>" in generated_code
    assert "class ComprehensiveTestRow extends SupabaseDataRow" in generated_code
    print("✅ Estrutura de classes correta")
    
    # Verificar primary key
    assert "String get id => getField<String>('id')!;" in generated_code
    assert "set id(String value) => setField<String>('id', value);" in generated_code
    print("✅ Primary key tratada corretamente")
    
    # Verificar campos nullable
    assert "String? get userId => getField<String>('user_id');" in generated_code
    assert "String? get fullName => getField<String>('full_name');" in generated_code
    assert "int? get age => getField<int>('age');" in generated_code
    assert "double? get rating => getField<double>('rating');" in generated_code
    assert "DateTime? get createdAt => getField<DateTime>('created_at');" in generated_code
    print("✅ Campos nullable tratados corretamente")
    
    # Verificar campos não nullable
    assert "String get email => getField<String>('email')!;" in generated_code
    assert "double get balance => getField<double>('balance')!;" in generated_code
    assert "bool get isActive => getField<bool>('is_active')!;" in generated_code
    print("✅ Campos não nullable tratados corretamente")
    
    # Verificar campos de lista
    assert "List<String> get tags => getListField<String>('tags');" in generated_code
    assert "List<String> get fallbackDrivers => getListField<String>('fallback_drivers');" in generated_code
    assert "List<String> get cities => getListField<String>('cities');" in generated_code
    print("✅ Campos de lista tratados corretamente")
    
    # Verificar campos dinâmicos
    assert "dynamic? get profileData => getField<dynamic>('profile_data');" in generated_code
    # Para preferences, como é JSONB mas não está na lista de padrões conhecidos, deve ser dynamic
    assert "List<dynamic> get preferences => getListField<dynamic>('preferences');" in generated_code
    print("✅ Campos dinâmicos tratados corretamente")
    
    # Verificar setters
    assert "set userId(String? value) => setField<String>('user_id', value);" in generated_code
    assert "set fullName(String? value) => setField<String>('full_name', value);" in generated_code
    assert "set tags(List<String>? value) => setListField<String>('tags', value);" in generated_code
    assert "set profileData(dynamic? value) => setField<dynamic>('profile_data', value);" in generated_code
    print("✅ Setters gerados corretamente")
    
    print("\n🎉 TODOS OS TESTES PASSARAM!")
    print("O código gerado é compatível com os padrões existentes.")
    
    # Mostrar parte do código gerado para inspeção visual
    print("\n=== Parte do Código Gerado (para inspeção) ===")
    lines = generated_code.split('\n')
    for i, line in enumerate(lines[:30]):  # Mostrar as primeiras 30 linhas
        print(f"{i+1:2d}: {line}")

if __name__ == "__main__":
    test_comprehensive_generation()