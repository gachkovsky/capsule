import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/capsule.dart';

class CapsulesRepository {
  final SupabaseClient _client;

  CapsulesRepository(this._client);

  Future<List<Capsule>> fetchCapsules() async {
    final data = await _client
        .from('capsules')
        .select()
        .order('created_at', ascending: false);
    return data.map((e) => Capsule.fromJson(e)).toList();
  }

  Future<void> createCapsule({
    required String message,
    required DateTime openAt,
  }) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('capsules').insert({
      'user_id': userId,
      'message': message,
      'open_at': openAt.toUtc().toIso8601String(),
    });
  }
}
