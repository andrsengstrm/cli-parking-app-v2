import 'package:cli/models/vehicle.dart';
import 'package:cli/repositories/repository.dart';

class VehicleRepository extends Repository<Vehicle> {

  static final VehicleRepository _instance = VehicleRepository._internal();
  
  VehicleRepository._internal();

  factory VehicleRepository() => _instance;

  Vehicle getVehicleById(id) { 
    return VehicleRepository().getAll().where((v) => v.id == id).first;
  }

}