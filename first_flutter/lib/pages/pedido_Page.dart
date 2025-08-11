import 'package:flutter/material.dart';

class PedidoPage extends StatefulWidget {
  @override
  State<PedidoPage> createState() => _PedidoPageState();
}

class _PedidoPageState extends State<PedidoPage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 100),
            Image.asset('assets/imagen6.png', height: 100),

            Text(
              'Pedido Realizado',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),
            Text(
              'Tu pedido ha sido realizado con éxito',
              style: TextStyle(
                fontSize: 20,
                fontFamily: 'Arial',
                color: Colors.white,
              ),
            ),

            Image.asset('assets/imagen8.png', height: 200),

            SizedBox(height: 40),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Aceptar"),
              style: ElevatedButton.styleFrom(
                 backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
