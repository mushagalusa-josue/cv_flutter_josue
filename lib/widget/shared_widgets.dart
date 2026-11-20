import 'package:flutter/material.dart';

import 'colors.dart';

class PageContent extends StatelessWidget {
  const PageContent({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            children: children,
          ),
        ),
      );
}

class HeroPanel extends StatelessWidget {
  const HeroPanel({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.photo = '',
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String photo;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: ink,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Portrait(photo: photo, icon: icon, radius: 26),
            const SizedBox(height: 14),
            Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: mint, fontSize: 14)),
          ],
        ),
      );
}

class Portrait extends StatelessWidget {
  const Portrait({super.key, required this.photo, required this.icon, this.radius = 22});
  final String photo;
  final IconData icon;
  final double radius;

  @override
  Widget build(BuildContext context) => CircleAvatar(
        backgroundColor: mint,
        radius: radius,
        child: photo.isEmpty
            ? Icon(icon, color: teal)
            : ClipOval(
                child: Image.asset(
                  photo,
                  width: radius * 2,
                  height: radius * 2,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(icon, color: teal),
                ),
              ),
      );
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;

  @override
  Widget build(BuildContext context) => Card(
        color: Colors.white,
        margin: const EdgeInsets.only(top: 10),
        child: ListTile(
          leading: Icon(icon, color: teal),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(body),
        ),
      );
}
