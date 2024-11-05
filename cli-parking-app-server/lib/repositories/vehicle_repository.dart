import 'package:cli_parking_app_server/models/vehicle.dart';
import 'package:cli_parking_app_server/repositories/repository.dart';

class VehicleRepository extends Repository<Vehicle> {

  static final VehicleRepository _instance = VehicleRepository._internal();
  
  VehicleRepository._internal();

  factory VehicleRepository() => _instance;

  Future<Vehicle> getVehicleById(id) async { 
    var vehicleList = await VehicleRepository().getAll();
    return vehicleList.where((v) => v.id == id).first;
  }

}