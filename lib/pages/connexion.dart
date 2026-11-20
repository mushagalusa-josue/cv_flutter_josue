import 'package:flutter/material.dart';

import '../profile.dart' as profile;
import '../widget/shared_widgets.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key, required this.onSuccess});
  final VoidCallback onSuccess;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const HeroPanel(
                      icon: Icons.badge_outlined,
                      title: profile.name,
                      subtitle: profile.role,
                      photo: profile.photo,
                    ),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: onSuccess,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        child: Text('Se connecter'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
