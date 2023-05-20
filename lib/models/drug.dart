import 'dart:convert';

class Drug {
  int? id;
  String name;
  String strength;
  String? instructions;
  List<int>? imageIds;

  Drug(this.id, this.name, this.strength, this.imageIds, this.instructions);
  Drug.newDrug(this.name, this.strength, this.instructions);

  String get nameAndStrength => strength.isNotEmpty ? '$name - $strength' : name;

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'strength': strength, 'instructions': instructions?.replaceAll('"', '\\"')};
  }

  static Drug fromMap(Map<String, dynamic> map) {
    return Drug(
      map['id'],
      map['name'],
      map['strength'],
      (map['imageIds'] as List<dynamic>).map((imageId) => imageId as int).toList(),
      map['instructions']?.replaceAll('\\"', '"'),
    );
  }

  static List<Drug> fromMaps(List<Map<String, dynamic>> maps) {
    return List.generate(maps.length, (i) => Drug.fromMap(maps[i]));
  }

  static Drug fromJson(String json) => Drug.fromMap(jsonDecode(json));

  String toJson() => jsonEncode(toMap());

  static List<Drug> fromJsonList(String json) {
    final parsed = jsonDecode(json).cast<Map<String, dynamic>>();
    return parsed.map<Drug>((map) => Drug.fromMap(map)).toList();
  }
}
