class UserModel {
  final int id;
  final String name;
  final String username;
  final RoleModel? role;
  final ClassModel? userClass;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.role,
    this.userClass,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      username: json['username'] ?? '',
      role: json['role'] != null ? RoleModel.fromJson(json['role']) : null,
      userClass:
          json['class'] != null ? ClassModel.fromJson(json['class']) : null,
    );
  }
}

class RoleModel {
  final int id;
  final String name;

  RoleModel({required this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class ClassModel {
  final int id;
  final String name;

  ClassModel({required this.id, required this.name});

  factory ClassModel.fromJson(Map<String, dynamic> json) {
    return ClassModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}