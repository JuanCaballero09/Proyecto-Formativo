import 'package:flutter/material.dart';

class PedidoPage extends StatefulWidget {
  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
      body: Stack(
        children: [
          Positioned(
            top: 140,
            left: 90,
            child: Column(
              children: [
                Image.asset('assets/imagen6.png', height: 100),

                Text(
                  'Pedido Realizado',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Arial',
                  ),
                ),
                Text(
                  'Tu pedido ha sido realizado con éxito',
                  style: TextStyle(fontSize: 20, fontFamily: 'Arial'),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
