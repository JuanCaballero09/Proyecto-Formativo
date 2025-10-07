import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class DomicilioPage extends StatefulWidget {
  @override
  DomicilioPageState createState() => DomicilioPageState();
}

class DomicilioPageState extends State<DomicilioPage> {
  @override
  Widget build(BuildContext context) {
    final pedidos = [
      {
        "id": "001", 
        "estado": AppLocalizations.of(context)!.onTheWay, 
        "tiempo": "15 min",
        "direccion": "Calle 123 #45-67",
        "total": "35000",
        "productos": ["Pizza Hawaiana", "Coca Cola"],
        "repartidor": "Juan Pérez",
        "telefono": "+57 300 123 4567",
        "observaciones": "Entregar en la portería"
      },
      {
        "id": "002", 
        "estado": AppLocalizations.of(context)!.preparing, 
        "tiempo": "25 min",
        "direccion": "Carrera 89 #13-34", 
        "total": "42000",
        "productos": ["Hamburguesa BBQ", "Papas Fritas", "Ensalada César"],
        "repartidor": null,
        "telefono": null,
        "observaciones": "Sin cebolla en la hamburguesa"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Domicilios'),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: pedidos.isEmpty 
        ? _buildEmptyState()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: pedidos.length,
            itemBuilder: (context, index) {
              final pedido = pedidos[index];
              return _buildCompactCard(pedido);
            },
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
            'No tienes domicilios activos',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCard(Map<String, dynamic> pedido) {
    final isOnTheWay = pedido["estado"] == AppLocalizations.of(context)!.onTheWay;
    final statusColor = isOnTheWay ? Colors.green : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _showExpandedDetails(pedido),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icono de estado
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isOnTheWay ? Icons.delivery_dining : Icons.restaurant,
                  color: statusColor,
                  size: 24,
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${AppLocalizations.of(context)!.orderID} #${pedido["id"]}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "\$${pedido["total"]} COP",
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
                      pedido["estado"],
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    
                    const SizedBox(height: 2),
                    
                    Text(
                      "${AppLocalizations.of(context)!.estimatedTime}: ${pedido["tiempo"]}",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Indicador de expandir
              Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey[400],
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showExpandedDetails(Map<String, dynamic> pedido) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle del modal
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Contenido expandido
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${AppLocalizations.of(context)!.orderID} #${pedido["id"]}",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: pedido["estado"] == AppLocalizations.of(context)!.onTheWay 
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              pedido["estado"],
                              style: TextStyle(
                                color: pedido["estado"] == AppLocalizations.of(context)!.onTheWay 
                                  ? Colors.green[700]
                                  : Colors.orange[700],
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Información del pedido
                      _buildDetailSection(
                        "Información del Pedido",
                        [
                          _buildDetailRow(Icons.access_time, "Tiempo estimado", pedido["tiempo"]),
                          _buildDetailRow(Icons.attach_money, "Total", "\$${pedido["total"]} COP"),
                          _buildDetailRow(Icons.location_on, "Dirección", pedido["direccion"]),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Productos
                      _buildDetailSection(
                        "Productos",
                        (pedido["productos"] as List).map((producto) => 
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              children: [
                                Icon(Icons.restaurant_menu, size: 16, color: Colors.grey[600]),
                                const SizedBox(width: 8),
                                Text(producto, style: TextStyle(fontSize: 14)),
                              ],
                            ),
                          )
                        ).toList(),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Repartidor (si está asignado)
                      if (pedido["repartidor"] != null)
                        _buildDetailSection(
                          "Repartidor",
                          [
                            _buildDetailRow(Icons.person, "Nombre", pedido["repartidor"]),
                            if (pedido["telefono"] != null)
                              _buildDetailRow(Icons.phone, "Teléfono", pedido["telefono"]),
                          ],
                        ),
                      
                      const SizedBox(height: 20),
                      
                      // Observaciones
                      if (pedido["observaciones"] != null)
                        _buildDetailSection(
                          "Observaciones",
                          [
                            Text(
                              pedido["observaciones"],
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      
                      const SizedBox(height: 30),
                      
                      // Botones de acción
                      Row(
                        children: [
                          if (pedido["estado"] == AppLocalizations.of(context)!.onTheWay) ...[
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _trackOrder(pedido["id"]),
                                icon: Icon(Icons.location_searching),
                                label: Text("Rastrear"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _contactSupport(pedido["id"]),
                              icon: Icon(Icons.support_agent),
                              label: Text("Contactar"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _trackOrder(String orderId) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Abriendo mapa para rastrear pedido #$orderId")),
    );
  }

  void _contactSupport(String orderId) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Contactando soporte para pedido #$orderId")),
    );
  }
}