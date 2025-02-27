class ChildInfo {
  final String age;
  final String gender;
  final String ethnicity;
  final String wasBornWithJaundice;
  final String hasFamilyWithAutism;
  final String completedBy;
  final String countryOfResidence;
  final String usedAppBefore;

  ChildInfo({
    required this.age,
    required this.gender,
    required this.ethnicity,
    required this.wasBornWithJaundice,
    required this.hasFamilyWithAutism,
    required this.completedBy,
    required this.countryOfResidence,
    required this.usedAppBefore,
  });
  factory ChildInfo.fromMap(Map<String, dynamic> map) {
    return ChildInfo(
      age: map['age'],
      gender: map['gender'],
      ethnicity: map['ethnicity'],
      wasBornWithJaundice: map['bornWithJaundice'],
      hasFamilyWithAutism: map['familyHistory'],
      completedBy: map['completedBy'],
      countryOfResidence: map['country'],
      usedAppBefore: map['usedAppBefore'],
    );
  }
}
