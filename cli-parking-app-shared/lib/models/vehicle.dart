import 'package:objectbox/objectbox.dart';
import 'package:uuid/uuid.dart';
var uuid = Uuid();

//class for vehicle
@Entity()
class Vehicle {

  @Id()
  int id;
  String regId;
  int vehicleTypeId;
  int ownerId;

  //constructor with optional id, if not supplied a uid is created
  Vehicle({int? id, required this.regId, required this.vehicleTypeId, required this.ownerId }) : id = id ?? -1;

  //deserialize from json
  Vehicle.fromJson(Map<String,dynamic> json)
    : id = json["id"] as int,
      regId = json["regId"] as String,
      vehicleTypeId = json["vehicleType"] as int,
      ownerId = json["ownerId"] as int;


  //serialize to json, we add in owner as an object instead of only the ownerId
  Map<String, dynamic> toJson() => {
    "id": id,
    "regId": regId,
    "vehicleTypeId": vehicleTypeId,
    "ownerId": ownerId
  };

  //return a string with some predefined details
  String get printDetails => "$id $regId $vehicleTypeId $ownerId";

}

//enum for vehicle type
//enum VehicleType { 
//  bil, mc, lastbil, ospecificerad;
//}
 