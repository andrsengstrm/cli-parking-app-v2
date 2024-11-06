import 'package:cli_parking_app_shared/models/vehicle.dart';
import 'package:cli_parking_app_shared/repositories/repository_local.dart';

class VehicleRepository extends RepositoryLocal<Vehicle> {

  static final VehicleRepository _instance = VehicleRepository._internal();
  
  VehicleRepository._internal();

  factory VehicleRepository() => _instance;

  Future<Vehicle> getVehicleById(id) async { 
    var vehicleList = await VehicleRepository().getAll();
    return vehicleList.where((v) => v.id == id).first;
  }

}