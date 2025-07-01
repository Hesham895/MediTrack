import 'package:equatable/equatable.dart';

enum UserRole { patient, doctor, pharmacist }

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final UserRole role;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as String,
        name: json['name'] as String,
        email: json['email'] as String,
        role: UserRole.values.firstWhere(
          (e) => e.name == json['role'],
          orElse: () => UserRole.patient,
        ),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'role': role.name,
      };

  @override
  List<Object?> get props => [id, name, email, role];
}