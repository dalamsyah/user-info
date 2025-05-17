import 'dart:convert';

import 'package:user_info_mobile/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.createdAt,
    required super.updatedAt,
    super.profilePhotoUrl,
    super.bio,
    super.phone,
    super.address,
    super.hobbies,
    super.favoriteFoods,
    super.height,
    super.weight,
    super.bmi,
    super.birthdate,
    super.occupation,
    super.socialMediaLinks,
    super.website,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profilePhotoUrl: json['profile_photo_url'],
      bio: json['bio'],
      phone: json['phone'],
      address: json['address'],
      hobbies:
          json['hobbies'] != null ? List<String>.from(json['hobbies']) : null,
      favoriteFoods:
          json['favorite_foods'] != null
              ? List<String>.from(json['favorite_foods'])
              : null,
      height: int.tryParse(json['height']?.toString() ?? ''),
      weight: int.tryParse(json['weight']?.toString() ?? ''),
      bmi: json['bmi'],
      birthdate: json['birthdate'],
      occupation: json['occupation'],
      socialMediaLinks:
          json['social_media_links'] != null
              ? List<String>.from(json['social_media_links'])
              : null,
      website: json['website'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'id': id,
      'name': name,
      'email': email,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };

    if (profilePhotoUrl != null) data['profile_photo_url'] = profilePhotoUrl;
    if (bio != null) data['bio'] = bio;
    if (phone != null) data['phone'] = phone;
    if (address != null) data['address'] = address;
    if (hobbies != null) data['hobbies'] = hobbies;
    if (favoriteFoods != null) data['favorite_foods'] = favoriteFoods;
    if (height != null) data['height'] = height;
    if (weight != null) data['weight'] = weight;
    if (bmi != null) data['bmi'] = bmi;
    if (birthdate != null) data['birthdate'] = birthdate;
    if (occupation != null) data['occupation'] = occupation;
    if (socialMediaLinks != null) data['social_media_links'] = socialMediaLinks;
    if (website != null) data['website'] = website;

    return data;
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? profilePhotoUrl,
    String? bio,
    String? phone,
    String? address,
    List<String>? hobbies,
    List<String>? favoriteFoods,
    int? height,
    int? weight,
    double? bmi,
    String? birthdate,
    String? occupation,
    List<String>? socialMediaLinks,
    String? website,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePhotoUrl: profilePhotoUrl ?? this.profilePhotoUrl,
      bio: bio ?? this.bio,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      hobbies: hobbies ?? this.hobbies,
      favoriteFoods: favoriteFoods ?? this.favoriteFoods,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bmi: bmi ?? this.bmi,
      birthdate: birthdate ?? this.birthdate,
      occupation: occupation ?? this.occupation,
      socialMediaLinks: socialMediaLinks ?? this.socialMediaLinks,
      website: website ?? this.website,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String toRawJson() => json.encode(toJson());
  factory UserModel.fromRawJson(String source) =>
      UserModel.fromJson(json.decode(source));
}
