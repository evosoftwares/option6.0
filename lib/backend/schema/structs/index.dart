// DEPRECATED: Legacy Firebase structs - replaced by Supabase implementation
// This file provides compatibility for legacy code during migration

import '/flutter_flow/lat_lng.dart';

// Placeholder struct for legacy compatibility
class ChecklistItemStructStruct {
  final String text;
  final bool status;
  
  ChecklistItemStructStruct({
    required this.text,
    required this.status,
  });
}

// Placeholder struct for legacy compatibility
class AreaAtuacaoStruct {
  final String areaAtuacaoCidade;
  final LatLng? areaAtuacaoLatLnt;
  
  AreaAtuacaoStruct({
    required this.areaAtuacaoCidade,
    this.areaAtuacaoLatLnt,
  });
}

// Add other legacy structs as needed during migration