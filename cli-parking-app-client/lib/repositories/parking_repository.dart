import 'package:cli/models/parking.dart';
import 'package:cli/repositories/repository.dart';

class ParkingRepository extends Repository<Parking> {

  static final ParkingRepository _instance = ParkingRepository._internal();

  ParkingRepository._internal();

  factory ParkingRepository() => _instance;

  Parking getParkingById(id) { 
    return ParkingRepository().getAll().where((p) => p.id == id).first;
  }

}