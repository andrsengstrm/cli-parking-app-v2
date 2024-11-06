import 'package:cli_parking_app_server/models/parking.dart';
import 'package:cli_parking_app_server/repositories/repository.dart';

class ParkingRepository extends Repository<Parking> {

  static final ParkingRepository _instance = ParkingRepository._internal();

  ParkingRepository._internal();

  factory ParkingRepository() => _instance;

  Future<Parking> getParkingById(id) async { 
    var parkingList = await ParkingRepository().getAll();
    return parkingList.where((p) => p.id == id).first;
  }

}