import 'package:flutter/material.dart';

import '../api.dart';
import '../pages/acceuil.dart';
import '../pages/contact.dart';
import '../pages/famille.dart';

class Portfolio extends StatefulWidget {
  const Portfolio({super.key, required this.api, required this.onLogout});
  final Api api;
  final VoidCallback onLogout;

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {
  int index = 0;
  static const titles = ['Accueil', 'Famille', 'Contact'];
  late final pages = [
    const ResumePage(),
    FamilyPage(api: widget.api),
    const ContactPage()
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(titles[index]),
          actions: [
            IconButton(
              tooltip: 'Se déconnecter',
              onPressed: widget.onLogout,
              icon: const Icon(Icons.logout),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: IndexedStack(index: index, children: pages),
        bottomNavigationBar: NavigationBar(
          selectedIndex: index,
          onDestinationSelected: (value) => setState(() => index = value),
          destinations: const [
            NavigationDestination(
                icon: Icon(Icons.badge_outlined), label: 'Accueil'),
            NavigationDestination(
                icon: Icon(Icons.groups_outlined), label: 'Famille'),
            NavigationDestination(
                icon: Icon(Icons.alternate_email), label: 'Contact'),
          ],
        ),
      );
}
