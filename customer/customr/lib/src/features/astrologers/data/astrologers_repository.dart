import 'astrologers_api.dart';
import 'models/astrologer.dart';

class AstrologersRepository {
  AstrologersRepository(this._api);

  final AstrologersApi _api;

  Future<AstrologerPage> list({
    AstrologerQuery query = const AstrologerQuery(),
    String? cursor,
  }) => _api.list(query: query, cursor: cursor);

  Future<Astrologer> detail(String id) => _api.detail(id);
}
