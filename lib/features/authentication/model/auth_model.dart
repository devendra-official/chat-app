class AuthModel {
  late String token;
  late String name;
  late String username;
  late String email;
  late String phone;
  late String profile;

  AuthModel({
    required this.email,
    required this.name,
    required this.phone,
    required this.profile,
    required this.token,
    required this.username,
  });

  AuthModel.fromJson(Map<String, dynamic> json) {
    token = json["token"];
    name = json["name"];
    username = json["username"];
    email = json["email"];
    phone = json["phone"];
    profile = json["profile"];
  }
}