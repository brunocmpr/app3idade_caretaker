import 'dart:convert';

class AppUser {
  int? id;
  String firstName;
  String lastName;
  String email;
  String? rawPassword;
  AppUser(this.id, this.firstName, this.lastName, this.email);
  AppUser.newUser(this.firstName, this.lastName, this.email, this.rawPassword);

  Map<String, dynamic> toMap() {
    return {'id': id, 'firstName': firstName, 'lastName': lastName, 'email': email, 'rawPassword': rawPassword};
  }

  static AppUser fromMap(Map<String, dynamic> map) {
    return AppUser(
      map['id'],
      map['firstName'],
      map['lastName'],
      map['email'],
    );
  }

  static List<AppUser> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) {
      return AppUser.fromMap(maps[i]);
    });
  }

  static AppUser fromJson(String json) => AppUser.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());

  static List<AppUser> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<AppUser>((map) => AppUser.fromMap(map)).toList();
  }
}
