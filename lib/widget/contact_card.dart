import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'colors.dart';

class ContactCard extends StatelessWidget {
  const ContactCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    this.scheme = 'https',
  });

  final IconData icon;
  final String title;
  final String value;
  final String scheme;

  Future<void> open(BuildContext context) async {
    final uri = scheme == 'https'
        ? Uri.tryParse(value)
        : Uri(scheme: scheme, path: value);
    if (uri != null && uri.scheme == scheme) {
      try {
        if (await launchUrl(uri)) return;
      } catch (_) {
        // Certains appareils ne disposent pas d’application compatible.
      }
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Impossible d’ouvrir ce contact.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10),
        child: ListTile(
          leading: Icon(icon, color: teal),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(value.isEmpty ? 'À renseigner' : value),
          trailing: value.isEmpty ? null : const Icon(Icons.open_in_new, size: 18),
          onTap: value.isEmpty ? null : () => open(context),
        ),
      );
}
