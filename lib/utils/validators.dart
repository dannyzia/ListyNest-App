class Validators {
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email address.';
    }
    if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)) {
      return 'Please enter a valid email address.';
    }
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password.';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    return null;
  }

    static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a name.';
    }
    return null;
  }
}
