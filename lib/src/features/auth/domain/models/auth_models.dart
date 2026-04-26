class LoginResponse {
  final bool require2fa;
  final String? token;
  final String? tempToken;
  final String? protectedMasterKey;
  final String? masterKeyIv;
  final String? masterKeySalt;

  LoginResponse({
    required this.require2fa,
    this.token,
    this.tempToken,
    this.protectedMasterKey,
    this.masterKeyIv,
    this.masterKeySalt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      require2fa: json['require_2fa'] ?? false,
      token: json['token'],
      tempToken: json['temp_token'],
      protectedMasterKey: json['protected_master_key'],
      masterKeyIv: json['master_key_iv'],
      masterKeySalt: json['master_key_salt'],
    );
  }
}

class RegisterRequest {
  final String email;
  final String password;
  final String protectedMasterKey;
  final String masterKeyIv;
  final String masterKeySalt;
  final String recoveryKey;
  final String recoveryProtectedMasterKey;
  final String recoveryKeyIv;
  final String recoveryKeySalt;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.protectedMasterKey,
    required this.masterKeyIv,
    required this.masterKeySalt,
    required this.recoveryKey,
    required this.recoveryProtectedMasterKey,
    required this.recoveryKeyIv,
    required this.recoveryKeySalt,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'protected_master_key': protectedMasterKey,
      'master_key_iv': masterKeyIv,
      'master_key_salt': masterKeySalt,
      'recovery_key': recoveryKey,
      'recovery_protected_master_key': recoveryProtectedMasterKey,
      'recovery_key_iv': recoveryKeyIv,
      'recovery_key_salt': recoveryKeySalt,
    };
  }
}
