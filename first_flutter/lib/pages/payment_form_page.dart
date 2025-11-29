import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';
import '../service/api_service.dart';
import 'payment_status_page.dart';

class PaymentFormPage extends StatefulWidget {
  final Order order;
  final String paymentMethod;

  const PaymentFormPage({
    super.key,
    required this.order,
    required this.paymentMethod,
  });

  @override
  State<PaymentFormPage> createState() => _PaymentFormPageState();
}

class _PaymentFormPageState extends State<PaymentFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  String? _cardType; // 'credit' o 'debit'

  // Controladores comunes
  final _emailController = TextEditingController();

  // Controladores para tarjeta
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _cvcController = TextEditingController();
  String? _expMonth;
  String? _expYear;
  int _installments = 1;

  // Controlador para Nequi
  final _phoneController = TextEditingController();

  // Checkboxes
  bool _acceptTerms = false;
  bool _acceptData = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.order.customerEmail ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cvcController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String get _pageTitle {
    switch (widget.paymentMethod) {
      case 'card':
        return _cardType == null
            ? 'Selecciona tipo de tarjeta'
            : 'Datos de la tarjeta';
      case 'nequi':
        return 'Pago con Nequi';
      case 'cash':
        return 'Pago en Efectivo';
      default:
        return 'Información de Pago';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitle),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resumen de orden
              _buildOrderSummary(),
              const SizedBox(height: 30),

              // Formulario según método de pago
              if (widget.paymentMethod == 'card' && _cardType == null)
                _buildCardTypeSelection()
              else if (widget.paymentMethod == 'card')
                _buildCardForm()
              else if (widget.paymentMethod == 'nequi')
                _buildNequiForm()
              else if (widget.paymentMethod == 'cash')
                _buildCashForm(),

              const SizedBox(height: 20),

              // Email (común para todos)
              _buildEmailField(),
              const SizedBox(height: 20),

              // Checkboxes
              _buildTermsCheckboxes(),
              const SizedBox(height: 30),

              // Botón de pago
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color.fromRGBO(237, 88, 33, 1),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Resumen de la Orden',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Código:', style: TextStyle(fontSize: 16)),
              Text(
                widget.order.code,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total a Pagar:', style: TextStyle(fontSize: 16)),
              Text(
                '\$ ${widget.order.total.toStringAsFixed(0)} COP',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(237, 88, 33, 1),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardTypeSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecciona el tipo de tarjeta',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _CardTypeButton(
                icon: Icons.credit_card,
                title: 'Crédito',
                subtitle: 'Hasta 36 cuotas',
                isSelected: _cardType == 'credit',
                onTap: () {
                  setState(() {
                    _cardType = 'credit';
                  });
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _CardTypeButton(
                icon: Icons.credit_card,
                title: 'Débito',
                subtitle: 'Pago de contado',
                isSelected: _cardType == 'debit',
                onTap: () {
                  setState(() {
                    _cardType = 'debit';
                    _installments = 1;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCardForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Número de tarjeta
        TextFormField(
          controller: _cardNumberController,
          decoration: const InputDecoration(
            labelText: 'Número de Tarjeta',
            hintText: '1234 5678 9012 3456',
            prefixIcon: Icon(Icons.credit_card),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(19),
            _CardNumberInputFormatter(),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa el número de tarjeta';
            }
            final digits = value.replaceAll(' ', '');
            if (digits.length < 13 || digits.length > 19) {
              return 'Número de tarjeta inválido';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Nombre del titular
        TextFormField(
          controller: _cardHolderController,
          decoration: const InputDecoration(
            labelText: 'Nombre del Titular',
            hintText: 'JUAN PEREZ',
            prefixIcon: Icon(Icons.person),
            border: OutlineInputBorder(),
          ),
          textCapitalization: TextCapitalization.characters,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa el nombre del titular';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),

        // Fecha de expiración y CVC
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Mes',
                  border: OutlineInputBorder(),
                ),
                value: _expMonth,
                items: List.generate(12, (index) {
                  final month = (index + 1).toString().padLeft(2, '0');
                  return DropdownMenuItem(
                    value: month,
                    child: Text(month),
                  );
                }),
                onChanged: (value) => setState(() => _expMonth = value),
                validator: (value) =>
                    value == null ? 'Selecciona el mes' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Año',
                  border: OutlineInputBorder(),
                ),
                value: _expYear,
                items: List.generate(10, (index) {
                  final year = (DateTime.now().year + index).toString();
                  return DropdownMenuItem(
                    value: year,
                    child: Text(year),
                  );
                }),
                onChanged: (value) => setState(() => _expYear = value),
                validator: (value) =>
                    value == null ? 'Selecciona el año' : null,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: _cvcController,
                decoration: const InputDecoration(
                  labelText: 'CVC',
                  hintText: '123',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(4),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CVC requerido';
                  }
                  if (value.length < 3) {
                    return 'CVC inválido';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Cuotas (solo para crédito)
        if (_cardType == 'credit')
          DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              labelText: 'Número de Cuotas',
              border: OutlineInputBorder(),
            ),
            value: _installments,
            items: [1, 2, 3, 6, 9, 12, 18, 24, 36].map((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value ${value == 1 ? 'cuota' : 'cuotas'}'),
              );
            }).toList(),
            onChanged: (value) => setState(() => _installments = value ?? 1),
          ),
      ],
    );
  }

  Widget _buildNequiForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ingresa tu número de celular Nequi',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          decoration: const InputDecoration(
            labelText: 'Número de Celular',
            hintText: '3001234567',
            prefixIcon: Icon(Icons.phone_android),
            border: OutlineInputBorder(),
            helperText: 'Asegúrate de tener la app de Nequi instalada',
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Ingresa tu número de celular';
            }
            if (value.length != 10) {
              return 'El número debe tener 10 dígitos';
            }
            if (!value.startsWith('3')) {
              return 'Número inválido (debe empezar con 3)';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFf8e6ff),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: Color(0xFF8B34D9)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Recibirás una notificación en tu app Nequi para aprobar el pago',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCashForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pago en Efectivo',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFe8f5e9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.info_outline, color: Color(0xFF4CAF50)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Instrucciones de pago',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '• Prepara el monto exacto: \$ ${widget.order.total.toStringAsFixed(0)} COP',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Entrega el dinero al domiciliario al recibir tu pedido',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Pide tu comprobante de pago',
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      decoration: const InputDecoration(
        labelText: 'Correo Electrónico',
        hintText: 'tu@email.com',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Ingresa tu correo electrónico';
        }
        if (!value.contains('@')) {
          return 'Correo electrónico inválido';
        }
        return null;
      },
    );
  }

  Widget _buildTermsCheckboxes() {
    return Column(
      children: [
        CheckboxListTile(
          value: _acceptTerms,
          onChanged: (value) => setState(() => _acceptTerms = value ?? false),
          title: const Text.rich(
            TextSpan(
              text: 'Acepto los ',
              children: [
                TextSpan(
                  text: 'términos y condiciones',
                  style: TextStyle(
                    color: Color.fromRGBO(237, 88, 33, 1),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: ' de Wompi'),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          value: _acceptData,
          onChanged: (value) => setState(() => _acceptData = value ?? false),
          title: const Text.rich(
            TextSpan(
              text: 'Autorizo el ',
              children: [
                TextSpan(
                  text: 'tratamiento de datos personales',
                  style: TextStyle(
                    color: Color.fromRGBO(237, 88, 33, 1),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    final canProceed = _canProceedWithPayment();

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canProceed && !_isProcessing ? _processPayment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isProcessing
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                'Pagar \$ ${widget.order.total.toStringAsFixed(0)} COP',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  bool _canProceedWithPayment() {
    if (!_acceptTerms || !_acceptData) return false;
    if (_emailController.text.isEmpty) return false;

    if (widget.paymentMethod == 'card') {
      if (_cardType == null) return false;
      // No validamos los demás campos aquí porque el formulario se encarga
    } else if (widget.paymentMethod == 'nequi') {
      if (_phoneController.text.length != 10) return false;
    }

    return true;
  }

  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final api = ApiService();
      Map<String, dynamic> paymentData = {
        'payment_method': widget.paymentMethod,
        'email': _emailController.text.trim(),
        'accept_terms': '1',
        'accept_data': '1',
      };

      if (widget.paymentMethod == 'card') {
        paymentData.addAll({
          'type_card': _cardType,
          'card_number': _cardNumberController.text.replaceAll(' ', ''),
          'card_holder': _cardHolderController.text.trim(),
          'exp_month': _expMonth,
          'exp_year': _expYear,
          'cvc': _cvcController.text,
          'installments': _installments.toString(),
        });
      } else if (widget.paymentMethod == 'nequi') {
        paymentData['phone_number'] = _phoneController.text.trim();
      }

      await api.createPayment(
        orderCode: widget.order.code,
        paymentData: paymentData,
      );

      if (!mounted) return;

      // Navegar a página de estado
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentStatusPage(
            orderCode: widget.order.code,
            paymentMethod: widget.paymentMethod,
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isProcessing = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}

// Widget auxiliar para botones de tipo de tarjeta
class _CardTypeButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _CardTypeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(237, 88, 33, 0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromRGBO(237, 88, 33, 1)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected
                  ? const Color.fromRGBO(237, 88, 33, 1)
                  : Colors.grey[600],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? const Color.fromRGBO(237, 88, 33, 1) : Colors.black,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Formateador para número de tarjeta
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        buffer.write(' ');
      }
    }

    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
