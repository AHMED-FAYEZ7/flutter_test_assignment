class UserModel {
  final String email;
  final String password;
  String? confirmPassword;

  UserModel(
      {required this.email, required this.password, this.confirmPassword});
}
