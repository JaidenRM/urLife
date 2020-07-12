class Validators {
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
  );

  static final RegExp _passwordRegExp = RegExp(
    r'^[A-Za-z\d]{8,}$',
  );

  static final RegExp _numRegExp = RegExp(
    r'^[0-9]*$',
  );

  static RegExp _alphaRegExp(int minLength, int maxLength) 
    => RegExp(
      r'^[a-zA-Z]{' + (minLength ?? 0).toString() + ',' + (maxLength ?? '').toString() + r'}$'
    );
    

  static isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }

  static isValidAlpha(String text, { int minLength, int maxLength }) {
    RegExp x = _alphaRegExp(minLength, maxLength);
    return x.hasMatch(text);
  }

  static isValidNum(String text, { int minValue, int maxValue }) {
    final int parsedText = int.tryParse(text);
    return 
      _numRegExp.hasMatch(text) &&
      (minValue == null || (parsedText != null && parsedText >= minValue)) &&
      (maxValue == null || (parsedText != null && parsedText <= maxValue));
  }
}