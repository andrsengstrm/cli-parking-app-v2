import 'package:cli_parking_app_client/models/parking.dart';
import 'package:cli_parking_app_client/repositories/repository_local.dart';

class ParkingRepository extends RepositoryLocal<Parking> {

  static final ParkingRepository _instance = ParkingRepository._internal();

  ParkingRepository._internal();

  factory ParkingRepository() => _instance;

  Future<Parking> getParkingById(id) async { 
    var parkingList = await ParkingRepository().getAll();
    return parkingList.where((p) => p.id == id).first;
  }

}