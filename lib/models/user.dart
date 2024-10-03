class User {
  final String firstName;
  final String lastName;

  User({required this.firstName, required this.lastName});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(firstName: json["firstName"], lastName: json["lastName"]);
  }
}