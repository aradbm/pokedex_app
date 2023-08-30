import 'dart:convert';

class Pokemon {
  int id;
  String name;
  String img;
  String type;
  int weight;

  Pokemon({
    required this.id,
    required this.name,
    required this.img,
    required this.type,
    required this.weight,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      type: json['type'],
      weight: json['weight'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'img': img,
      'type': type,
      'weight': weight,
    };
  }

  // to string for shared preferences
  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
