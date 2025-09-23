#!/usr/bin/env python3
"""
Gerador de Clean Architecture para Flutter + Supabase (Versão Corrigida)

Este script analisa as tabelas Supabase existentes e gera automaticamente:
- Domain Entities
- Repository Contracts
- Infrastructure Repositories (com API correta)
- Mappers
- Value Objects

Uso: python3 generate_clean_architecture.py
"""

import os
import re
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from dataclasses import dataclass
from datetime import datetime

@dataclass
class Field:
    name: str
    dart_type: str
    is_nullable: bool
    is_list: bool = False
    supabase_field: str = ""
    
    def __post_init__(self):
        if not self.supabase_field:
            # Converter camelCase para snake_case
            self.supabase_field = self._camel_to_snake(self.name)
    
    def _camel_to_snake(self, name: str) -> str:
        """Converte camelCase para snake_case"""
        s1 = re.sub('(.)([A-Z][a-z]+)', r'\1_\2', name)
        return re.sub('([a-z0-9])([A-Z])', r'\1_\2', s1).lower()
    
    @property
    def domain_type(self) -> str:
        """Retorna o tipo apropriado para a entidade de domínio"""
        type_mapping = {
            'String': 'String',
            'int': 'int',
            'double': 'double',
            'bool': 'bool',
            'DateTime': 'DateTime',
            'List<String>': 'List<String>',
        }
        
        base_type = type_mapping.get(self.dart_type, self.dart_type)
        
        # Aplicar nullability
        if self.is_nullable and not base_type.endswith('?'):
            return f"{base_type}?"
        return base_type
    
    @property
    def value_object_type(self) -> Optional[str]:
        """Retorna o tipo de Value Object se aplicável"""
        if self.name.endswith('Id') and self.dart_type == 'String':
            return self.name.replace('Id', '') + 'Id'
        elif self.name == 'email':
            return 'Email'
        elif self.name in ['phone', 'phoneNumber']:
            return 'PhoneNumber'
        elif 'latitude' in self.name.lower() or 'longitude' in self.name.lower():
            return None  # Será tratado como Location
        return None

@dataclass
class Table:
    name: str
    class_name: str
    fields: List[Field]
    table_class_name: str = ""
    
    def __post_init__(self):
        if not self.table_class_name:
            self.table_class_name = f"{self.class_name}Table"
    
    @property
    def entity_name(self) -> str:
        """Nome da entidade de domínio"""
        # Remove sufixos comuns e singulariza
        name = self.class_name.replace('Table', '').replace('Row', '')
        if name.endswith('s') and name not in ['AppUsers', 'UserDevices']:
            name = name[:-1]  # Remove 's' do plural
        return name
    
    @property
    def has_location_fields(self) -> bool:
        """Verifica se a tabela tem campos de localização"""
        lat_fields = [f for f in self.fields if 'latitude' in f.name.lower()]
        lng_fields = [f for f in self.fields if 'longitude' in f.name.lower()]
        return len(lat_fields) > 0 and len(lng_fields) > 0
    
    @property
    def location_pairs(self) -> List[Tuple[str, str]]:
        """Retorna pares de campos latitude/longitude"""
        pairs = []
        lat_fields = [f for f in self.fields if 'latitude' in f.name.lower()]
        
        for lat_field in lat_fields:
            prefix = lat_field.name.replace('Latitude', '').replace('latitude', '')
            lng_field_name = f"{prefix}Longitude" if prefix else "longitude"
            lng_field_name_alt = f"{prefix}longitude" if prefix else "longitude"
            
            lng_field = next((f for f in self.fields if f.name in [lng_field_name, lng_field_name_alt]), None)
            if lng_field:
                pairs.append((lat_field.name, lng_field.name))
        
        return pairs

