import 'package:cli_parking_app_shared/models/parking_space.dart';
import 'package:cli_parking_app_shared/repositories/repository_local.dart';

class ParkingSpaceRepository extends RepositoryLocal<ParkingSpace> {

  static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();

  ParkingSpaceRepository._internal();

  factory ParkingSpaceRepository() => _instance;

  Future<ParkingSpace> getParkingSpaceById(id) async { 
    var parkingSpaceList  = await ParkingSpaceRepository().getAll();
    return parkingSpaceList.where((p) => p.id == id).first;
  }


}