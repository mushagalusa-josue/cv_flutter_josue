import 'package:flutter/material.dart';

import '../api.dart';
import '../widget/shared_widgets.dart';

const familyPath = 'famille-membres';
const fields = {
  'nom': 'Nom',
  'postnom': 'Postnom',
  'prenom': 'Prénom',
  'lieu_naissance': 'Lieu de naissance',
  'date_naissance': 'Date de naissance (AAAA-MM-JJ)',
  'parente': 'Lien de parenté',
};

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key, required this.api});
  final Api api;

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  List<Map<String, dynamic>> members = [];
  bool busy = false;
  String? message;

  @override
  void initState() {
    super.initState();
    run(load);
  }

  Future<void> load() async {
    final data = await widget.api.request('GET', familyPath);
    if (data is! List || data.any((item) => item is! Map<String, dynamic>)) {
      throw const ApiException('La liste reçue est invalide.');
    }
    members = data.cast<Map<String, dynamic>>();
  }

  Future<void> run(Future<void> Function() action) async {
    if (busy) return;
    setState(() {
      busy = true;
      message = null;
    });
    try {
      await action();
    } on ApiException catch (error) {
      message = error.message;
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> edit([Map<String, dynamic>? member]) => run(() async {
        final saved = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (_) => MemberForm(api: widget.api, member: member),
        );
        if (saved == true && mounted) await load();
      });

  Future<void> view(Object? id) => run(() async {
        final data = await widget.api.request('GET', '$familyPath/$id');
        if (!mounted) return;
        if (data is! Map<String, dynamic>) {
          throw const ApiException('La fiche reçue est invalide.');
        }
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('${data['prenom']} ${data['nom']}'),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (data['image_url'] case final String url)
                    Image.network(url,
                        height: 120,
                        errorBuilder: (_, __, ___) => const Icon(Icons.person)),
                  for (final field in fields.entries)
                    Text('${field.value} · ${data[field.key]}'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Fermer'),
              ),
            ],
          ),
        );
      });

  Future<void> remove(Map<String, dynamic> member) => run(() async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Supprimer ce membre ?'),
            content: Text('${member['prenom']} ${member['nom']}'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Annuler'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Supprimer'),
              ),
            ],
          ),
        );
        if (confirmed != true || !mounted) return;
        await widget.api.request('DELETE', '$familyPath/${member['id']}');
        members.removeWhere((item) => item['id'] == member['id']);
        await load();
      });

  @override
  Widget build(BuildContext context) => PageContent(
        children: [
          const HeroPanel(
            icon: Icons.groups_outlined,
            title: 'Ma famille',
            subtitle: 'Membres de la famille',
          ),
          OverflowBar(
            spacing: 8,
            children: [
              FilledButton.icon(
                onPressed: busy ? null : () => edit(),
                icon: const Icon(Icons.person_add),
                label: const Text('Ajouter un membre'),
              ),
              TextButton.icon(
                onPressed: busy ? null : () => run(load),
                icon: const Icon(Icons.refresh),
                label: const Text('Actualiser'),
              ),
            ],
          ),
          if (busy) const LinearProgressIndicator(),
          if (message != null)
            Semantics(liveRegion: true, child: Text(message!)),
          if (!busy && message == null && members.isEmpty)
            const Text('Aucun membre enregistré.'),
          for (final member in members)
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: Text(
                    '${member['prenom']} ${member['nom']} ${member['postnom']}'),
                subtitle: Text('${member['parente']}'),
                onTap: busy ? null : () => view(member['id']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Modifier',
                      onPressed: busy ? null : () => edit(member),
                      icon: const Icon(Icons.edit_outlined),
                    ),
                    IconButton(
                      tooltip: 'Supprimer',
                      onPressed: busy ? null : () => remove(member),
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
}

class MemberForm extends StatefulWidget {
  const MemberForm({super.key, required this.api, this.member});
  final Api api;
  final Map<String, dynamic>? member;

  @override
  State<MemberForm> createState() => _MemberFormState();
}

class _MemberFormState extends State<MemberForm> {
  final form = GlobalKey<FormState>();
  final values = <String, String>{};
  bool busy = false;
  String? message;

  String? validate(String key, String value) {
    if (value.isEmpty) return 'Ce champ est obligatoire.';
    if (key == 'date_naissance') {
      final date = DateTime.tryParse(value);
      if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value) ||
          date == null ||
          date.toIso8601String().split('T').first != value ||
          date.isAfter(DateUtils.dateOnly(DateTime.now()))) {
        return 'Saisissez une date de naissance valide (AAAA-MM-JJ).';
      }
    }
    final max = key == 'lieu_naissance' ? 100 : 50;
    if (value.runes.length > max) return '$max caractères maximum.';
    return null;
  }

  Future<void> save() async {
    if (busy || !form.currentState!.validate()) return;
    form.currentState!.save();
    setState(() {
      busy = true;
      message = null;
    });
    final member = widget.member;
    try {
      await widget.api.request(
        member == null ? 'POST' : 'PUT',
        member == null ? familyPath : '$familyPath/${member['id']}',
        values,
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (mounted) {
        setState(() {
          message = error.message;
          busy = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: !busy,
        child: AlertDialog(
          title: Text(widget.member == null
              ? 'Ajouter un membre'
              : 'Modifier le membre'),
          content: SingleChildScrollView(
            child: Form(
              key: form,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final field in fields.entries)
                    TextFormField(
                      initialValue: widget.member?[field.key]?.toString(),
                      decoration: InputDecoration(labelText: field.value),
                      enabled: !busy,
                      validator: (value) => validate(field.key, value!.trim()),
                      onSaved: (value) => values[field.key] = value!.trim(),
                    ),
                  if (message != null)
                    Semantics(liveRegion: true, child: Text(message!)),
                  if (busy) const LinearProgressIndicator(),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: busy ? null : () => Navigator.pop(context),
              child: const Text('Annuler'),
            ),
            FilledButton(
              onPressed: busy ? null : save,
              child: const Text('Enregistrer'),
            ),
          ],
        ),
      );
}
