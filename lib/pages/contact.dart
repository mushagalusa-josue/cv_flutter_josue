import 'package:flutter/material.dart';

import '../profile.dart' as profile;
import '../widget/contact_card.dart';
import '../widget/shared_widgets.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) => const PageContent(
        children: [
          HeroPanel(icon: Icons.mail_outline, title: 'Me contacter', subtitle: profile.city),
          ContactCard(icon: Icons.phone_outlined, title: 'Téléphone', value: profile.phone, scheme: 'tel'),
          ContactCard(icon: Icons.email_outlined, title: 'E-mail', value: profile.email, scheme: 'mailto'),
          InfoCard(icon: Icons.place_outlined, title: 'Adresse', body: profile.city),
          ContactCard(icon: Icons.code, title: 'GitHub', value: profile.github),
          ContactCard(icon: Icons.business_center_outlined, title: 'LinkedIn', value: profile.linkedIn),
        ],
      );
}
