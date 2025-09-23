import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'main_passageiro_widget.dart' show MainPassageiroWidget;
import 'package:flutter/material.dart';

class MainPassageiroModel extends FlutterFlowModel<MainPassageiroWidget> {
  ///  Local state fields for this page.

  // Mantido por compatibilidade (não mais usado nesta tela)
  List<String> paradas = [];
  void addToParadas(String item) => paradas.add(item);
  void removeFromParadas(String item) => paradas.remove(item);
  void removeAtIndexFromParadas(int index) => paradas.removeAt(index);
  void insertAtIndexInParadas(int index, String item) =>
      paradas.insert(index, item);
  void updateParadasAtIndex(int index, Function(String) updateFn) =>
      paradas[index] = updateFn(paradas[index]);

  // Novo estado com FFPlace
  FFPlace? origemPlace;
  FFPlace? destinoPlace;
  List<FFPlace> paradasPlace = [];
  void addToParadasPlace(FFPlace item) => paradasPlace.add(item);
  void removeFromParadasPlace(FFPlace item) => paradasPlace.remove(item);
  void removeAtIndexFromParadasPlace(int index) => paradasPlace.removeAt(index);
  void insertAtIndexInParadasPlace(int index, FFPlace item) =>
      paradasPlace.insert(index, item);
  void updateParadasPlaceAtIndex(int index, Function(FFPlace) updateFn) =>
      paradasPlace[index] = updateFn(paradasPlace[index]);

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
