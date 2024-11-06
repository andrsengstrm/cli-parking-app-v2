//import 'package:cli_parking_app_shared/models/parking_space.dart';
//import 'package:cli_parking_app_shared/models/vehicle.dart';
import 'package:objectbox/objectbox.dart';

//class for parking
@Entity()
class Parking {

  @Id()
  int id;
  int vehicleId;
  int parkingSpaceId;
  @Property(type: PropertyType.dateNano)
  DateTime startTime;
  @Property(type: PropertyType.dateNano)
  DateTime? endTime;

  Parking({int? id, required this.vehicleId, required this.parkingSpaceId, required this.startTime, this.endTime}) 
    : id = id ?? -1;

  //get some details for the parking and return a predefined string, including calculated cost
  String get printDetails => "$id $vehicleId $parkingSpaceId $startTime $endTime ${getCostForParking()}";

  //deserialize from json
  Parking.fromJson(Map<String, dynamic> json)
    : id = json["id"] as int,
      vehicleId = json["vehicleId"] as int,
      parkingSpaceId = json["parkingSpaceId"] as int,
      startTime = json["startTime"] as DateTime,
      endTime = json["endTime"] as DateTime;

  //serialize to json
  Map<String, dynamic> toJson() => {
    "id": id,
    "vehicleId": vehicleId,
    "parkingSpaceId": parkingSpaceId,
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
    //cost =  totalHours * parkingSpace.pricePerHour;

    return cost.toStringAsFixed(2);

  }



}