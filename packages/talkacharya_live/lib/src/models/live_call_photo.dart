import 'package:equatable/equatable.dart';

/// A picture shared on a live call — between the caller and the host only.
///
/// The stream's public chat is text; a palm, a chart or a document goes here.
/// The stream channel only says "a new photo on call X"; the two of them fetch
/// it over the API (`GET .../calls/{id}/photos`).
class LiveCallPhoto extends Equatable {
  const LiveCallPhoto({
    required this.id,
    required this.imageUrl,
    this.fromHost = false,
    this.name = '',
    this.at,
  });

  final String id;

  /// May be a relative `/media/...` path — the app resolves it.
  final String imageUrl;
  final bool fromHost;
  final String name;
  final DateTime? at;

  factory LiveCallPhoto.fromJson(Map<String, dynamic> j) => LiveCallPhoto(
    id: '${j['id'] ?? ''}',
    imageUrl: '${j['image_url'] ?? ''}',
    fromHost: j['from_host'] == true,
    name: '${j['name'] ?? ''}',
    at: DateTime.tryParse('${j['created_at'] ?? ''}')?.toLocal(),
  );

  @override
  List<Object?> get props => [id, imageUrl];
}
