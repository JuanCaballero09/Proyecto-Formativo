import 'package:flutter/material.dart';

class DomicilioPage extends StatefulWidget {
  @override
  DomicilioPageState createState() => DomicilioPageState();
}

class DomicilioPageState extends State<DomicilioPage> {
 @override
  Widget build(BuildContext context) {
    final pedidos = [
      {"id": "001", "estado": "En camino", "tiempo": "15 min"},
      {"id": "002", "estado": "Preparando", "tiempo": "25 min"},
    ];

    return Scaffold(
            
      body: ListView.builder(
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final pedido = pedidos[index];
          return Card(
            margin: const EdgeInsets.all(12),
            child: ListTile(
              leading: const Icon(Icons.delivery_dining, color: Colors.orange),
              title: Text("Pedido #${pedido["id"]}"),
              subtitle: Text("Estado: ${pedido["estado"]}\nTiempo estimado: ${pedido["tiempo"]}"),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Aquí luego puedes abrir detalles del pedido
              },
            ),
          );
        },
      ),
    );
  }
}