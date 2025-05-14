// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UsersFromJson(Map<String, dynamic> json) => UserModel(
      email: json['email'] as String,
      name: json['name'] as String,
      age: json['age'] as String,
      notes: json['notes'] as String,
      role: $enumDecode(_$UserTypeEnumMap, json['role']),
      phone: json['phone'] as String,
    );

Map<String, dynamic> _$UsersToJson(UserModel instance) => <String, dynamic>{
      'email': instance.email,
      'name': instance.name,
      'age': instance.age,
      'notes': instance.notes,
      'role': _$UserTypeEnumMap[instance.role]!,
      'phone': instance.phone,
    };

const _$UserTypeEnumMap = {
  UserType.doctor: 'doctor',
  UserType.patient: 'patient',
};
