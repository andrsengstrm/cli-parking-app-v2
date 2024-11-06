import 'package:cli_parking_app_shared/models/parking.dart';
import 'package:cli_parking_app_shared/repositories/repository_interface.dart';

class ParkingRepository implements RepositoryInterface<Parking> {
  @override
  Future<Parking?> add(Parking item) {
    // TODO: implement add
    throw UnimplementedError();
  }

  @override
  Future<Parking?> delete(int id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<Parking>?> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<Parking?> getById(int id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<Parking?> update(int id, Parking item) {
    // TODO: implement update
    throw UnimplementedError();
  }



}