class SupabaseTableParser:
    """Parser para arquivos de tabela Supabase"""
    
    def __init__(self, tables_dir: str):
        self.tables_dir = Path(tables_dir)
        self.tables: List[Table] = []
    
    def parse_all_tables(self) -> List[Table]:
        """Analisa todas as tabelas no diretório"""
        dart_files = list(self.tables_dir.glob("*.dart"))
        
        for file_path in dart_files:
            try:
                table = self._parse_table_file(file_path)
                if table:
                    self.tables.append(table)
                    print(f"✅ Parsed: {table.name} ({len(table.fields)} fields)")
            except Exception as e:
                print(f"❌ Error parsing {file_path.name}: {e}")
        
        return self.tables
    
    def _parse_table_file(self, file_path: Path) -> Optional[Table]:
        """Analisa um arquivo de tabela específico"""
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        # Extrair nome da tabela
        table_name_match = re.search(r"String get tableName => '([^']+)'", content)
        if not table_name_match:
            return None
        
        table_name = table_name_match.group(1)
        
        # Extrair nome da classe Row
        class_match = re.search(r"class (\w+)Row extends SupabaseDataRow", content)
        if not class_match:
            return None
        
        class_name = class_match.group(1)
        
        # Extrair nome da classe Table
        table_class_match = re.search(r"class (\w+Table) extends SupabaseTable", content)
        table_class_name = table_class_match.group(1) if table_class_match else f"{class_name}Table"
        
        # Extrair campos
        fields = self._extract_fields(content)
        
        return Table(
            name=table_name, 
            class_name=class_name, 
            fields=fields,
            table_class_name=table_class_name
        )
    
    def _extract_fields(self, content: str) -> List[Field]:
        """Extrai campos da classe Row"""
        fields = []
        
        # Padrão para getters
        getter_pattern = r"(\w+)\?? get (\w+) => getField<([^>]+)>\('([^']+)'\)"
        getter_matches = re.findall(getter_pattern, content)
        
        for match in getter_matches:
            dart_type, field_name, generic_type, supabase_field = match
            
            # Determinar se é nullable
            is_nullable = '?' in dart_type or '?' in generic_type
            
            # Limpar tipos
            clean_type = generic_type.replace('?', '')
            
            # Verificar se é lista
            is_list = clean_type.startswith('List<')
            
            fields.append(Field(
                name=field_name,
                dart_type=clean_type,
                is_nullable=is_nullable,
                is_list=is_list,
                supabase_field=supabase_field
            ))
        
        # Padrão para getListField
        list_pattern = r"List<(\w+)> get (\w+) =>\s*getListField<\w+>\('([^']+)'\)"
        list_matches = re.findall(list_pattern, content)
        
        for match in list_matches:
            item_type, field_name, supabase_field = match
            
            # Verificar se já foi adicionado pelo padrão anterior
            if not any(f.name == field_name for f in fields):
                fields.append(Field(
                    name=field_name,
                    dart_type=f"List<{item_type}>",
                    is_nullable=False,
                    is_list=True,
                    supabase_field=supabase_field
                ))
        
        return fields

