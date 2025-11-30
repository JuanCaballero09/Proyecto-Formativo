import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/order.dart';
import '../service/api_service.dart';
import 'payment_status_page.dart';
import '../l10n/app_localizations.dart';

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
    
    // Agregar listeners para actualizar el estado del botón
    _emailController.addListener(_updateButtonState);
    _cardNumberController.addListener(_updateButtonState);
    _cardHolderController.addListener(_updateButtonState);
    _cvcController.addListener(_updateButtonState);
    _phoneController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {});
  }

  @override
  void dispose() {
    _emailController.removeListener(_updateButtonState);
    _cardNumberController.removeListener(_updateButtonState);
    _cardHolderController.removeListener(_updateButtonState);
    _cvcController.removeListener(_updateButtonState);
    _phoneController.removeListener(_updateButtonState);
    
    _emailController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _cvcController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  String _pageTitle(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    switch (widget.paymentMethod) {
      case 'card':
        return _cardType == null
            ? l10n.selectCardTypeLabel
            : l10n.cardNumberLabel;
      case 'nequi':
        return l10n.nequiPaymentLabel;
      case 'cash':
        return l10n.cashEffectiveLabel;
      default:
        return l10n.paymentMethodLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(_pageTitle(context)),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
        elevation: 0,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.orderSummaryLabel,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.orderCodeLabel,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                widget.order.code,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[300] : Colors.grey[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: isDark ? Colors.grey[800] : Colors.grey[300]),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.totalToPayLabel,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
              Text(
                '\$ ${widget.order.total.toStringAsFixed(0)} COP',
                style: const TextStyle(
                  fontSize: 22,
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.selectCardTypeLabel,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _CardTypeButton(
                icon: Icons.credit_card,
                title: AppLocalizations.of(context)!.creditCardLabel,
                subtitle: AppLocalizations.of(context)!.upTo36Installments,
                isSelected: _cardType == 'credit',
                isDark: isDark,
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
                title: AppLocalizations.of(context)!.debitCardLabel,
                subtitle: AppLocalizations.of(context)!.cashPaymentSingle,
                isSelected: _cardType == 'debit',
                isDark: isDark,
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.cardNumberLabel,
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
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.cardHolderNameLabel,
            hintText: AppLocalizations.of(context)!.cardHolderExample,
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.monthLabel,
                  border: const OutlineInputBorder(),
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.yearLabel,
                  border: const OutlineInputBorder(),
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
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.cvcLabel,
                  hintText: '123',
                  border: const OutlineInputBorder(),
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
            decoration: InputDecoration(
              labelText: AppLocalizations.of(context)!.installmentsLabel,
              border: const OutlineInputBorder(),
            ),
            value: _installments,
            items: [1, 2, 3, 6, 9, 12, 18, 24, 36].map((int value) {
              final l10n = AppLocalizations.of(context)!;
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value ${value == 1 ? l10n.installmentSingular : l10n.installmentPlural}'),
              );
            }).toList(),
            onChanged: (value) => setState(() => _installments = value ?? 1),
          ),
      ],
    );
  }

  Widget _buildNequiForm() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.enterNequiNumberLabel,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _phoneController,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
          ),
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context)!.cellphoneNumberLabel,
            hintText: '3001234567',
            prefixIcon: const Icon(Icons.phone_android),
            border: const OutlineInputBorder(),
            helperText: AppLocalizations.of(context)!.nequiAppRequirement,
            helperStyle: TextStyle(
              color: isDark ? Colors.grey[500] : Colors.grey[600],
            ),
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
            color: isDark 
                ? const Color(0xFF8B34D9).withOpacity(0.15)
                : const Color(0xFFf8e6ff),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark 
                  ? const Color(0xFF8B34D9).withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF8B34D9)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  AppLocalizations.of(context)!.nequiNotificationMessage,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey[300] : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCashForm() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.cashPaymentLabel,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark 
                ? const Color(0xFF4CAF50).withOpacity(0.15)
                : const Color(0xFFe8f5e9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark 
                  ? const Color(0xFF4CAF50).withOpacity(0.3)
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.info_outline, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AppLocalizations.of(context)!.paymentInstructionsLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '• ${AppLocalizations.of(context)!.prepareExactAmount} \$ ${widget.order.total.toStringAsFixed(0)} COP',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• ${AppLocalizations.of(context)!.deliverMoneyToDriver}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '• ${AppLocalizations.of(context)!.requestReceipt}',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.grey[300] : Colors.black87,
                ),
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
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)!.emailAddressLabel,
        hintText: AppLocalizations.of(context)!.yourEmailPlaceholder,
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
          title: Text.rich(
            TextSpan(
              text: AppLocalizations.of(context)!.acceptTermsStart,
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.termsAndConditionsLink,
                  style: const TextStyle(
                    color: Color.fromRGBO(237, 88, 33, 1),
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(text: AppLocalizations.of(context)!.acceptTermsEnd),
              ],
            ),
          ),
          controlAffinity: ListTileControlAffinity.leading,
          contentPadding: EdgeInsets.zero,
        ),
        CheckboxListTile(
          value: _acceptData,
          onChanged: (value) => setState(() => _acceptData = value ?? false),
          title: Text.rich(
            TextSpan(
              text: AppLocalizations.of(context)!.authorizeDataStart,
              children: [
                TextSpan(
                  text: AppLocalizations.of(context)!.personalDataTreatmentLink,
                  style: const TextStyle(
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final canProceed = _canProceedWithPayment();

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: canProceed && !_isProcessing ? _processPayment : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
          disabledBackgroundColor: isDark 
              ? Colors.grey[800]
              : Colors.grey[300],
          disabledForegroundColor: isDark
              ? Colors.grey[600]
              : Colors.grey[500],
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
      // Validar que todos los campos de la tarjeta estén llenos
      if (_cardNumberController.text.isEmpty) return false;
      if (_cardHolderController.text.isEmpty) return false;
      if (_expMonth == null || _expYear == null) return false;
      if (_cvcController.text.isEmpty) return false;
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
          content: Text('${AppLocalizations.of(context)!.error}: ${e.toString()}'),
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
  final bool isDark;
  final VoidCallback onTap;

  const _CardTypeButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected 
              ? const Color.fromRGBO(237, 88, 33, 0.1) 
              : (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color.fromRGBO(237, 88, 33, 1)
                : (isDark ? Colors.grey[800]! : Colors.grey[300]!),
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
                  : (isDark ? Colors.grey[500] : Colors.grey[600]),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected 
                    ? const Color.fromRGBO(237, 88, 33, 1) 
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
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
