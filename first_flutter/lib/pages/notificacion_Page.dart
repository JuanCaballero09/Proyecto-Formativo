import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class NotificacionPage extends StatefulWidget {
  @override
  NotificacionPageState createState() => NotificacionPageState();
}

class NotificacionPageState extends State<NotificacionPage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.notifications),

    ));
  }
}
