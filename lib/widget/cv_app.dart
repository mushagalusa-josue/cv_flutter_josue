import 'package:flutter/material.dart';

import '../api.dart';
import '../pages/connexion.dart';
import 'colors.dart';
import 'portfolio.dart';

class CvApp extends StatefulWidget {
  const CvApp({super.key, this.api = const Api()});
  final Api api;

  @override
  State<CvApp> createState() => _CvAppState();
}

class _CvAppState extends State<CvApp> {
  bool signedIn = false;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'CV de Josué',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: teal),
          scaffoldBackgroundColor: const Color(0xFFF7FAF8),
          useMaterial3: true,
        ),
        home: signedIn
            ? Portfolio(
                api: widget.api,
                onLogout: () => setState(() => signedIn = false))
            : SignIn(
                api: widget.api,
                onSuccess: () => setState(() => signedIn = true)),
      );
}
