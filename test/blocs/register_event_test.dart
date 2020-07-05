import 'package:flutter_test/flutter_test.dart';
import 'package:urLife/bloc/register/register_bloc.dart';

void main() {
  const String _validEmail = "validemail@email.com";
  const String _validPassword = "validpwd";
  //const String _invalidEmail = "invalid"; //no @
  //const String _invalidPassword = "invalid"; //not 8+ chars

  group('RegisterEvent', () {
    test('toString RegisterEmailChanged', () {
      expect(
        RegisterEmailChanged(email: _validEmail).toString(),
        'RegisterEmailChanged { email: $_validEmail }'
      );
    });

    test('toString RegisterPasswordChanged', () {
      expect(
        RegisterPasswordChanged(password: _validPassword).toString(),
        'RegisterPasswordChanged { password: $_validPassword }'
      );
    });

    test('toString RegisterWithCredentialsPressed', () {
      expect(
        RegisterSubmitted(email: _validEmail, password: _validPassword).toString(),
        'RegisterSubmitted { email: $_validEmail, password: $_validPassword }'
      );
    });
  });
}