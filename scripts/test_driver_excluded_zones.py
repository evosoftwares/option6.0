#!/usr/bin/env python3

# Teste de geração de arquivo para verificar conformidade com arquivos existentes
import json
from generate_dart_models_from_json import generate_dart_file

def test_driver_excluded_zones_stats_generation():
    # Teste para gerar código equivalente ao driver_excluded_zones_stats.dart
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
    print("=== Código Gerado ===")
    print(generated_code)
    print("\n=== Código Existente (Referência) ===")
    print("""import '../database.dart';

class DriverExcludedZonesStatsTable
    extends SupabaseTable<DriverExcludedZonesStatsRow> {
  @override
  String get tableName => 'driver_excluded_zones_stats';

  @override
  DriverExcludedZonesStatsRow createRow(Map<String, dynamic> data) =>
      DriverExcludedZonesStatsRow(data);
}

class DriverExcludedZonesStatsRow extends SupabaseDataRow {
  DriverExcludedZonesStatsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DriverExcludedZonesStatsTable();

  String? get driverId => getField<String>('driver_id');
  set driverId(String? value) => setField<String>('driver_id', value);

  int? get totalExcludedZones => getField<int>('total_excluded_zones');
  set totalExcludedZones(int? value) =>
      setField<int>('total_excluded_zones', value);

  List<String> get cities => getListField<String>('cities');
  set cities(List<String>? value) => setListField<String>('cities', value);

  List<String> get states => getListField<String>('states');
  set states(List<String>? value) => setListField<String>('states', value);

  DateTime? get firstExclusionDate =>
      getField<DateTime>('first_exclusion_date');
  set firstExclusionDate(DateTime? value) =>
      setField<DateTime>('first_exclusion_date', value);

  DateTime? get lastExclusionDate => getField<DateTime>('last_exclusion_date');
  set lastExclusionDate(DateTime? value) =>
      setField<DateTime>('last_exclusion_date', value);
}""")
    
    # Verificar se os campos de lista estão corretos
    assert "List<String> get cities => getListField<String>('cities');" in generated_code
    assert "List<String> get states => getListField<String>('states');" in generated_code
    assert "set cities(List<String>? value) => setListField<String>('cities', value);" in generated_code
    assert "set states(List<String>? value) => setListField<String>('states', value);" in generated_code
    
    print("\n✅ Todos os campos de lista estão corretos!")

if __name__ == "__main__":
    test_driver_excluded_zones_stats_generation()