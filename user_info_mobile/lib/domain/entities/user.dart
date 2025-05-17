class User {
  final int id;
  final String name;
  final String email;
  final String? profilePhotoUrl;
  final String? bio;
  final String? phone;
  final String? address;
  final List<String>? hobbies;
  final List<String>? favoriteFoods;
  final int? height;
  final int? weight;
  final double? bmi;
  final String? birthdate;
  final String? occupation;
  final List<String>? socialMediaLinks;
  final String? website;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
    this.profilePhotoUrl,
    this.bio,
    this.phone,
    this.address,
    this.hobbies,
    this.favoriteFoods,
    this.height,
    this.weight,
    this.bmi,
    this.birthdate,
    this.occupation,
    this.socialMediaLinks,
    this.website,
  });
}
