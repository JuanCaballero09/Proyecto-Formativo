import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class NotificacionPage extends StatefulWidget {
  @override
  NotificacionPageState createState() => NotificacionPageState();
}

class NotificacionPageState extends State<NotificacionPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notificationsPage),
        backgroundColor: const Color.fromRGBO(237, 88, 33, 1),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off,
              size: 80,
              color: Colors.grey,
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.noNotifications,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
