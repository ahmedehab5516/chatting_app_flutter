class User {
  final String username;
  final String uid;
  final String email;
  final String phoneNumber;
  final String? imageUrl;
  final int birthDay;
  final int birthMonth;
  final int birthYear;
  final String gender;
  final DateTime createdAt;
  final bool state;
  final bool isArchived;

  User({
    required this.username,
    required this.state,
    required this.createdAt,
    required this.email,
    required this.uid,
    required this.phoneNumber,
    this.imageUrl,
    required this.isArchived,
    required this.birthDay,
    required this.birthMonth,
    required this.birthYear,
    required this.gender,
  });

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'uid': uid,
      'state': state,
      'email': email,
      'isArchived' : isArchived,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'birthDay': birthDay,
      'birthMonth': birthMonth,
      'birthYear': birthYear,
      'gender': gender,
      'createdAt': createdAt,
    };
  }
}
