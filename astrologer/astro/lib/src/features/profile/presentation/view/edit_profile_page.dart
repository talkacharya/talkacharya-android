import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/profile_api.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _headline = TextEditingController();
  final _bio = TextEditingController();
  final _years = TextEditingController();
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    getIt<ProfileApi>().profile().then((p) {
      if (!mounted) return;
      setState(() {
        _headline.text = p.headline;
        _bio.text = p.bio;
        _years.text = '${p.yearsExperience}';
        _loading = false;
      });
    }).catchError((Object _) {
      if (mounted) setState(() => _loading = false);
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await getIt<ProfileApi>().update(
        headline: _headline.text.trim(),
        bio: _bio.text.trim(),
        yearsExperience: int.tryParse(_years.text.trim()),
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Saved')));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(padding: const EdgeInsets.all(16), children: [
              TextField(
                controller: _headline,
                decoration: const InputDecoration(labelText: 'Headline'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _bio,
                maxLines: 5,
                decoration: const InputDecoration(labelText: 'About you'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _years,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(labelText: 'Years of experience'),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _saving ? null : _save,
                child: const Text('Save'),
              ),
            ]),
    );
  }
}
