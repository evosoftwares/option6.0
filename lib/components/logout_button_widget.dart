import '/custom_code/actions/logout_seguro.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';

class LogoutButtonWidget extends StatefulWidget {
  const LogoutButtonWidget({
    Key? key,
    this.buttonText = 'Sair',
    this.showConfirmDialog = true,
    this.buttonColor,
    this.textColor,
    this.iconData = Icons.logout,
    this.isIconButton = false,
    this.onLogoutComplete,
  }) : super(key: key);

  final String buttonText;
  final bool showConfirmDialog;
  final Color? buttonColor;
  final Color? textColor;
  final IconData iconData;
  final bool isIconButton;
  final VoidCallback? onLogoutComplete;

  @override
  State<LogoutButtonWidget> createState() => _LogoutButtonWidgetState();
}

class _LogoutButtonWidgetState extends State<LogoutButtonWidget> {
  bool _isLoggingOut = false;

  Future<void> _handleLogout() async {
    if (_isLoggingOut) return;

    // Mostrar diálogo de confirmação se habilitado
    if (widget.showConfirmDialog) {
      final shouldLogout = await _showConfirmDialog();
      if (!shouldLogout) return;
    }

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // Executar logout seguro
      final result = await logoutSeguro(context);
      
      if (result['sucesso'] == true) {
        // Mostrar mensagem de sucesso
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Logout realizado com sucesso'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
        
        // Callback de conclusão
        widget.onLogoutComplete?.call();
      } else {
        // Mostrar erro
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro no logout: ${result['erro']}'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    } catch (e) {
      // Erro inesperado
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro inesperado durante logout'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  Future<bool> _showConfirmDialog() async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmar Logout',
            style: FlutterFlowTheme.of(context).headlineSmall,
          ),
          content: Text(
            'Tem certeza que deseja sair da sua conta?',
            style: FlutterFlowTheme.of(context).bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancelar',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Inter',
                  color: FlutterFlowTheme.of(context).secondaryText,
                ),
              ),
            ),
            // Substituindo FFButtonWidget por ElevatedButton para evitar problemas de layout
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: FlutterFlowTheme.of(context).error,
                foregroundColor: Colors.white,
                padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(0, 40),
              ),
              child: Text(
                'Sair',
                style: FlutterFlowTheme.of(context).titleSmall.override(
                  fontFamily: 'Inter',
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isIconButton) {
      return IconButton(
        onPressed: _isLoggingOut ? null : _handleLogout,
        icon: _isLoggingOut
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    widget.textColor ?? FlutterFlowTheme.of(context).primaryText,
                  ),
                ),
              )
            : Icon(
                widget.iconData,
                color: widget.textColor ?? FlutterFlowTheme.of(context).primaryText,
              ),
        tooltip: widget.buttonText,
      );
    }

    return FFButtonWidget(
      onPressed: _isLoggingOut ? null : _handleLogout,
      text: _isLoggingOut ? 'Saindo...' : widget.buttonText,
      icon: _isLoggingOut
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.textColor ?? Colors.white,
                ),
              ),
            )
          : Icon(
              widget.iconData,
              size: 20,
              color: widget.textColor ?? Colors.white,
            ),
      options: FFButtonOptions(
        height: 44,
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
        iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
        color: widget.buttonColor ?? FlutterFlowTheme.of(context).error,
        textStyle: FlutterFlowTheme.of(context).titleSmall.override(
          fontFamily: 'Inter',
          color: widget.textColor ?? Colors.white,
          fontWeight: FontWeight.w500,
        ),
        elevation: 2,
        borderSide: BorderSide(
          color: Colors.transparent,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(8),
        disabledColor: FlutterFlowTheme.of(context).secondaryText,
      ),
    );
  }
}

/// Widget de logout simples para uso em menus
class SimpleLogoutWidget extends StatelessWidget {
  const SimpleLogoutWidget({
    Key? key,
    this.onLogoutComplete,
  }) : super(key: key);

  final VoidCallback? onLogoutComplete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.logout,
        color: FlutterFlowTheme.of(context).error,
      ),
      title: Text(
        'Sair',
        style: FlutterFlowTheme.of(context).bodyLarge.override(
          fontFamily: 'Inter',
          color: FlutterFlowTheme.of(context).error,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Confirmar Logout'),
            content: Text('Tem certeza que deseja sair?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Sair',
                  style: TextStyle(color: FlutterFlowTheme.of(context).error),
                ),
              ),
            ],
          ),
        );

        if (shouldLogout == true) {
          await logoutSeguro(context);
          onLogoutComplete?.call();
        }
      },
    );
  }
}

/// Widget de logout para app bar
class AppBarLogoutWidget extends StatelessWidget {
  const AppBarLogoutWidget({
    Key? key,
    this.onLogoutComplete,
  }) : super(key: key);

  final VoidCallback? onLogoutComplete;

  @override
  Widget build(BuildContext context) {
    return LogoutButtonWidget(
      isIconButton: true,
      showConfirmDialog: true,
      iconData: Icons.logout,
      textColor: FlutterFlowTheme.of(context).primaryText,
      onLogoutComplete: onLogoutComplete,
    );
  }
}