import 'dart:convert';

class Patient {
  int? id;
  String firstName;
  String lastName;
  String? nickname;

  Patient(this.id, this.firstName, this.lastName, [this.nickname]);
  Patient.newPatient(this.firstName, this.lastName, [this.nickname]);

  String get preferredName => nickname ?? '$firstName $lastName';

  Map<String, dynamic> toMap() {
    return {'id': id, 'firstName': firstName, 'lastName': lastName, 'nickname': nickname};
  }

  static Patient fromMap(Map<String, dynamic> map) {
    return Patient(
      map['id'],
      map['firstName'],
      map['lastName'],
      map['nickname'],
    );
  }

  static List<Patient> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) => Patient.fromMap(maps[i]));
  }

  static Patient fromJson(String json) => Patient.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());

  static List<Patient> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<Patient>((map) => Patient.fromMap(map)).toList();
  }
}
