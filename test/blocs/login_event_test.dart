import 'package:flutter_test/flutter_test.dart';
import 'package:urLife/bloc/login/login_bloc.dart';

void main() {
  const String _validEmail = "validemail@email.com";
  const String _validPassword = "validpwd";
  //const String _invalidEmail = "invalid"; //no @
  //const String _invalidPassword = "invalid"; //not 8+ chars

  group('LoginEvent', () {
    test('toString LoginEmailChanged', () {
      expect(
        LoginEmailChanged(email: _validEmail).toString(),
        'LoginEmailChanged { email: $_validEmail }'
      );
    });

    test('toString LoginPasswordChanged', () {
      expect(
        LoginPasswordChanged(password: _validPassword).toString(),
        'LoginPasswordChanged { password: $_validPassword }'
      );
    });

    test('toString LoginWithCredentialsPressed', () {
      expect(
        LoginWithCredentialsPressed(email: _validEmail, password: _validPassword).toString(),
        'LoginWithCredentialsPressed { email: $_validEmail, password: $_validPassword }'
      );
    });
  });
}