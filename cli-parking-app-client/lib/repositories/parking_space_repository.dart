import 'package:cli/models/parking_space.dart';
import 'package:cli/repositories/repository.dart';

class ParkingSpaceRepository extends Repository<ParkingSpace> {

  static final ParkingSpaceRepository _instance = ParkingSpaceRepository._internal();

  ParkingSpaceRepository._internal();

  factory ParkingSpaceRepository() => _instance;

  ParkingSpace getParkingSpaceById(id) { 
    return ParkingSpaceRepository().getAll().where((p) => p.id == id).first;
  }


}