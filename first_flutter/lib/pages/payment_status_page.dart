import 'package:flutter/material.dart';
import 'dart:async';
import '../l10n/app_localizations.dart';
import '../service/api_service.dart';
import '../pages/product_catalog_page.dart';

class PaymentStatusPage extends StatefulWidget {
  final String orderCode;
  final String paymentMethod;

  const PaymentStatusPage({
    super.key,
    required this.orderCode,
    required this.paymentMethod,
  });

  @override
  State<PaymentStatusPage> createState() => _PaymentStatusPageState();
}

class _PaymentStatusPageState extends State<PaymentStatusPage> {
  String _status = 'pending';
  Timer? _timer;
  int _checkCount = 0;
  final int _maxChecks = 60; // Máximo 5 minutos (60 * 5 segundos)

  @override
  void initState() {
    super.initState();
    _startStatusCheck();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startStatusCheck() {
    // Para efectivo, el estado ya es final
    if (widget.paymentMethod == 'cash') {
      setState(() => _status = 'approved');
      return;
    }

    // Para tarjeta y Nequi, verificar periódicamente
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (_checkCount >= _maxChecks) {
        timer.cancel();
        if (mounted && _status == 'pending') {
          setState(() => _status = 'timeout');
        }
        return;
      }

      _checkCount++;
      await _checkPaymentStatus();
    });

    // Primera verificación inmediata
    _checkPaymentStatus();
  }

  Future<void> _checkPaymentStatus() async {
    try {
      final api = ApiService();
      final result = await api.getPaymentStatus(widget.orderCode);

      if (!mounted) return;

      final newStatus = result['status'] ?? 'pending';
      
      if (newStatus != _status) {
        setState(() => _status = newStatus);
      }

      // Detener el polling si el estado es final
      if (newStatus == 'approved' || 
          newStatus == 'declined' || 
          newStatus == 'cancelled') {
        _timer?.cancel();
      }
    } catch (e) {
      // Error al consultar el estado, pero continuamos intentando
      debugPrint('Error checking payment status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Prevenir que el usuario vuelva atrás
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.paymentStatusLabel),
          backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildStatusIcon(),
                  const SizedBox(height: 32),
                  _buildStatusTitle(),
                  const SizedBox(height: 16),
                  _buildStatusMessage(),
                  const SizedBox(height: 48),
                  _buildActionButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    IconData icon;
    Color color;

    switch (_status) {
      case 'approved':
        icon = Icons.check_circle;
        color = Colors.green;
        break;
      case 'declined':
        icon = Icons.cancel;
        color = Colors.red;
        break;
      case 'cancelled':
        icon = Icons.cancel;
        color = Colors.orange;
        break;
      case 'timeout':
        icon = Icons.access_time;
        color = Colors.orange;
        break;
      default:
        icon = Icons.hourglass_empty;
        color = const Color.fromRGBO(237, 88, 33, 1);
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (_status == 'pending')
          const SizedBox(
            width: 120,
            height: 120,
            child: CircularProgressIndicator(
              strokeWidth: 4,
              color: Color.fromRGBO(237, 88, 33, 1),
            ),
          ),
        Icon(
          icon,
          size: 80,
          color: color,
        ),
      ],
    );
  }

  Widget _buildStatusTitle() {
    String title;

    switch (_status) {
      case 'approved':
        title = '¡Pago Exitoso!';
        break;
      case 'declined':
        title = 'Pago Rechazado';
        break;
      case 'cancelled':
        title = 'Pago Cancelado';
        break;
      case 'timeout':
        title = 'Tiempo Agotado';
        break;
      default:
        title = 'Procesando Pago...';
    }

    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildStatusMessage() {
    String message;

    switch (_status) {
      case 'approved':
        if (widget.paymentMethod == 'cash') {
          message = 'Tu pedido ha sido confirmado. Pagarás en efectivo al recibir tu orden.';
        } else {
          message = 'Tu pago ha sido procesado exitosamente. ¡Gracias por tu compra!';
        }
        break;
      case 'declined':
        message = 'Tu pago no pudo ser procesado. Por favor, intenta con otro método de pago.';
        break;
      case 'cancelled':
        message = 'El pago fue cancelado. Puedes intentar nuevamente si lo deseas.';
        break;
      case 'timeout':
        message = 'No pudimos verificar el estado de tu pago. Por favor, contacta con soporte.';
        break;
      default:
        if (widget.paymentMethod == 'nequi') {
          message = 'Revisa tu app de Nequi para aprobar la transacción. Estamos esperando tu confirmación...';
        } else if (widget.paymentMethod == 'card') {
          message = 'Estamos procesando tu pago con tarjeta. Esto puede tomar unos segundos...';
        } else {
          message = 'Procesando tu pago...';
        }
    }

    return Text(
      message,
      style: TextStyle(
        fontSize: 16,
        color: Colors.grey[700],
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButton() {
    if (_status == 'pending') {
      return const SizedBox.shrink();
    }

    String buttonText;
    VoidCallback onPressed;

    if (_status == 'approved') {
      buttonText = 'Volver al Inicio';
      onPressed = () {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const ProductCatalogPage(initialIndex: 0),
          ),
          (route) => false,
        );
      };
    } else {
      buttonText = 'Intentar Nuevamente';
      onPressed = () {
        Navigator.of(context).popUntil((route) => route.isFirst);
      };
    }

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
