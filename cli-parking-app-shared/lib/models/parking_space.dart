import 'package:uuid/uuid.dart';
var uuid = Uuid();

//class for parking space
class ParkingSpace {
  final String id;
  String address;
  double pricePerHour;

  //constructor with optional id, if not supplied we create an uid
  ParkingSpace({String? id, required this.address, required this.pricePerHour}) : id = id ?? uuid.v1();

  //deserialize from json
  ParkingSpace.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      address = json["address"] as String,
      pricePerHour = json["pricePerHour"] as double;

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "address": address,
    "pricePerHour": pricePerHour
  };

  //return some predefined details
  String get printDetails => "$id $address ${pricePerHour.toStringAsFixed(2)}";

}