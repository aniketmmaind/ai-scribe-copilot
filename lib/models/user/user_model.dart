class UserModel {
  UserModel({
    required this.status,
    this.token,
    this.refreshToken,
    required this.message,
    this.user,
  });

  final bool? status;
  final String? token;
  final String? refreshToken;
  final String? message;
  final User? user;

  UserModel copyWith({
    bool? status,
    String? token,
    String? refreshToken,
    String? message,
    User? user,
  }) {
    return UserModel(
      status: status ?? this.status,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      message: message ?? this.message,
      user: user ?? this.user,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      status: json["status"],
      token: json["token"],
      refreshToken: json["refreshToken"],
      message: json["message"],
      user: json["user"] == null ? null : User.fromJson(json["user"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "token": token,
    "refreshToken": refreshToken,
    "message": message,
    "user": user?.toJson(),
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.bio,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? bio;

  User copyWith({String? id, String? name, String? email, String? bio}) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json['name'],
      email: json["email"],
      bio: json["bio"],
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "bio": bio,
  };
}
