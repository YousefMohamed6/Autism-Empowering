import 'package:autism_empowering/core/enums/user_type.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String email;
  final String name;
  final String age;
  final String notes;
  final UserType role;
  final String phone;

  UserModel({
    required this.email,
    required this.name,
    required this.age,
    required this.notes,
    required this.role,
    required this.phone,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UsersFromJson(json);

  Map<String, dynamic> toJson() => _$UsersToJson(this);
}
