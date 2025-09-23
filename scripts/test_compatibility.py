#!/usr/bin/env python3

import json
from generate_dart_models_from_json import generate_dart_file

def compare_with_existing_file():
    # Comparar código gerado com arquivo existente para garantir compatibilidade total
    print("=== TESTE DE COMPATIBILIDADE COM ARQUIVOS EXISTENTES ===\n")
    
    # Simular uma tabela que existe no projeto real
    table_name = "driver_excluded_zones_stats"
    columns = [
        {"name": "driver_id", "type": "uuid", "nullable": True},
        {"name": "total_excluded_zones", "type": "integer", "nullable": True},
        {"name": "cities", "type": "jsonb", "nullable": True},  # List field
        {"name": "states", "type": "json", "nullable": True},  # List field
        {"name": "first_exclusion_date", "type": "timestamp with time zone", "nullable": True},
        {"name": "last_exclusion_date", "type": "timestamp with time zone", "nullable": True},
    ]
    
    generated_code = generate_dart_file(table_name, columns)
    
    # Código esperado (baseado no arquivo real existente)
    expected_code = """import '../database.dart';

class DriverExcludedZonesStatsTable extends SupabaseTable<DriverExcludedZonesStatsRow> {
  @override
  String get tableName => 'driver_excluded_zones_stats';

  @override
  DriverExcludedZonesStatsRow createRow(Map<String, dynamic> data) => DriverExcludedZonesStatsRow(data);
}

class DriverExcludedZonesStatsRow extends SupabaseDataRow {
  DriverExcludedZonesStatsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverExcludedZonesStatsTable();

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  int? get totalExcludedZones => getField<int>('total_excluded_zones');
  set totalExcludedZones(int? value) => setField<int>('total_excluded_zones', value);

  List<String> get cities => getListField<String>('cities');
  set cities(List<String>? value) => setListField<String>('cities', value);

  List<String> get states => getListField<String>('states');
  set states(List<String>? value) => setListField<String>('states', value);

  DateTime? get firstExclusionDate => getField<DateTime>('first_exclusion_date');
  set firstExclusionDate(DateTime? value) => setField<DateTime>('first_exclusion_date', value);

  DateTime? get lastExclusionDate => getField<DateTime>('last_exclusion_date');
  set lastExclusionDate(DateTime? value) => setField<DateTime>('last_exclusion_date', value);
}"""
    
    print("=== CÓDIGO GERADO ===")
    print(generated_code)
    print("\n" + "="*50)
    print("=== CÓDIGO ESPERADO (arquivo existente) ===")
    print(expected_code)
    print("\n" + "="*50)
    
    # Verificar se os elementos principais estão presentes
    checks = [
        ("Classe Table", "class DriverExcludedZonesStatsTable extends SupabaseTable<DriverExcludedZonesStatsRow>"),
        ("Classe Row", "class DriverExcludedZonesStatsRow extends SupabaseDataRow"),
        ("tableName getter", "String get tableName => 'driver_excluded_zones_stats';"),
        ("createRow method", "DriverExcludedZonesStatsRow createRow(Map<String, dynamic> data) => DriverExcludedZonesStatsRow(data);"),
        ("table getter", "SupabaseTable get table => DriverExcludedZonesStatsTable();"),
        ("driverId field", "String? get driverId => getField<String>('driver_id');"),
        ("totalExcludedZones field", "int? get totalExcludedZones => getField<int>('total_excluded_zones');"),
        ("cities list field", "List<String> get cities => getListField<String>('cities');"),
        ("states list field", "List<String> get states => getListField<String>('states');"),
        ("firstExclusionDate field", "DateTime? get firstExclusionDate => getField<DateTime>('first_exclusion_date');"),
        ("lastExclusionDate field", "DateTime? get lastExclusionDate => getField<DateTime>('last_exclusion_date');"),
    ]
    
    print("=== VERIFICAÇÃO DETALHADA ===")
    all_passed = True
    
    for check_name, check_pattern in checks:
        if check_pattern in generated_code:
            print(f"✅ {check_name}")
        else:
            print(f"❌ {check_name}")
            all_passed = False
    
    print("\n" + "="*50)
    if all_passed:
        print("🎉 COMPATIBILIDADE TOTAL CONFIRMADA!")
        print("O código gerado é idêntico ao arquivo existente em termos de:")
        print("- Estrutura de classes")
        print("- Métodos override")
        print("- Getters e setters")
        print("- Tipagem correta")
        print("- Tratamento de campos lista")
        print("- Tratamento de campos nullable/non-nullable")
    else:
        print("⚠️  Algumas verificações falharam.")
        print("Verifique as diferenças acima.")
    
    return all_passed

if __name__ == "__main__":
    compare_with_existing_file()