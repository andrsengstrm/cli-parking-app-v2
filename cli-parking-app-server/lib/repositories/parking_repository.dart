import 'package:cli_parking_app_server/server_config.dart';
import 'package:cli_parking_app_shared/models/parking.dart';
import 'package:cli_parking_app_shared/objectbox.g.dart';
import 'package:cli_parking_app_shared/repositories/repository_interface.dart';

class ParkingRepository implements RepositoryInterface<Parking> {

  Box itemBox = ServerConfig().store.box<Parking>();

  @override
  Future<Parking?> add(Parking item) async {
    itemBox.put(item, mode: PutMode.insert);
    return item;
  }

  @override
  Future<Parking?> getById(int id) async {
    return itemBox.get(id);
  } 

  @override
  Future<List<Parking>?> getAll() async {
    var itemList = itemBox.getAll().cast<Parking>();
    return itemList;
  }

  @override
  Future<Parking?> update(int id, Parking item) async {
    itemBox.put(item, mode: PutMode.update);
    return item;
  }

  @override
  Future<Parking?> delete(int id) async {
    var itemToDelete = itemBox.get(id);
    if(itemToDelete != null) {
      itemBox.remove(id);
    }
    return itemToDelete;
  }

}
