import 'package:cli_parking_app_client/models/parking_space.dart';
import 'package:cli_parking_app_client/models/person.dart';
import 'package:cli_parking_app_client/models/vehicle.dart';
import 'package:cli_parking_app_client/repositories/parking_space_repository.dart';
import 'package:cli_parking_app_client/repositories/person_repsoitory.dart';
import 'package:cli_parking_app_client/repositories/vehicle_repository.dart';

//create some initial objects
void initData() {
  Person owner = Person(personId: "7211097550", name: "Anders");
  PersonRepository().add(owner);
  Vehicle vehicle = Vehicle(regId: "LUP767", vehicleType: VehicleType.bil, owner: owner);
  VehicleRepository().add(vehicle);
  ParkingSpace parkingSpace = ParkingSpace(address: "Paulusväg 13, Bålsta", pricePerHour: 29);
  ParkingSpaceRepository().add(parkingSpace);
}