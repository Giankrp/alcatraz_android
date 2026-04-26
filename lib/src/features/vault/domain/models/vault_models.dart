import 'dart:convert';

class VaultItem {
  final String? id;
  final String type;
  final String title;
  final String? folderId;
  final VaultSecret secret;
  final DecryptedVaultContent? decryptedContent;

  VaultItem({
    this.id,
    required this.type,
    required this.title,
    this.folderId,
    required this.secret,
    this.decryptedContent,
  });

  VaultItem copyWith({DecryptedVaultContent? decryptedContent}) {
    return VaultItem(
      id: id,
      type: type,
      title: title,
      folderId: folderId,
      secret: secret,
      decryptedContent: decryptedContent ?? this.decryptedContent,
    );
  }

  factory VaultItem.fromJson(Map<String, dynamic> json) {
    return VaultItem(
      id: json['id'],
      type: json['item_type'] ?? json['type'] ?? 'password',
      title: json['title'] ?? '',
      folderId: json['folder_id'],
      secret: VaultSecret.fromJson(json['secret'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'type': type,
      'title': title,
      if (folderId != null) 'folder_id': folderId,
      'secret': secret.toJson(),
    };
  }
}

class VaultSecret {
  final String data;
  final String iv;
  final String salt;

  VaultSecret({required this.data, required this.iv, required this.salt});

  factory VaultSecret.fromJson(Map<String, dynamic> json) {
    return VaultSecret(
      data: json['data'] ?? '',
      iv: json['iv'] ?? '',
      salt: json['salt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'data': data, 'iv': iv, 'salt': salt};
  }
}

/// The decrypted content of a vault item.
class DecryptedVaultContent {
  final String username;
  final String password;
  final String url;
  final String notes;

  DecryptedVaultContent({
    this.username = '',
    this.password = '',
    this.url = '',
    this.notes = '',
  });

  factory DecryptedVaultContent.fromJson(Map<String, dynamic> json) {
    return DecryptedVaultContent(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      url: json['url'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'url': url,
      'notes': notes,
    };
  }
}
