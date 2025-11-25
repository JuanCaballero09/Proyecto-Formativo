import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Política de Privacidad"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Política de Privacidad",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            const Text(
              "Tu privacidad es importante para nosotros. Esta política explica "
              "cómo recolectamos, usamos y protegemos tu información dentro de "
              "nuestra aplicación de comida rápida.",
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),
            _sectionTitle("1. Información que recopilamos"),
            _bulletItem("Datos personales como nombre, correo y número telefónico."),
            _bulletItem("Direcciones para entrega."),
            _bulletItem("Información del dispositivo para mejorar la experiencia."),
            _bulletItem("Historial de pedidos."),

            const SizedBox(height: 25),
            _sectionTitle("2. Uso de la información"),
            _bulletItem("Procesar pedidos y entregas."),
            _bulletItem("Mejorar la experiencia del usuario."),
            _bulletItem("Enviar notificaciones relacionadas con tus pedidos."),
            _bulletItem("Ofrecer promociones y descuentos."),

            const SizedBox(height: 25),
            _sectionTitle("3. Protección de datos"),
            const Text(
              "Usamos estándares de seguridad modernos para proteger tus datos, "
              "incluyendo cifrado y protocolos seguros. No vendemos tu información.",
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),
            _sectionTitle("4. Terceros"),
            const Text(
              "Podemos compartir tu información únicamente con servicios "
              "necesarios para operar la app, como procesadores de pago o "
              "servicios de entrega.",
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),
            _sectionTitle("5. Derechos del usuario"),
            _bulletItem("Solicitar eliminación de tu cuenta."),
            _bulletItem("Actualizar tus datos personales."),
            _bulletItem("Acceder a la información que almacenamos."),

            const SizedBox(height: 25),
            _sectionTitle("6. Cambios en la política"),
            const Text(
              "Podemos actualizar esta política en cualquier momento. Te avisaremos "
              "si se realizan cambios importantes.",
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                "Última actualización: 2025",
                style: TextStyle(color: Colors.grey[600]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _bulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("•  "),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
