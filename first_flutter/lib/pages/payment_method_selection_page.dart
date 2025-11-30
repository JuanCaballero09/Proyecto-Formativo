import 'package:flutter/material.dart';
import '../models/order.dart';
import 'payment_form_page.dart';
import '../l10n/app_localizations.dart';

class PaymentMethodSelectionPage extends StatelessWidget {
  final Order order;

  const PaymentMethodSelectionPage({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.paymentMethodLabel),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              AppLocalizations.of(context)!.selectPaymentMethodTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${AppLocalizations.of(context)!.orderLabel} ${order.code}',
              style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 30),

            // Payment Methods Grid
            _PaymentMethodCard(
              icon: Icons.credit_card,
              title: AppLocalizations.of(context)!.creditDebitCardTitle,
              description: AppLocalizations.of(context)!.creditDebitCardDesc,
              color: const Color.fromRGBO(237, 88, 33, 1),
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentFormPage(
                      order: order,
                      paymentMethod: 'card',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            _PaymentMethodCard(
              title: AppLocalizations.of(context)!.nequiTitle,
              description: AppLocalizations.of(context)!.nequiDesc,
              color: const Color(0xFF8B34D9),
              isDark: isDark,
              useImage: true,
              imagePath: 'assets/NequiLogo.png',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentFormPage(
                      order: order,
                      paymentMethod: 'nequi',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            _PaymentMethodCard(
              icon: Icons.attach_money,
              title: AppLocalizations.of(context)!.cashTitle,
              description: AppLocalizations.of(context)!.cashDesc,
              color: const Color(0xFF4CAF50),
              isDark: isDark,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentFormPage(
                      order: order,
                      paymentMethod: 'cash',
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;
  final bool useImage;
  final String? imagePath;

  const _PaymentMethodCard({
    this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
    required this.isDark,
    this.useImage = false,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: useImage ? Colors.white : color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: useImage && imagePath != null
                  ? ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Image.asset(
                          imagePath!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    )
                  : Icon(
                      icon,
                      color: color,
                      size: 30,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
