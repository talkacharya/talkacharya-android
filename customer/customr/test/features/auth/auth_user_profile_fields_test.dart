import 'package:customr/src/features/auth/data/models/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AuthUser reads gender and date of birth from /me', () {
    final u = AuthUser.fromJson({
      'id': 'u1',
      'phone': '+919000000001',
      'gender': 'female',
      'date_of_birth': '1999-10-15',
    });
    expect(u.gender, 'female');
    expect(u.dateOfBirth, '1999-10-15');
  });

  test('AuthUser defaults when the fields are absent (old cached user)', () {
    final u = AuthUser.fromJson({'id': 'u1', 'phone': '+919000000001'});
    expect(u.gender, 'undisclosed');
    expect(u.dateOfBirth, isNull);
  });
}
