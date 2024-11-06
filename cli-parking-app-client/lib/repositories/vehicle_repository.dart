import 'package:cli_parking_app_shared/models/vehicle.dart';
import 'package:cli_parking_app_shared/repositories/repository_interface.dart';

class VehicleRepository implements RepositoryInterface<Vehicle> {
  @override
  Future<Vehicle?> add(Vehicle item) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Vehicle?> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Vehicle>?> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Vehicle?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Vehicle?> update(int id, Vehicle item) {
    // TODO: implement update
    throw UnimplementedError();
  }



}