class UserModle {
  final String uid;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? about;

  UserModle({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.about,
  });

  factory UserModle.fromjson(Map<String, dynamic> map) {
    return UserModle(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      profileImageUrl: map['profileImageUrl'],
      about: map['about'],
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'about': about,
    };
  }

  UserModle copyWith({
    String? uid,
    String? name,
    String? email,
    String? profileImageUrl,
    String? about, 
  }) {
    return UserModle(
      uid: uid ?? this.uid, // إذا كانت القيمة فارغة، استخدم القيمة القديمة
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
       about: about ?? this.about, 
    );
  }
}
