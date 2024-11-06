import 'package:cli_parking_app_shared/models/parking_space.dart';
import 'package:cli_parking_app_shared/models/person.dart';
import 'package:cli_parking_app_shared/models/vehicle.dart';
import 'package:cli_parking_app_shared/repositories/parking_space_repository.dart';
import 'package:cli_parking_app_client/repositories/person_repository.dart';
import 'package:cli_parking_app_shared/repositories/vehicle_repository.dart';

//create some initial objects
Future<void> initData() async {
  Person owner = Person(personId: "7211097550", name: "Anders");
  await PersonRepository().add(owner);
  
  /*
  Vehicle vehicle = Vehicle(regId: "LUP767", vehicleType: VehicleType.bil, owner: owner);
  VehicleRepository().add(vehicle);
  ParkingSpace parkingSpace = ParkingSpace(address: "Paulusväg 13, Bålsta", pricePerHour: 29);
  ParkingSpaceRepository().add(parkingSpace);
  */
}