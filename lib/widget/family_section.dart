import 'package:flutter/material.dart';

import '../profile.dart' as profile;
import 'shared_widgets.dart';

class FamilySection extends StatelessWidget {
  const FamilySection({super.key, required this.title, required this.members});

  final String title;
  final List<profile.Relative> members;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            for (final relative in members)
              Card(
                color: Colors.white,
                margin: const EdgeInsets.only(top: 10),
                child: ListTile(
                  leading: Portrait(photo: relative.photo, icon: Icons.person_outline),
                  title: Text(relative.name),
                  subtitle: Text(
                    '${relative.relationship} · ${relative.description}',
                  ),
                ),
              ),
          ],
        ),
      );
}
