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
      {"id": "001", "estado": AppLocalizations.of(context)!.onTheWay, "tiempo": "15 min"},
      {"id": "002", "estado": AppLocalizations.of(context)!.preparing, "tiempo": "25 min"},
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
              title: Text("${AppLocalizations.of(context)!.orderID} #${pedido["id"]}"),
              subtitle: Text("${AppLocalizations.of(context)!.orderStatus}: ${pedido["estado"]}\n${AppLocalizations.of(context)!.estimatedTime}: ${pedido["tiempo"]}"),
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