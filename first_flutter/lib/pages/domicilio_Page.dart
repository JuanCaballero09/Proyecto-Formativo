import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../l10n/app_localizations.dart';
import '../bloc/auth/auth_bloc.dart';
import '../bloc/auth/auth_state.dart';
import '../service/api_service.dart';
import '../core/errors/exceptions.dart';

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
    final authState = context.read<AuthBloc>().state;
    setState(() {
      _isAuthenticated = authState is Authenticated;
      _isCheckingAuth = false;
    });

    if (_isAuthenticated) {
      await _loadOrders();
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
                labelText: AppLocalizations.of(context)?.email ?? 'Email',
                hintText: AppLocalizations.of(context)?.emailHint ?? 'correo@ejemplo.com',
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
    return Center(
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
    );
  }

  Widget _buildEmptyState() {
    return Center(
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
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    final status = order['status'] ?? 'pendiente';
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showOrderDetails(order),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
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
        ),
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
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
              _buildDetailRow(AppLocalizations.of(context)!.deliveryAddress, order['direccion'] ?? 'N/A'),
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
      default:
        return AppLocalizations.of(context)!.statusUnknown;
    }
  }

  Widget _buildBody() {
    if (_isCheckingAuth) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_isAuthenticated && _orders.isEmpty) {
      return _buildGuestWelcome();
    }

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_orders.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: () => _loadOrders(
        guestEmail: _isAuthenticated ? null : _emailController.text.trim(),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length,
        itemBuilder: (context, index) => _buildOrderCard(_orders[index]),
      ),
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
      body: _buildBody(),
    );
  }
}