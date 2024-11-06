import 'package:cli_parking_app_shared/models/parking_space.dart';
import 'package:cli_parking_app_shared/models/person.dart';
import 'package:cli_parking_app_shared/models/vehicle.dart';
import 'package:uuid/uuid.dart';
var uuid = Uuid();

//class for parking
class Parking {
  final String id;
  final Vehicle vehicle;
  final ParkingSpace parkingSpace;
  final DateTime startTime;
  DateTime? endTime;

  Parking({String? id, required this.vehicle, Person? owner, required this.parkingSpace, required this.startTime, this.endTime}) 
    : id = id ?? uuid.v1();

  //get some details for the parking and return a predefined string, including calculated cost
  String get printDetails => "$id ${vehicle.regId} ${parkingSpace.address} $startTime $endTime ${getCostForParking()}";

  //deserialize from json
  Parking.fromJson(Map<String, dynamic> json)
    : id = json["id"] as String,
      vehicle = json["vehicle"] as Vehicle,
      parkingSpace = json["parkingSpace"] as ParkingSpace,
      startTime = json["startTime"] as DateTime,
      endTime = json["endTime"] as DateTime;

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicle": vehicle.toJson(),
    "parkingSpace": parkingSpace.toJson(),
    "startTime": startTime,
    "endTime": endTime
  };

  //calculate the price for the parking
  String getCostForParking() {
    
    double cost = 0;
    
    //caclulate differnce in milliseconds from epoch. If parking is not finished we use now() to get the current cost
    int start = startTime.millisecondsSinceEpoch;
    int end = endTime?.millisecondsSinceEpoch ?? DateTime.now().millisecondsSinceEpoch;
    int total = end - start;

    //convert to hours and calculate the cost
    double totalHours = total / 3600000;
    cost =  totalHours * parkingSpace.pricePerHour;

    return cost.toStringAsFixed(2);

  }



}