import 'dart:convert';

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final String userId;
  final String userRole;
  final int updatedAt;

  AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.userRole,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
    'id': 1,
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'user_id': userId,
    'user_role': userRole,
    'updated_at': updatedAt,
  };

  factory AuthTokens.fromMap(Map<String, dynamic> map) => AuthTokens(
    accessToken: map['access_token'] as String? ?? '',
    refreshToken: map['refresh_token'] as String? ?? '',
    userId: map['user_id'] as String? ?? '',
    userRole: map['user_role'] as String? ?? '',
    updatedAt: (map['updated_at'] as int?) ?? 0,
  );
}

class LocalUserProfile {
  final String userId;
  final String fullName;
  final String role;
  final String? email;
  final String? phoneNumber;
  final String? address;
  final String? profileImageUrl;
  final int updatedAt;

  LocalUserProfile({
    required this.userId,
    required this.fullName,
    required this.role,
    required this.updatedAt,
    this.email,
    this.phoneNumber,
    this.address,
    this.profileImageUrl,
  });

  Map<String, dynamic> toMap() => {
    'user_id': userId,
    'full_name': fullName,
    'role': role,
    'email': email,
    'phone_number': phoneNumber,
    'address': address,
    'profile_image_url': profileImageUrl,
    'updated_at': updatedAt,
  };

  factory LocalUserProfile.fromMap(Map<String, dynamic> map) =>
      LocalUserProfile(
        userId: map['user_id'] as String? ?? '',
        fullName: map['full_name'] as String? ?? '',
        role: map['role'] as String? ?? '',
        email: map['email'] as String?,
        phoneNumber: map['phone_number'] as String?,
        address: map['address'] as String?,
        profileImageUrl: map['profile_image_url'] as String?,
        updatedAt: (map['updated_at'] as int?) ?? 0,
      );
}

class StaticItem {
  final String id;
  final String name;
  final String? parentId;

  StaticItem({required this.id, required this.name, this.parentId});

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'parent_id': parentId,
  };

  factory StaticItem.fromMap(Map<String, dynamic> map) => StaticItem(
    id: map['id'].toString(),
    name: map['name'] as String? ?? '',
    parentId: map['parent_id'] as String?,
  );
}

class CachedItem {
  final String id;
  final String? title;
  final String? status;
  final String? category;

  const CachedItem({required this.id, this.title, this.status, this.category});

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'status': status,
    'category': category,
  };

  factory CachedItem.fromJson(Map<String, dynamic> json) => CachedItem(
    id: json['id'] as String? ?? '',
    title: json['title'] as String?,
    status: json['status'] as String?,
    category: json['category'] as String?,
  );

  static String encodeList(List<CachedItem> items) =>
      jsonEncode(items.map((item) => item.toJson()).toList());

  static List<CachedItem> decodeList(String? data) {
    if (data == null || data.isEmpty) return const [];
    final List<dynamic> raw = jsonDecode(data) as List<dynamic>;
    return raw
        .map((e) => CachedItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
