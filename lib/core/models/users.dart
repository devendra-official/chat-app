class UserModel {
  late List<Users> users;
  late String owner;

  UserModel({required this.users,required this.owner});

  UserModel.fromJson(List<dynamic> json,String email) {
    owner = email;
    users = json
        .map((item) => Users.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}

class Users {
  late String name;
  late String username;
  late String email;
  late String phone;
  late String profile;

  Users({
    required this.email,
    required this.name,
    required this.phone,
    required this.profile,
    required this.username,
  });

  Users.fromJson(Map<String, dynamic> json) {
    name = json["name"];
    username = json["username"];
    email = json["email"];
    phone = json["phone"];
    profile = json["profile"];
  }
}
