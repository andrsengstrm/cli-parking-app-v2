import 'package:uuid/uuid.dart';
var uuid = Uuid();

//class for owner of a vehicle
class Person {
  final String id;
  String personId;
  String name;

  //constructor with optional id, it not supplied we create a uid
  Person({String? id, required this.personId, required this.name }) : id = id ?? uuid.v1();

  //deserialize from json
  Person.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      personId = json["personId"] as String,
      name = json["name"] as String;

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "personId": personId,
    "name": name 
  };

  //return a string with some predefined details
  String get printDetails => "$id $name $personId";

}