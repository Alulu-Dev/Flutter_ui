String? emailValidator(String email) {
  String pattern = r'^[a-z0-9]+[\._]?[a-z0-9]+[\._]?[a-z0-9]+[@]\w+[.]\w{2,3}$';
  RegExp regex = RegExp(pattern);
  if (email.isEmpty) {
    return 'Email can\'t be Empty!';
  }
  if (!regex.hasMatch(email)) {
    return 'Invalid Email Address!';
  } else {
    return null;
  }
}

String? passwordValidator(String password) {
  if (password.isEmpty) {
    return 'Password can\'t be Empty!';
  }
  return null;
}

String? passwordRegisterValidator(String password) {
  String _pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(_pattern);
  if (password.isEmpty) {
    return 'Password can\'t be Empty!';
  }
  if (password.isNotEmpty) {
    if (!regex.hasMatch(password)) {
      return 'Invalid Password!';
    } else {
      return null;
    }
  }
  return null;
}

String? rePasswordValidator(String password, String secondPassword) {
  if (password.isEmpty) {
    return 'Password can\'t be Empty!';
  }
  if (password != secondPassword) {
    return 'Passwords Must Match';
  }
  return null;
}

String? passwordEditValidator(String password) {
  String _pattern =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
  RegExp regex = RegExp(_pattern);
  if (password.isEmpty) {
    return null;
  }
  if (password.isNotEmpty) {
    if (!regex.hasMatch(password)) {
      return 'Invalid Password!';
    } else {
      return null;
    }
  }
  return null;
}

String? rePasswordEditValidator(String password, String secondPassword) {
  if (password.isEmpty) {
    return null;
  }
  if (password != secondPassword) {
    return 'Passwords Must Match';
  }
  return null;
}

String? nameValidator(String name) {
  final validCharacters = RegExp(r'^[a-zA-Z]+$');
  if (!validCharacters.hasMatch(name)) {
    return 'Invalid Name!';
  }
  return null;
}
