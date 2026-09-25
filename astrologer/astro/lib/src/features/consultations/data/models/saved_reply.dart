/// One of the astrologer's canned openers.
class SavedReply {
  const SavedReply({required this.id, required this.body, this.useCount = 0});

  final String id;
  final String body;
  final int useCount;

  factory SavedReply.fromJson(Map<String, dynamic> j) => SavedReply(
    id: j['id']?.toString() ?? '',
    body: j['body'] as String? ?? '',
    useCount: (j['use_count'] as num?)?.toInt() ?? 0,
  );
}
