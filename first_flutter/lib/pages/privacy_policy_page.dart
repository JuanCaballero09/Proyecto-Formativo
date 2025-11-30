import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.privacyPolicyLabel),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.privacyPolicyTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            Text(
              l10n.privacyPolicyIntro,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),
            _sectionTitle(l10n.privacySection1Title),
            _bulletItem(l10n.privacySection1Item1),
            _bulletItem(l10n.privacySection1Item2),
            _bulletItem(l10n.privacySection1Item3),
            _bulletItem(l10n.privacySection1Item4),

            const SizedBox(height: 25),
            _sectionTitle(l10n.privacySection2Title),
            _bulletItem(l10n.privacySection2Item1),
            _bulletItem(l10n.privacySection2Item2),
            _bulletItem(l10n.privacySection2Item3),
            _bulletItem(l10n.privacySection2Item4),

            const SizedBox(height: 25),
            _sectionTitle(l10n.privacySection3Title),
            Text(
              l10n.privacySection3Text,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),
            _sectionTitle(l10n.privacySection4Title),
            Text(
              l10n.privacySection4Text,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 25),
            _sectionTitle(l10n.privacySection5Title),
            _bulletItem(l10n.privacySection5Item1),
            _bulletItem(l10n.privacySection5Item2),
            _bulletItem(l10n.privacySection5Item3),

            const SizedBox(height: 25),
            _sectionTitle(l10n.privacySection6Title),
            Text(
              l10n.privacySection6Text,
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 40),
            Center(
              child: Text(
                l10n.privacyLastUpdate,
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
