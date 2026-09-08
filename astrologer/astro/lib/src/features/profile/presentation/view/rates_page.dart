import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/profile_api.dart';

class RatesPage extends StatefulWidget {
  const RatesPage({super.key});
  @override
  State<RatesPage> createState() => _RatesPageState();
}

class _RatesPageState extends State<RatesPage> {
  final _controllers = <String, TextEditingController>{};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    getIt<ProfileApi>().rates().then((rows) {
      if (!mounted) return;
      final byChannel = {for (final r in rows) r['channel'] as String: r};
      for (final ch in ['chat', 'voice', 'video']) {
        _controllers[ch] = TextEditingController(
          text: '${byChannel[ch]?['per_minute_amount'] ?? ''}',
        );
      }
      setState(() => _loading = false);
    }).catchError((Object _) {
      if (mounted) setState(() => _loading = false);
    });
  }

  Future<void> _save(String channel) async {
    try {
      await getIt<ProfileApi>()
          .setRate(channel, 'INR', _controllers[channel]!.text.trim());
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('$channel rate saved')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rates (₹/min)')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: ['chat', 'voice', 'video'].map((ch) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(children: [
                    Expanded(
                      child: TextField(
                        controller: _controllers[ch],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(labelText: ch),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FilledButton(
                        onPressed: () => _save(ch), child: const Text('Save')),
                  ]),
                );
              }).toList(),
            ),
    );
  }
}
