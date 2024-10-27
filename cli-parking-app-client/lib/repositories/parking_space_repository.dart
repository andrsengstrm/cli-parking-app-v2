import 'package:cli/models/parking_space.dart';
import 'package:cli/repositories/repository.dart';

class ParkingSpaceRepository extends Repository<ParkingSpace> {

  static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();

  ParkingSpaceRepository._internal();

  factory ParkingSpaceRepository() => _instance;

  Future<ParkingSpace> getParkingSpaceById(id) async { 
    var parkingSpaceList  = await ParkingSpaceRepository().getAll();
    return parkingSpaceList.where((p) => p.id == id).first;
  }


}