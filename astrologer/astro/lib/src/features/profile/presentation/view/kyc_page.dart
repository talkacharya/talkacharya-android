import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/di/service_locator.dart';
import '../../../onboarding/data/onboarding_api.dart';

class KycPage extends StatefulWidget {
  const KycPage({super.key});
  @override
  State<KycPage> createState() => _KycPageState();
}

class _KycPageState extends State<KycPage> {
  final _pan = TextEditingController();
  bool _busy = false;

  Future<void> _submitPan() async {
    setState(() => _busy = true);
    try {
      await getIt<OnboardingApi>()
          .uploadKyc(docType: 'pan', number: _pan.text.trim().toUpperCase());
      _toast('PAN submitted for re-verification');
    } catch (e) {
      _toast('$e');
    }
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _submitPhoto() async {
    final x = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxWidth: 1200);
    if (x == null) return;
    setState(() => _busy = true);
    final bytes = await x.readAsBytes();
    try {
      await getIt<OnboardingApi>().uploadKyc(
        docType: 'photo',
        file: (bytes: bytes, filename: x.name),
      );
      _toast('Photo submitted');
    } catch (e) {
      _toast('$e');
    }
    if (mounted) setState(() => _busy = false);
  }

  void _toast(String m) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('KYC & documents')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text(
          'Re-submit a document if it has expired or was flagged for '
          're-verification.',
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _pan,
          decoration: const InputDecoration(labelText: 'PAN number'),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: _busy ? null : _submitPan,
          child: const Text('Re-submit PAN'),
        ),
        const SizedBox(height: 20),
        OutlinedButton.icon(
          icon: const Icon(Icons.photo_camera_outlined),
          label: const Text('Re-upload photo'),
          onPressed: _busy ? null : _submitPhoto,
        ),
      ]),
    );
  }
}
