import 'package:flutter/material.dart';

import '../profile.dart' as profile;
import '../widget/family_section.dart';
import '../widget/shared_widgets.dart';

class FamilyPage extends StatelessWidget {
  const FamilyPage({super.key});

  @override
  Widget build(BuildContext context) => const PageContent(
        children: [
          HeroPanel(
            icon: Icons.groups_outlined,
            title: 'Ma famille',
            subtitle: 'Nos parents et leurs neuf enfants',
          ),
          FamilySection(title: 'Mes parents', members: profile.parents),
          FamilySection(title: 'La fratrie, de l’aîné au plus jeune',
              members: profile.siblings),
        ],
      );
}
