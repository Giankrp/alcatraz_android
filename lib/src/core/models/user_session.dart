class UserSession {
  final String email;
  final String masterKey; // The decrypted Master Key
  final String? token;

  UserSession({required this.email, required this.masterKey, this.token});
}
