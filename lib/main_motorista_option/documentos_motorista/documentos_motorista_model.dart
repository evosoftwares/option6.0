import '/flutter_flow/flutter_flow_util.dart';
import 'documentos_motorista_widget.dart' show DocumentosMotoristaWidget;
import 'package:flutter/material.dart';

class DocumentosMotoristaModel
    extends FlutterFlowModel<DocumentosMotoristaWidget> {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();

  bool isDataUploading_uploadDataN5p = false;
  FFUploadedFile uploadedLocalFile_uploadDataN5p =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataN5p = '';

  bool isDataUploading_uploadDataN5pw = false;
  FFUploadedFile uploadedLocalFile_uploadDataN5pw =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataN5pw = '';

  // CRLV Upload
  bool isDataUploading_uploadDataCRLV = false;
  FFUploadedFile uploadedLocalFile_uploadDataCRLV =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataCRLV = '';

  // Vehicle Front Upload
  bool isDataUploading_uploadDataVF = false;
  FFUploadedFile uploadedLocalFile_uploadDataVF =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataVF = '';

  // Vehicle Side Upload
  bool isDataUploading_uploadDataVS = false;
  FFUploadedFile uploadedLocalFile_uploadDataVS =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataVS = '';

  // Vehicle Back Upload
  bool isDataUploading_uploadDataVB = false;
  FFUploadedFile uploadedLocalFile_uploadDataVB =
      FFUploadedFile(bytes: Uint8List.fromList([]));
  String uploadedFileUrl_uploadDataVB = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    unfocusNode.dispose();
  }
}
