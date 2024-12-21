extension EmailValidator on String {
  // Checks if the string is a valid email address
  bool isValidEmail() {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(this);
  }

  // Checks if the string is a valid password (at least 8 characters, with letters and numbers)
  bool isValidPassword() {
    return RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{8,}$').hasMatch(this);
  }
}
