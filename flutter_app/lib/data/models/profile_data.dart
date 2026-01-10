class ProfileData {
  String name;
  String email;
  String phone;
  String address;
  String? profileImageUrl;
  ProfileData({
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    this.profileImageUrl,
  });
}
