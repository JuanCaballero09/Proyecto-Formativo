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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.searchOrdersTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.searchOrdersPrompt,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.emailHint,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final email = _emailController.text.trim();
              if (email.isNotEmpty) {
                setState(() {
                  _guestEmail = email; // Guardar el email del invitado
                });
                Navigator.pop(context);
                _loadOrders(guestEmail: email);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
            ),
            child: Text(AppLocalizations.of(context)!.search, style: const TextStyle(color: Colors.white)),
          ),
        ],
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
            children: [
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
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '#${order['code'] ?? 'N/A'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '\$${NumberFormat('#,###', 'es_CO').format(order['total'] ?? 0)}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          statusText,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${order['items']?.length ?? 0} ${AppLocalizations.of(context)!.productsLabel}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey[400]),
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
                    label: const Text(
                      'Ir a Pagar',
                      style: TextStyle(
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
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${AppLocalizations.of(context)!.orderNumber} #${order['code']}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(AppLocalizations.of(context)!.orderStatus, _getStatusText(order['status'] ?? 'pendiente')),
              _buildDetailRow(AppLocalizations.of(context)!.totalPrice, '\$${NumberFormat('#,###', 'es_CO').format(order['total'] ?? 0)}'),
              
              // Dirección con botón de editar
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        '${AppLocalizations.of(context)!.deliveryAddress}:',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(order['direccion'] ?? 'N/A'),
                          if (canEditAddress) ...[
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                _showEditAddressDialog(order);
                              },
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.edit, size: 16, color: Color.fromRGBO(237, 88, 33, 1)),
                                  SizedBox(width: 4),
                                  Text(
                                    'Editar dirección',
                                    style: TextStyle(
                                      color: Color.fromRGBO(237, 88, 33, 1),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const Divider(),
              Text(AppLocalizations.of(context)!.productsLabel, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...(order['items'] as List? ?? []).map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• ${item['product_name']} x${item['quantity']}'),
                );
              }).toList(),
            ],
          ),
        ),
        actions: [
          if (order['status'] == 'pendiente' || order['status'] == 'pagado')
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _cancelOrder(order['code']);
              },
              child: Text(AppLocalizations.of(context)!.cancel, style: const TextStyle(color: Colors.red)),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.close),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
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