class CleanArchitectureGenerator:
    """Gerador de código Clean Architecture"""
    
    def __init__(self, output_dir: str):
        self.output_dir = Path(output_dir)
        self.domain_dir = self.output_dir / "lib" / "domain"
        self.application_dir = self.output_dir / "lib" / "application"
        self.infrastructure_dir = self.output_dir / "lib" / "infrastructure"
        
        # Criar diretórios
        self._create_directories()
    
    def _create_directories(self):
        """Cria estrutura de diretórios"""
        directories = [
            self.domain_dir / "entities",
            self.domain_dir / "repositories",
            self.domain_dir / "value_objects",
            self.application_dir / "use_cases",
            self.application_dir / "services",
            self.infrastructure_dir / "repositories",
            self.infrastructure_dir / "mappers",
        ]
        
        for directory in directories:
            directory.mkdir(parents=True, exist_ok=True)
    
    def generate_all(self, tables: List[Table]):
        """Gera todos os arquivos para as tabelas"""
        print("\n🚀 Generating Clean Architecture files...")
        
        # Gerar Value Objects comuns
        self._generate_common_value_objects()
        
        # Gerar para cada tabela
        for table in tables:
            print(f"\n📝 Generating files for {table.entity_name}...")
            
            # Domain Layer
            self._generate_entity(table)
            self._generate_repository_contract(table)
            
            # Infrastructure Layer
            self._generate_repository_implementation(table)
            self._generate_mapper(table)
        
        # Gerar arquivos de barrel
        self._generate_barrel_files(tables)
        
        print("\n✅ Clean Architecture generation completed!")
    
    def _generate_common_value_objects(self):
        """Gera Value Objects comuns"""
        # Email Value Object
        email_vo = '''// lib/domain/value_objects/email.dart
class Email {
  final String value;
  
  const Email._(this.value);
  
  factory Email(String value) {
    if (!_isValid(value)) {
      throw InvalidEmailException('Invalid email format: $value');
    }
    return Email._(value);
  }
  
  static bool _isValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Email && other.value == value);
  }
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => value;
}

class InvalidEmailException implements Exception {
  final String message;
  const InvalidEmailException(this.message);
}
'''
        
        # Phone Number Value Object
        phone_vo = '''// lib/domain/value_objects/phone_number.dart
class PhoneNumber {
  final String value;
  
  const PhoneNumber._(this.value);
  
  factory PhoneNumber(String value) {
    final cleaned = _clean(value);
    if (!_isValid(cleaned)) {
      throw InvalidPhoneNumberException('Invalid phone number: $value');
    }
    return PhoneNumber._(cleaned);
  }
  
  static String _clean(String phone) {
    return phone.replaceAll(RegExp(r'[^0-9+]'), '');
  }
  
  static bool _isValid(String phone) {
    return RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(phone);
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is PhoneNumber && other.value == value);
  }
  
  @override
  int get hashCode => value.hashCode;
  
  @override
  String toString() => value;
}

class InvalidPhoneNumberException implements Exception {
  final String message;
  const InvalidPhoneNumberException(this.message);
}
'''
        
        # Location Value Object
        location_vo = '''// lib/domain/value_objects/location.dart
import 'dart:math' as math;

class Location {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;
  
  const Location({
    required this.latitude,
    required this.longitude,
    this.timestamp,
  });
  
  factory Location.fromCoordinates(double lat, double lng) {
    if (lat < -90 || lat > 90) {
      throw InvalidLocationException('Latitude must be between -90 and 90');
    }
    if (lng < -180 || lng > 180) {
      throw InvalidLocationException('Longitude must be between -180 and 180');
    }
    
    return Location(
      latitude: lat,
      longitude: lng,
      timestamp: DateTime.now(),
    );
  }
  
  Distance distanceTo(Location other) {
    // Implementação da fórmula de Haversine
    const double earthRadius = 6371000; // metros
    
    final double lat1Rad = latitude * (math.pi / 180);
    final double lat2Rad = other.latitude * (math.pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (math.pi / 180);
    final double deltaLngRad = (other.longitude - longitude) * (math.pi / 180);
    
    final double a = math.pow(math.sin(deltaLatRad / 2), 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.pow(math.sin(deltaLngRad / 2), 2);
    
    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    
    return Distance.meters(earthRadius * c);
  }
  
  bool isWithinRadius(Location center, Distance radius) {
    return distanceTo(center).meters <= radius.meters;
  }
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Location &&
            other.latitude == latitude &&
            other.longitude == longitude);
  }
  
  @override
  int get hashCode => Object.hash(latitude, longitude);
  
  @override
  String toString() => 'Location($latitude, $longitude)';
}

class Distance {
  final double meters;
  
  const Distance._(this.meters);
  
  factory Distance.meters(double meters) {
    if (meters < 0) {
      throw ArgumentError('Distance cannot be negative');
    }
    return Distance._(meters);
  }
  
  factory Distance.kilometers(double km) => Distance._(km * 1000);
  
  double get kilometers => meters / 1000;
  
  bool isLessThan(Distance other) => meters < other.meters;
  bool isGreaterThan(Distance other) => meters > other.meters;
  
  @override
  String toString() => '${kilometers.toStringAsFixed(2)} km';
}

class InvalidLocationException implements Exception {
  final String message;
  const InvalidLocationException(this.message);
}
'''
        
        # Money Value Object
        money_vo = '''// lib/domain/value_objects/money.dart
class Money {
  final int centavos; // Evita problemas de ponto flutuante
  
  const Money._(this.centavos);
  
  factory Money.fromReais(double reais) {
    return Money._((reais * 100).round());
  }
  
  factory Money.fromCentavos(int centavos) {
    if (centavos < 0) {
      throw ArgumentError('Money cannot be negative');
    }
    return Money._(centavos);
  }
  
  factory Money.zero() => const Money._(0);
  
  double get reais => centavos / 100.0;
  
  Money add(Money other) => Money._(centavos + other.centavos);
  Money subtract(Money other) => Money._(centavos - other.centavos);
  Money multiply(int factor) => Money._(centavos * factor);
  Money divide(int divisor) => Money._((centavos / divisor).round());
  
  bool isZero() => centavos == 0;
  bool isPositive() => centavos > 0;
  bool isNegative() => centavos < 0;
  
  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other is Money && other.centavos == centavos);
  }
  
  @override
  int get hashCode => centavos.hashCode;
  
  @override
  String toString() => 'R\$ ${reais.toStringAsFixed(2)}';
}
'''
        
        # Result Pattern
        result_pattern = '''// lib/domain/value_objects/result.dart
abstract class Result<T> {
  const Result();
  
  factory Result.success(T value) = Success<T>;
  factory Result.failure(Exception error) = Failure<T>;
  
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  
  T get value {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw StateError('Cannot get value from failure result');
  }
  
  Exception get error {
    if (this is Failure<T>) {
      return (this as Failure<T>).error;
    }
    throw StateError('Cannot get error from success result');
  }
  
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Exception error) onFailure,
  }) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).value);
    } else {
      return onFailure((this as Failure<T>).error);
    }
  }
}

class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);
}

class Failure<T> extends Result<T> {
  final Exception error;
  const Failure(this.error);
}
'''
        
        # Escrever arquivos
        self._write_file(self.domain_dir / "value_objects" / "email.dart", email_vo)
        self._write_file(self.domain_dir / "value_objects" / "phone_number.dart", phone_vo)
        self._write_file(self.domain_dir / "value_objects" / "location.dart", location_vo)
        self._write_file(self.domain_dir / "value_objects" / "money.dart", money_vo)
        self._write_file(self.domain_dir / "value_objects" / "result.dart", result_pattern)
    
    def _generate_entity(self, table: Table):
        """Gera entidade de domínio"""
        entity_name = table.entity_name
        
        # Imports
        imports = []
        
        # Verificar se precisa de imports específicos
        if any(f.value_object_type == 'Email' for f in table.fields):
            imports.append("import '../value_objects/email.dart';")
        if any(f.value_object_type == 'PhoneNumber' for f in table.fields):
            imports.append("import '../value_objects/phone_number.dart';")
        if table.has_location_fields:
            imports.append("import '../value_objects/location.dart';")
        if any('fee' in f.name.lower() or 'price' in f.name.lower() or 'fare' in f.name.lower() for f in table.fields):
            imports.append("import '../value_objects/money.dart';")
        
        # Gerar campos da entidade
        entity_fields = []
        constructor_params = []
        
        for field in table.fields:
            # Pular campos de localização que serão agrupados
            if any(field.name in pair for pair in table.location_pairs):
                continue
            
            field_type = self._get_entity_field_type(field, table)
            entity_fields.append(f"  final {field_type} {field.name};")
            
            if field.is_nullable:
                constructor_params.append(f"    this.{field.name},")
            else:
                constructor_params.append(f"    required this.{field.name},")
        
        # Adicionar campos de localização agrupados
        for i, (lat_field, lng_field) in enumerate(table.location_pairs):
            location_name = self._get_location_field_name(lat_field)
            entity_fields.append(f"  final Location? {location_name};")
            constructor_params.append(f"    this.{location_name},")
        
        # Gerar código da entidade
        entity_code = f'''// lib/domain/entities/{entity_name.lower()}.dart
{chr(10).join(imports)}

class {entity_name} {{
{chr(10).join(entity_fields)}

  const {entity_name}({{
{chr(10).join(constructor_params)}
  }});

  {entity_name} copyWith({{
{self._generate_copy_with_params(table)}
  }}) {{
    return {entity_name}(
{self._generate_copy_with_body(table)}
    );
  }}

{self._generate_business_methods(table)}

  @override
  bool operator ==(Object other) {{
    return identical(this, other) ||
        (other is {entity_name} &&
{self._generate_equality_checks(table)});
  }}

  @override
  int get hashCode {{
{self._generate_hash_code(table)}
  }}

  @override
  String toString() => '{entity_name}(id: $id)';
}}
'''
        
        self._write_file(
            self.domain_dir / "entities" / f"{entity_name.lower()}.dart",
            entity_code
        )
    
    def _get_location_field_name(self, lat_field: str) -> str:
        """Gera nome do campo de localização"""
        location_name = lat_field.replace('Latitude', '').replace('latitude', '') or 'location'
        if location_name and not location_name.endswith('Location'):
            location_name += 'Location'
        elif not location_name:
            location_name = 'location'
        return location_name
    
    def _get_entity_field_type(self, field: Field, table: Table) -> str:
        """Determina o tipo do campo na entidade"""
        # Value Objects específicos
        if field.value_object_type:
            return field.value_object_type + ('?' if field.is_nullable else '')
        
        # Tipos especiais
        if 'fee' in field.name.lower() or 'price' in field.name.lower() or 'fare' in field.name.lower():
            return 'Money' + ('?' if field.is_nullable else '')
        
        # Tipo padrão
        return field.domain_type
    
    def _generate_copy_with_params(self, table: Table) -> str:
        """Gera parâmetros do copyWith"""
        params = []
        
        for field in table.fields:
            if any(field.name in pair for pair in table.location_pairs):
                continue
            
            field_type = self._get_entity_field_type(field, table)
            params.append(f"    {field_type}? {field.name},")
        
        # Adicionar campos de localização
        for lat_field, lng_field in table.location_pairs:
            location_name = self._get_location_field_name(lat_field)
            params.append(f"    Location? {location_name},")
        
        return '\n'.join(params)
    
    def _generate_copy_with_body(self, table: Table) -> str:
        """Gera corpo do copyWith"""
        assignments = []
        
        for field in table.fields:
            if any(field.name in pair for pair in table.location_pairs):
                continue
            
            assignments.append(f"      {field.name}: {field.name} ?? this.{field.name},")
        
        # Adicionar campos de localização
        for lat_field, lng_field in table.location_pairs:
            location_name = self._get_location_field_name(lat_field)
            assignments.append(f"      {location_name}: {location_name} ?? this.{location_name},")
        
        return '\n'.join(assignments)
    
    def _generate_business_methods(self, table: Table) -> str:
        """Gera métodos de negócio específicos da entidade"""
        entity_name = table.entity_name.lower()
        methods = []
        
        if entity_name == 'driver':
            methods.append('''
  bool canAcceptTrip() {
    return isOnline && approvalStatus == 'approved';
  }

  Money calculateBaseFee() {
    return customPricePerKm;
  }

  bool isApproved() {
    return approvalStatus == 'approved';
  }

  bool hasValidDocuments() {
    return approvedBy != null && approvedAt != null;
  }''')
        
        elif entity_name == 'trip':
            methods.append('''
  bool canBeAccepted() {
    return status == 'pending';
  }

  bool isCompleted() {
    return status == 'completed';
  }

  bool isInProgress() {
    return status == 'in_progress';
  }''')
        
        elif entity_name == 'passenger':
            methods.append('''
  bool canRequestTrip() {
    return consecutiveCancellations == null || 
           consecutiveCancellations! < 3;
  }

  bool hasGoodRating() {
    return averageRating == null || averageRating! >= 4.0;
  }''')
        
        return '\n'.join(methods) if methods else '  // Business methods can be added here'
    
    def _generate_equality_checks(self, table: Table) -> str:
        """Gera verificações de igualdade"""
        checks = []
        
        for field in table.fields:
            if any(field.name in pair for pair in table.location_pairs):
                continue
            checks.append(f"            other.{field.name} == {field.name}")
        
        # Adicionar campos de localização
        for lat_field, lng_field in table.location_pairs:
            location_name = self._get_location_field_name(lat_field)
            checks.append(f"            other.{location_name} == {location_name}")
        
        return ' &&\n'.join(checks)
    
    def _generate_hash_code(self, table: Table) -> str:
        """Gera código hash otimizado"""
        fields = []
        
        for field in table.fields:
            if any(field.name in pair for pair in table.location_pairs):
                continue
            fields.append(field.name)
        
        # Adicionar campos de localização
        for lat_field, lng_field in table.location_pairs:
            location_name = self._get_location_field_name(lat_field)
            fields.append(location_name)
        
        # Dividir em grupos de 20 para evitar erro de argumentos
        if len(fields) <= 20:
            field_list = ',\n      '.join(fields)
            return f"    return Object.hash(\n      {field_list},\n    );"
        else:
            first_20 = fields[:19]
            remaining = fields[19:]
            first_list = ',\n      '.join(first_20)
            remaining_list = ',\n        '.join(remaining)
            return f"""    return Object.hash(
      {first_list},
      Object.hashAll([
        {remaining_list},
      ]),
    );"""
    
    def _generate_repository_contract(self, table: Table):
        """Gera contrato do repository"""
        entity_name = table.entity_name
        
        # Determinar tipo do ID
        id_field = next((f for f in table.fields if f.name == 'id'), None)
        id_type = id_field.value_object_type if id_field and id_field.value_object_type else 'String'
        
        repository_code = f'''// lib/domain/repositories/{entity_name.lower()}_repository.dart
import '../entities/{entity_name.lower()}.dart';
import '../value_objects/result.dart';
{self._generate_repository_imports(table)}

abstract class {entity_name}Repository {{
  Future<Result<{entity_name}?>> findById({id_type} id);
  Future<Result<List<{entity_name}>>> findAll();
  Future<Result<void>> save({entity_name} {entity_name.lower()});
  Future<Result<void>> delete({id_type} id);
{self._generate_repository_specific_methods(table)}
}}
'''
        
        self._write_file(
            self.domain_dir / "repositories" / f"{entity_name.lower()}_repository.dart",
            repository_code
        )
    
    def _generate_repository_imports(self, table: Table) -> str:
        """Gera imports necessários para o repository"""
        imports = []
        
        if table.has_location_fields:
            imports.append("import '../value_objects/location.dart';")
        
        return '\n'.join(imports)
    
    def _generate_repository_specific_methods(self, table: Table) -> str:
        """Gera métodos específicos do repository"""
        entity_name = table.entity_name
        methods = []
        
        # Verificar se tem campo user_id
        if any(f.name == 'userId' for f in table.fields):
            methods.append(f"  Future<Result<{entity_name}?>> findByUserId(String userId);")
        
        # Métodos específicos por entidade
        if entity_name.lower() == 'driver':
            methods.extend([
                "  Future<Result<List<Driver>>> findAvailableInRadius(Location center, Distance radius);",
                "  Future<Result<void>> updateOnlineStatus(String driverId, bool isOnline);",
                "  Future<Result<void>> updateLocation(String driverId, Location location);"
            ])
        
        elif entity_name.lower() == 'trip':
            methods.extend([
                "  Future<Result<List<Trip>>> findByPassengerId(String passengerId);",
                "  Future<Result<List<Trip>>> findByDriverId(String driverId);",
                "  Future<Result<List<Trip>>> findByStatus(String status);"
            ])
        
        elif entity_name.lower() == 'passenger':
            methods.extend([
                "  Future<Result<List<Trip>>> getTripHistory(String passengerId);",
                "  Future<Result<void>> updateRating(String passengerId, double rating);"
            ])
        
        return '\n' + '\n'.join(methods) if methods else ''
    
    def _generate_repository_implementation(self, table: Table):
        """Gera implementação do repository com API correta"""
        entity_name = table.entity_name
        table_class = table.table_class_name
        
        implementation_code = f'''// lib/infrastructure/repositories/supabase_{entity_name.lower()}_repository.dart
import '../../domain/entities/{entity_name.lower()}.dart';
import '../../domain/repositories/{entity_name.lower()}_repository.dart';
import '../../domain/value_objects/result.dart';
import '../../backend/supabase/database/tables/{table.name}.dart';
import '../mappers/{entity_name.lower()}_mapper.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
{self._generate_repository_imports(table)}

class Supabase{entity_name}Repository implements {entity_name}Repository {{
  final {table_class} _table;
  final {entity_name}Mapper _mapper;
  
  Supabase{entity_name}Repository({{
    required {table_class} table,
    required {entity_name}Mapper mapper,
  }}) : _table = table,
        _mapper = mapper;

  @override
  Future<Result<{entity_name}?>> findById(String id) async {{
    try {{
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('id', id),
      );
      
      if (rows.isEmpty) {{
        return Result.success(null);
      }}
      
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    }} on PostgrestException catch (e) {{
      return Result.failure(
        RepositoryException('Failed to find {entity_name.lower()}: ${{e.message}}')
      );
    }} catch (e) {{
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }}
  }}

  @override
  Future<Result<List<{entity_name}>>> findAll() async {{
    try {{
      final rows = await _table.queryRows(
        queryFn: (q) => q,
      );
      final entities = rows.map(_mapper.toDomain).toList();
      return Result.success(entities);
    }} on PostgrestException catch (e) {{
      return Result.failure(
        RepositoryException('Failed to find all {entity_name.lower()}s: ${{e.message}}')
      );
    }} catch (e) {{
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }}
  }}

  @override
  Future<Result<void>> save({entity_name} {entity_name.lower()}) async {{
    try {{
      final data = _mapper.toSupabase({entity_name.lower()});
      await _table.insert(data);
      return Result.success(null);
    }} on PostgrestException catch (e) {{
      return Result.failure(
        RepositoryException('Failed to save {entity_name.lower()}: ${{e.message}}')
      );
    }} catch (e) {{
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }}
  }}

  @override
  Future<Result<void>> delete(String id) async {{
    try {{
      await _table.delete(
        matchingRows: (rows) => rows.eq('id', id),
      );
      return Result.success(null);
    }} on PostgrestException catch (e) {{
      return Result.failure(
        RepositoryException('Failed to delete {entity_name.lower()}: ${{e.message}}')
      );
    }} catch (e) {{
      return Result.failure(
        RepositoryException('Unexpected error: $e')
      );
    }}
  }}
{self._generate_repository_implementation_specific_methods(table)}
}}

class RepositoryException implements Exception {{
  final String message;
  const RepositoryException(this.message);
}}
'''
        
        self._write_file(
            self.infrastructure_dir / "repositories" / f"supabase_{entity_name.lower()}_repository.dart",
            implementation_code
        )
    
    def _generate_repository_implementation_specific_methods(self, table: Table) -> str:
        """Gera implementação de métodos específicos"""
        entity_name = table.entity_name
        methods = []
        
        # Método findByUserId se aplicável
        if any(f.name == 'userId' for f in table.fields):
            methods.append(f'''
  @override
  Future<Result<{entity_name}?>> findByUserId(String userId) async {{
    try {{
      final rows = await _table.queryRows(
        queryFn: (q) => q.eq('user_id', userId),
      );
      
      if (rows.isEmpty) {{
        return Result.success(null);
      }}
      
      final entity = _mapper.toDomain(rows.first);
      return Result.success(entity);
    }} on PostgrestException catch (e) {{
      return Result.failure(
        RepositoryException('Failed to find {entity_name.lower()} by user ID: ${{e.message}}')
      );
    }}
  }}''')
        
        # Métodos específicos por entidade
        if entity_name.lower() == 'driver':
            methods.append('''
  @override
  Future<Result<List<Driver>>> findAvailableInRadius(
    Location center, 
    Distance radius
  ) async {
    try {
      // Implementar query geográfica
      final rows = await _table.queryRows(
        queryFn: (q) => q
            .eq('is_online', true)
            .eq('approval_status', 'approved')
            .gte('updated_at', 
                 DateTime.now().subtract(Duration(minutes: 5)).toIso8601String()),
      );
      
      // Filtrar por distância (implementação simplificada)
      final drivers = rows.map(_mapper.toDomain).toList();
      final filtered = drivers.where((driver) {
        if (driver.currentLocation == null) return false;
        return driver.currentLocation!.isWithinRadius(center, radius);
      }).toList();
      
      return Result.success(filtered);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to find available drivers: ${e.message}')
      );
    }
  }

  @override
  Future<Result<void>> updateOnlineStatus(String driverId, bool isOnline) async {
    try {
      await _table.update(
        {'is_online': isOnline, 'updated_at': DateTime.now().toIso8601String()},
        matchingRows: (rows) => rows.eq('id', driverId),
      );
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to update online status: ${e.message}')
      );
    }
  }

  @override
  Future<Result<void>> updateLocation(String driverId, Location location) async {
    try {
      await _table.update(
        {
          'current_latitude': location.latitude,
          'current_longitude': location.longitude,
          'updated_at': DateTime.now().toIso8601String(),
        },
        matchingRows: (rows) => rows.eq('id', driverId),
      );
      return Result.success(null);
    } on PostgrestException catch (e) {
      return Result.failure(
        RepositoryException('Failed to update location: ${e.message}')
      );
    }
  }''')
        
        return '\n'.join(methods)
    
    def _generate_mapper(self, table: Table):
        """Gera mapper entre entidade e Supabase"""
        entity_name = table.entity_name
        row_class = f"{table.class_name}Row"
        
        mapper_code = f'''// lib/infrastructure/mappers/{entity_name.lower()}_mapper.dart
import '../../domain/entities/{entity_name.lower()}.dart';
import '../../backend/supabase/database/tables/{table.name}.dart';
{self._generate_mapper_imports(table)}

class {entity_name}Mapper {{
  {entity_name} toDomain({row_class} row) {{
    return {entity_name}(
{self._generate_mapper_to_domain_fields(table)}
    );
  }}
  
  Map<String, dynamic> toSupabase({entity_name} entity) {{
    return {{
{self._generate_mapper_to_supabase_fields(table)}
    }};
  }}
{self._generate_mapper_helper_methods(table)}
}}
'''
        
        self._write_file(
            self.infrastructure_dir / "mappers" / f"{entity_name.lower()}_mapper.dart",
            mapper_code
        )
    
    def _generate_mapper_imports(self, table: Table) -> str:
        """Gera imports necessários para o mapper"""
        imports = []
        
        if any(f.value_object_type == 'Email' for f in table.fields):
            imports.append("import '../../domain/value_objects/email.dart';")
        if any(f.value_object_type == 'PhoneNumber' for f in table.fields):
            imports.append("import '../../domain/value_objects/phone_number.dart';")
        if table.has_location_fields:
            imports.append("import '../../domain/value_objects/location.dart';")
        if any('fee' in f.name.lower() or 'price' in f.name.lower() or 'fare' in f.name.lower() for f in table.fields):
            imports.append("import '../../domain/value_objects/money.dart';")
        
        return '\n'.join(imports)
    
    def _generate_mapper_to_domain_fields(self, table: Table) -> str:
        """Gera campos para conversão Supabase -> Domain"""
        assignments = []
        
        for field in table.fields:
            # Pular campos de localização que serão agrupados
            if any(field.name in pair for pair in table.location_pairs):
                continue
            
            assignment = self._generate_field_to_domain_assignment(field)
            assignments.append(f"      {field.name}: {assignment},")
        
        # Adicionar campos de localização agrupados
        for lat_field, lng_field in table.location_pairs:
            location_name = self._get_location_field_name(lat_field)
            assignment = f'''row.{lat_field} != null && row.{lng_field} != null
          ? Location.fromCoordinates(row.{lat_field}!, row.{lng_field}!)
          : null'''
            assignments.append(f"      {location_name}: {assignment},")
        
        return '\n'.join(assignments)
    
    def _generate_field_to_domain_assignment(self, field: Field) -> str:
        """Gera atribuição de campo específico para domínio"""
        if field.value_object_type == 'Email':
            if field.is_nullable:
                return f"row.{field.name} != null ? Email(row.{field.name}!) : null"
            else:
                return f"Email(row.{field.name}!)"
        
        elif field.value_object_type == 'PhoneNumber':
            if field.is_nullable:
                return f"row.{field.name} != null ? PhoneNumber(row.{field.name}!) : null"
            else:
                return f"PhoneNumber(row.{field.name}!)"
        
        elif 'fee' in field.name.lower() or 'price' in field.name.lower() or 'fare' in field.name.lower():
            if field.is_nullable:
                return f"row.{field.name} != null ? Money.fromReais(row.{field.name}!) : Money.zero()"
            else:
                return f"Money.fromReais(row.{field.name} ?? 0.0)"
        
        else:
            return f"row.{field.name}"
    
    def _generate_mapper_to_supabase_fields(self, table: Table) -> str:
        """Gera campos para conversão Domain -> Supabase"""
        assignments = []
        
        for field in table.fields:
            # Pular campos de localização que serão expandidos
            if any(field.name in pair for pair in table.location_pairs):
                continue
            
            assignment = self._generate_field_to_supabase_assignment(field)
            assignments.append(f"      '{field.supabase_field}': {assignment},")
        
        # Expandir campos de localização
        for lat_field, lng_field in table.location_pairs:
            location_name = self._get_location_field_name(lat_field)
            
            # Encontrar campos originais para obter nomes Supabase
            lat_supabase = next(f.supabase_field for f in table.fields if f.name == lat_field)
            lng_supabase = next(f.supabase_field for f in table.fields if f.name == lng_field)
            
            assignments.append(f"      '{lat_supabase}': entity.{location_name}?.latitude,")
            assignments.append(f"      '{lng_supabase}': entity.{location_name}?.longitude,")
        
        return '\n'.join(assignments)
    
    def _generate_field_to_supabase_assignment(self, field: Field) -> str:
        """Gera atribuição de campo específico para Supabase"""
        if field.value_object_type in ['Email', 'PhoneNumber']:
            if field.is_nullable:
                return f"entity.{field.name}?.value"
            else:
                return f"entity.{field.name}.value"
        
        elif 'fee' in field.name.lower() or 'price' in field.name.lower() or 'fare' in field.name.lower():
            if field.is_nullable:
                return f"entity.{field.name}?.reais"
            else:
                return f"entity.{field.name}.reais"
        
        else:
            return f"entity.{field.name}"
    
    def _generate_mapper_helper_methods(self, table: Table) -> str:
        """Gera métodos auxiliares do mapper"""
        methods = []
        
        # Método para converter lista se necessário
        if any(f.is_list for f in table.fields):
            methods.append('''
  List<T> _convertList<T>(List<dynamic>? list, T Function(dynamic) converter) {
    if (list == null) return [];
    return list.map(converter).toList();
  }''')
        
        return '\n'.join(methods)
    
    def _generate_barrel_files(self, tables: List[Table]):
        """Gera arquivos barrel para exports"""
        # Domain barrel
        domain_exports = []
        domain_exports.append("// Entities")
        for table in tables:
            domain_exports.append(f"export 'entities/{table.entity_name.lower()}.dart';")
        
        domain_exports.append("\n// Repositories")
        for table in tables:
            domain_exports.append(f"export 'repositories/{table.entity_name.lower()}_repository.dart';")
        
        domain_exports.append("\n// Value Objects")
        domain_exports.extend([
            "export 'value_objects/email.dart';",
            "export 'value_objects/phone_number.dart';",
            "export 'value_objects/location.dart';",
            "export 'value_objects/money.dart';",
            "export 'value_objects/result.dart';"
        ])
        
        self._write_file(
            self.domain_dir / "domain.dart",
            '\n'.join(domain_exports)
        )
        
        # Infrastructure barrel
        infra_exports = []
        infra_exports.append("// Repositories")
        for table in tables:
            infra_exports.append(f"export 'repositories/supabase_{table.entity_name.lower()}_repository.dart';")
        
        infra_exports.append("\n// Mappers")
        for table in tables:
            infra_exports.append(f"export 'mappers/{table.entity_name.lower()}_mapper.dart';")
        
        self._write_file(
            self.infrastructure_dir / "infrastructure.dart",
            '\n'.join(infra_exports)
        )
    
    def _write_file(self, file_path: Path, content: str):
        """Escreve conteúdo em arquivo"""
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        print(f"  ✅ Generated: {file_path.relative_to(self.output_dir)}")

