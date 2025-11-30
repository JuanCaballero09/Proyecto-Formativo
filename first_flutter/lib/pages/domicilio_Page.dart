import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../service/api_service.dart';
import '../core/errors/exceptions.dart';
import '../models/order.dart';
import 'payment_method_selection_page.dart';

class DomicilioPage extends StatefulWidget {
  const DomicilioPage({super.key});

  @override
  DomicilioPageState createState() => DomicilioPageState();
}

class DomicilioPageState extends State<DomicilioPage> {
  final TextEditingController _emailController = TextEditingController();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = false;
  bool _isAuthenticated = false;
  bool _isCheckingAuth = true;
  String? _guestEmail; // Para recordar el email del invitado

  @override
  void initState() {
    super.initState();
    _checkAuthAndLoadOrders();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _checkAuthAndLoadOrders() async {
    setState(() => _isCheckingAuth = true);
    
    try {
      // Verificar si hay token almacenado
      final api = ApiService();
      final token = await api.storage.read(key: 'token');
      
      // Verificar el estado del AuthBloc
      final authState = context.read<AuthBloc>().state;
      final isAuthenticatedByBloc = authState is Authenticated;
      
      // Considerar autenticado si hay token O si el AuthBloc indica autenticación
      final hasValidSession = token != null || isAuthenticatedByBloc;
      
      setState(() {
        _isAuthenticated = hasValidSession;
        _isCheckingAuth = false;
      });

      if (_isAuthenticated) {
        await _loadOrders();
      } else if (_guestEmail != null && _guestEmail!.isNotEmpty) {
        // Si hay email de invitado guardado, recargar esas órdenes
        await _loadOrders(guestEmail: _guestEmail);
      }
    } catch (e) {
      // En caso de error, asumir no autenticado
      setState(() {
        _isAuthenticated = false;
        _isCheckingAuth = false;
      });
    }
  }

  Future<void> _loadOrders({String? guestEmail}) async {
    setState(() => _isLoading = true);
    try {
      final api = ApiService();
      final orders = await api.getOrders(guestEmail: guestEmail);
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } on DataException catch (e) {
      _showError(e.message);
      setState(() => _isLoading = false);
    } on NetworkException catch (e) {
      _showError(e.message);
      setState(() => _isLoading = false);
    } catch (e) {
      _showError('${AppLocalizations.of(context)!.loadingOrdersError}: $e');
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _navigateToPayment(Map<String, dynamic> orderData) {
    final order = Order(
      code: orderData['code'] ?? '',
      total: (orderData['total'] ?? 0).toDouble(),
      status: orderData['status'] ?? 'pending',
      customerEmail: orderData['customer_email'],
      address: orderData['direccion'],
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentMethodSelectionPage(order: order),
      ),
    ).then((_) {
      // Recargar órdenes al volver
      _loadOrders(
        guestEmail: _isAuthenticated ? null : _emailController.text.trim(),
      );
    });
  }

  void _showEmailDialog() {
    _emailController.clear();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(237, 88, 33, 1).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search,
                  color: Color.fromRGBO(237, 88, 33, 1),
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                AppLocalizations.of(context)!.searchOrdersTitle,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              
              // Description
              Text(
                AppLocalizations.of(context)!.searchOrdersPrompt,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              
              // Email field
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.email,
                  hintText: AppLocalizations.of(context)!.emailHint,
                  labelStyle: TextStyle(
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey[600] : Colors.grey[400],
                  ),
                  filled: true,
                  fillColor: isDark
                      ? const Color(0xFF2C2C2C)
                      : Colors.grey[50],
                  prefixIcon: Icon(
                    Icons.email_rounded,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(237, 88, 33, 1),
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.cancel,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: () {
                        final email = _emailController.text.trim();
                        if (email.isNotEmpty) {
                          setState(() {
                            _guestEmail = email;
                          });
                          Navigator.pop(context);
                          _loadOrders(guestEmail: email);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.search,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestWelcome() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_outline, size: 80, color: Colors.grey[400]),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.guestMode,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.searchOrdersPrompt,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _showEmailDialog,
                  icon: const Icon(Icons.search, color: Colors.white),
                  label: Text(AppLocalizations.of(context)!.searchOrdersTitle, style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.delivery_dining, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.noOrders,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              if (!_isAuthenticated) ...[
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _showEmailDialog,
                  child: Text(AppLocalizations.of(context)!.searchWithAnotherEmail),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'pendiente';
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);
    final isPending = status == 'pendiente';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showOrderDetails(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con código e icono
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getStatusIcon(status),
                      color: statusColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '#${order['code'] ?? 'N/A'}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Estado y productos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    '${order['items']?.length ?? 0} ${AppLocalizations.of(context)!.productsLabel}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Total
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '\$${NumberFormat('#,###', 'es_CO').format(order['total'] ?? 0)} COP',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              if (isPending) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _navigateToPayment(order),
                    icon: const Icon(Icons.payment, color: Colors.white, size: 20),
                    label: Text(
                      AppLocalizations.of(context)!.goToPayButton,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    final canEditAddress = order['status'] == 'pendiente' || order['status'] == 'pagado';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = order['status'] ?? 'pendiente';
    final statusText = _getStatusText(status);
    final statusColor = _getStatusColor(status);
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con código de orden
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color.fromRGBO(237, 88, 33, 1), Color(0xFFFF6E40)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.receipt_long,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.orderNumber,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '#${order['code']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Estado y Total
                      Row(
                        children: [
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.info_outline,
                              label: AppLocalizations.of(context)!.orderStatus,
                              value: statusText,
                              valueColor: statusColor,
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildInfoCard(
                              icon: Icons.attach_money,
                              label: AppLocalizations.of(context)!.totalPrice,
                              value: '\$${NumberFormat('#,###', 'es_CO').format(order['total'] ?? 0)}',
                              valueColor: Colors.green[700]!,
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Dirección de entrega
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 20,
                                  color: isDark ? Colors.white70 : Colors.grey[700],
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.deliveryAddress,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: isDark ? Colors.white : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              order['direccion'] ?? 'N/A',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark ? Colors.white70 : Colors.grey[700],
                                height: 1.4,
                              ),
                            ),
                            if (canEditAddress) ...[
                              const SizedBox(height: 12),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  _showEditAddressDialog(order);
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Color.fromRGBO(237, 88, 33, 1),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      AppLocalizations.of(context)!.editAddress,
                                      style: const TextStyle(
                                        color: Color.fromRGBO(237, 88, 33, 1),
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Productos
                      Text(
                        AppLocalizations.of(context)!.productsLabel,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          children: [
                            ...(order['items'] as List? ?? []).asMap().entries.map((entry) {
                              final index = entry.key;
                              final item = entry.value;
                              final isLast = index == (order['items'] as List).length - 1;
                              
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  border: !isLast ? Border(
                                    bottom: BorderSide(
                                      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
                                    ),
                                  ) : null,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color.fromRGBO(237, 88, 33, 1),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        item['product_name'] ?? '',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: isDark ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color.fromRGBO(237, 88, 33, 1).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'x${item['quantity']}',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromRGBO(237, 88, 33, 1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Botones de acción
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: Row(
                    children: [
                      if (order['status'] == 'pendiente' || order['status'] == 'pagado')
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await _cancelOrder(order['code']);
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              AppLocalizations.of(context)!.cancel,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      if (order['status'] == 'pendiente' || order['status'] == 'pagado')
                        const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.close,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
    required Color valueColor,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 18,
            color: isDark ? Colors.white70 : Colors.grey[600],
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isDark ? Colors.white60 : Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder(String code) async {
    try {
      final api = ApiService();
      final email = _isAuthenticated ? null : _emailController.text.trim();
      await api.cancelOrder(code, guestEmail: email);
      _showError(AppLocalizations.of(context)!.orderCancelled);
      await _loadOrders(guestEmail: email);
    } on DataException catch (e) {
      _showError(e.message);
    } on NetworkException catch (e) {
      _showError(e.message);
    } catch (e) {
      _showError('${AppLocalizations.of(context)!.error}: $e');
    }
  }

  void _showEditAddressDialog(Map<String, dynamic> order) {
    final TextEditingController addressController = TextEditingController();
    addressController.text = order['direccion'] ?? '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.location_on, color: Color.fromRGBO(237, 88, 33, 1)),
            const SizedBox(width: 8),
            Text(
              'Editar Dirección',
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orden: #${order['code']}',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: addressController,
              style: TextStyle(color: isDarkMode ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                labelText: 'Nueva dirección',
                labelStyle: TextStyle(color: isDarkMode ? Colors.grey[400] : Colors.grey[700]),
                hintText: 'Ej: Calle 123 #45-67, Apto 101',
                hintStyle: TextStyle(color: isDarkMode ? Colors.grey[600] : Colors.grey[400]),
                prefixIcon: Icon(
                  Icons.home,
                  color: isDarkMode ? Colors.grey[400] : Colors.grey[700],
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Color.fromRGBO(237, 88, 33, 1),
                    width: 2,
                  ),
                ),
              ),
              maxLines: 2,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDarkMode 
                    ? Colors.orange.withOpacity(0.15)
                    : Colors.orange[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode 
                      ? Colors.orange.withOpacity(0.3)
                      : Colors.orange[200]!,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 20, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Solo se puede editar si la orden está pendiente o pagada',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? Colors.orange[200] : Colors.orange[900],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: Text(
              'Cancelar',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final newAddress = addressController.text.trim();
              
              if (newAddress.isEmpty) {
                _showDynamicSnackBar(
                  context,
                  'La dirección no puede estar vacía',
                  isError: true,
                );
                return;
              }

              if (newAddress.length < 5) {
                _showDynamicSnackBar(
                  context,
                  'La dirección debe tener al menos 5 caracteres',
                  isError: true,
                );
                return;
              }

              Navigator.pop(dialogContext);
              
              await _updateOrderAddress(order['code'], newAddress);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Guardar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _showDynamicSnackBar(BuildContext context, String message, {bool isError = false, String? subtitle}) {
    // Usar SchedulerBinding para ejecutar después del frame actual
    // Esto previene el error "dependents.isEmpty is not true"
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final overlay = Overlay.of(context);
      late OverlayEntry overlayEntry;
      
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 20,
          right: 20,
          child: Material(
            color: Colors.transparent,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 400),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(
                    opacity: value.clamp(0.0, 1.0),
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isError
                        ? [
                            const Color(0xFFE53935),
                            const Color(0xFFD32F2F),
                          ]
                        : [
                            const Color(0xFF4CAF50),
                            const Color(0xFF45A049),
                          ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: (isError ? const Color(0xFFE53935) : const Color(0xFF4CAF50)).withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isError ? Icons.error_outline_rounded : Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            message,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.3,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              subtitle,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      overlay.insert(overlayEntry);

      Future.delayed(const Duration(milliseconds: 2500), () {
        overlayEntry.remove();
      });
    });
  }

  Future<void> _updateOrderAddress(String orderCode, String newAddress) async {
    try {
      final api = ApiService();
      final email = _isAuthenticated ? null : _emailController.text.trim();
      
      await api.updateOrderAddress(
        orderCode: orderCode,
        newAddress: newAddress,
        guestEmail: email,
      );

      if (!mounted) return;

      _showDynamicSnackBar(
        context,
        '¡Dirección actualizada!',
        subtitle: 'Los cambios se han guardado exitosamente',
        isError: false,
      );

      await _loadOrders(guestEmail: email);
    } on DataException catch (e) {
      if (!mounted) return;
      _showDynamicSnackBar(
        context,
        e.message,
        isError: true,
      );
    } on NetworkException catch (e) {
      if (!mounted) return;
      _showDynamicSnackBar(
        context,
        e.message,
        isError: true,
      );
    } catch (e) {
      if (!mounted) return;
      _showDynamicSnackBar(
        context,
        'Error al actualizar: ${e.toString()}',
        isError: true,
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pendiente':
        return Colors.orange;
      case 'pagado':
        return Colors.blue;
      case 'en_preparacion':
        return Colors.purple;
      case 'enviado':
        return Colors.green;
      case 'entregado':
        return Colors.teal;
      case 'cancelado':
        return Colors.red;
      case 'finalizado':
        return Colors.green[700]!;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pendiente':
        return Icons.schedule;
      case 'pagado':
        return Icons.payment;
      case 'en_preparacion':
        return Icons.restaurant;
      case 'enviado':
        return Icons.delivery_dining;
      case 'entregado':
        return Icons.check_circle;
      case 'cancelado':
        return Icons.cancel;
      case 'finalizado':
        return Icons.done_all;
      default:
        return Icons.help_outline;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pendiente':
        return AppLocalizations.of(context)!.statusPending;
      case 'pagado':
        return AppLocalizations.of(context)!.statusPaid;
      case 'en_preparacion':
        return AppLocalizations.of(context)!.statusInPreparation;
      case 'enviado':
        return AppLocalizations.of(context)!.statusSent;
      case 'entregado':
        return AppLocalizations.of(context)!.statusDelivered;
      case 'cancelado':
        return AppLocalizations.of(context)!.statusCancelled;
      case 'finalizado':
        return AppLocalizations.of(context)!.statusFinished;
      default:
        return AppLocalizations.of(context)!.statusUnknown;
    }
  }

  Widget _buildBody() {
    if (_isCheckingAuth) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (!_isAuthenticated && _orders.isEmpty) {
      return _buildGuestWelcome();
    }

    if (_isLoading) {
      return SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height - 200,
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (_orders.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: _orders.length,
      itemBuilder: (context, index) => _buildOrderCard(_orders[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orders),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
        actions: [
          if (!_isAuthenticated && _orders.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _showEmailDialog,
              tooltip: AppLocalizations.of(context)!.searchWithAnotherEmail,
            ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _checkAuthAndLoadOrders();
        },
        child: _buildBody(),
      ),
    );
  }
}