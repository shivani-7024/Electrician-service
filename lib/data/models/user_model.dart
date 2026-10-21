/// Model representing the authenticated customer profile
class UserProfile {
  final String id;
  final String name;
  final String phone;
  final String email;
  final List<String> addresses;
  final String defaultAddress;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.addresses,
    required this.defaultAddress,
  });

  UserProfile copyWith({
    String? name,
    String? phone,
    String? email,
    List<String>? addresses,
    String? defaultAddress,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      addresses: addresses ?? this.addresses,
      defaultAddress: defaultAddress ?? this.defaultAddress,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String? ?? '',
      addresses: List<String>.from(json['addresses'] as List? ?? []),
      defaultAddress: json['default_address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'addresses': addresses,
      'default_address': defaultAddress,
    };
  }
}
