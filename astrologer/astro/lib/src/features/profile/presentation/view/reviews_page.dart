import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../../../shared/widgets/empty_state.dart';
import '../../data/profile_api.dart';

class ReviewsPage extends StatefulWidget {
  const ReviewsPage({super.key});
  @override
  State<ReviewsPage> createState() => _ReviewsPageState();
}

class _ReviewsPageState extends State<ReviewsPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = getIt<ProfileApi>().reviews();
  }

  Future<void> _reply(String id) async {
    final controller = TextEditingController();
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reply'),
        content: TextField(controller: controller, maxLines: 3),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Send')),
        ],
      ),
    );
    if (text == null || text.isEmpty) return;
    await getIt<ProfileApi>().replyToReview(id, text);
    if (mounted) {
      setState(() => _future = getIt<ProfileApi>().reviews());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reviews')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final rows = snap.data ?? const [];
          if (rows.isEmpty) {
            return const EmptyState(
                icon: Icons.reviews_outlined, title: 'No reviews yet');
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: rows.length,
            separatorBuilder: (_, _) => const Divider(),
            itemBuilder: (context, i) {
              final r = rows[i];
              final reply = '${r['astrologer_reply'] ?? ''}';
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    for (var s = 0; s < 5; s++)
                      Icon(
                        s < ((r['rating'] as num?)?.toInt() ?? 0)
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 16,
                      ),
                    const Spacer(),
                    Text('${r['status']}',
                        style: Theme.of(context).textTheme.labelSmall),
                  ]),
                  if ('${r['text'] ?? ''}'.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text('${r['text']}'),
                  ],
                  if (reply.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text('You: $reply',
                        style: const TextStyle(fontStyle: FontStyle.italic)),
                  ] else
                    TextButton(
                      onPressed: () => _reply('${r['id'] ?? r['public_id']}'),
                      child: const Text('Reply'),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
