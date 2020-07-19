import 'package:flutter_test/flutter_test.dart';
import 'package:urLife/bloc/authentication/authentication_bloc.dart';

void main() {
  const String _name = "Jaiden";
  group('AuthenticationState', () {
    test('toString AuthenticationSuccess correct value', () {
      expect(
        AuthenticationSuccess(_name).toString(),
        'Authentication Success { displayName: $_name }'
      );
    });
  });
}