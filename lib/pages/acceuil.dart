import 'package:flutter/material.dart';

import '../profile.dart' as profile;
import '../widget/shared_widgets.dart';

class ResumePage extends StatelessWidget {
  const ResumePage({super.key});

  @override
  Widget build(BuildContext context) => const PageContent(
        children: [
          HeroPanel(
            icon: Icons.person_outline,
            photo: profile.photo,
            title: profile.name,
            subtitle: '${profile.role}  ·  Goma, RDC',
          ),
          InfoCard(title: 'Formation', body: 'ISIG-Goma · Licence 3 LIAGE', icon: Icons.school_outlined),
          InfoCard(title: 'Expériences et projets', body: 'CampusShare : application de location de matériel informatique. KASKD Scheduler : projet de planification de tâches en Python.', icon: Icons.work_outline),
          InfoCard(title: 'Compétences techniques', body: 'JavaScript, TypeScript, React, Next.js, Python et Git', icon: Icons.code),
          InfoCard(title: 'Langues', body: 'À compléter', icon: Icons.translate),
          InfoCard(title: 'Centres d’intérêt', body: 'Développement web et intelligence artificielle', icon: Icons.favorite_outline),
        ],
      );
}
