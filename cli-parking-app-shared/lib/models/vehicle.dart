import 'package:cli_parking_app_shared/models/person.dart';
import 'package:uuid/uuid.dart';
var uuid = Uuid();

//class for vehicle
class Vehicle {
  final String id;
  String regId;
  VehicleType vehicleType;
  Person owner;

  //constructor with optional id, if not supplied a uid is created
  Vehicle({String? id, required this.regId, required this.vehicleType, required this.owner }) : id = id ?? uuid.v1();

  //deserialize from json
  Vehicle.fromJson(Map<String,dynamic> json)
    : id = json["id"] as String,
      regId = json["regId"] as String,
      vehicleType = json["vehicleType"] as VehicleType,
      owner = Person.fromJson(json["owner"]);


  //serialize to json, we add in owner as an object instead of only the ownerId
  Map<String, dynamic> toJson() => {
    "id": id,
    "regId": regId,
    "vehicleType": vehicleType,
    "owner": owner.toJson()
  };

  //return a string with some predefined details
  String get printDetails => "$id $regId ${vehicleType.name.toUpperCase()} ${owner.name}";

}

//enum for vehicle type
enum VehicleType { 
  bil, mc, lastbil, ospecificerad;
}
 