def main():
    """Função principal"""
    print("🚀 Clean Architecture Generator for Flutter + Supabase (v2.0)")
    print("=" * 65)
    
    # Configurações
    current_dir = Path.cwd()
    tables_dir = current_dir / "lib" / "backend" / "supabase" / "database" / "tables"
    output_dir = current_dir
    
    # Verificar se diretório existe
    if not tables_dir.exists():
        print(f"❌ Directory not found: {tables_dir}")
        print("Please run this script from the Flutter project root.")
        return
    
    print(f"📂 Tables directory: {tables_dir}")
    print(f"📂 Output directory: {output_dir}")
    
    # Analisar tabelas
    print("\n📋 Parsing Supabase tables...")
    parser = SupabaseTableParser(str(tables_dir))
    tables = parser.parse_all_tables()
    
    if not tables:
        print("❌ No tables found to process.")
        return
    
    print(f"\n✅ Found {len(tables)} tables:")
    for table in tables:
        print(f"  - {table.name} ({table.entity_name}) - {len(table.fields)} fields")
    
    # Gerar arquivos
    print("\n🏗️ Generating Clean Architecture files...")
    generator = CleanArchitectureGenerator(str(output_dir))
    generator.generate_all(tables)
    
    # Estatísticas finais
    print("\n📊 Generation Summary:")
    print(f"  - {len(tables)} Domain Entities")
    print(f"  - {len(tables)} Repository Contracts")
    print(f"  - {len(tables)} Repository Implementations")
    print(f"  - {len(tables)} Mappers")
    print("  - 5 Value Objects")
    print("  - 2 Barrel files")
    
    print("\n🎉 Clean Architecture generation completed successfully!")
    print("\n📝 Next steps:")
    print("  1. Review generated files")
    print("  2. Add missing imports")
    print("  3. Implement business logic in entities")
    print("  4. Create use cases in application layer")
    print("  5. Set up dependency injection")
    print("  6. Run 'flutter analyze' to check for issues")

if __name__ == "__main__":
    main()