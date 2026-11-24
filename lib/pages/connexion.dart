import 'package:flutter/material.dart';

import '../api.dart';
import '../profile.dart' as profile;
import '../widget/shared_widgets.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key, required this.onSuccess, required this.api});
  final VoidCallback onSuccess;
  final Api api;

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final form = GlobalKey<FormState>();
  final email = TextEditingController();
  final password = TextEditingController();
  bool busy = false;
  String? notice;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  Future<void> submit({required bool register}) async {
    if (busy || !form.currentState!.validate()) return;
    setState(() {
      busy = true;
      notice = null;
    });
    try {
      await widget.api
          .request('POST', register ? 'accounts/register' : 'accounts/login', {
        'email': email.text.trim(),
        'password': password.text,
      });
      if (!mounted) return;
      if (register) {
        setState(() => notice = 'Compte créé. Vous pouvez vous connecter.');
      } else {
        widget.onSuccess();
      }
    } on ApiException catch (error) {
      if (mounted) setState(() => notice = error.message);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Form(
                  key: form,
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
                      TextFormField(
                        controller: email,
                        enabled: !busy,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(labelText: 'E-mail'),
                        validator: (value) =>
                            RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                        .hasMatch(value!.trim()) &&
                                    value.trim().length <= 100
                                ? null
                                : 'Saisissez une adresse e-mail valide.',
                      ),
                      TextFormField(
                        controller: password,
                        enabled: !busy,
                        obscureText: true,
                        decoration:
                            const InputDecoration(labelText: 'Mot de passe'),
                        onFieldSubmitted: (_) => submit(register: false),
                        validator: (value) => value!.isEmpty
                            ? 'Saisissez votre mot de passe.'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      if (notice != null)
                        Semantics(liveRegion: true, child: Text(notice!)),
                      if (busy) const LinearProgressIndicator(),
                      FilledButton(
                        onPressed: busy ? null : () => submit(register: false),
                        child: const Text('Se connecter'),
                      ),
                      TextButton(
                        onPressed: busy ? null : () => submit(register: true),
                        child: const Text('Créer un compte'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
