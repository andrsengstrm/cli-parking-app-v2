import 'package:cli_parking_app_server/models/person.dart';
import 'package:cli_parking_app_server/repositories/repository.dart';

class PersonRepository extends Repository<Person> {

  static final PersonRepository _instance = PersonRepository._internal();
  
  PersonRepository._internal();

  factory PersonRepository() => _instance;

  @override
  Future<void> add(Person item) async {
    //var personList = await items.length;
    item.id = items.length+1;
    items.add(item);
  }
  
  @override
  Future<Person> getById(id) async { 
    return items.where((p) => p.id == id).first;
  }

  @override
  Future<void> update(int id, Person updatedItem) async { 
    var personToUpdate = items.where((person) => person.id == id).first;
    var index = items.indexOf(personToUpdate);
    items[index] = updatedItem;
  }

  @override
  Future<void> delete(int id) async {
    var personToRemove = items.where((person) => person.id == id).first;
    items.remove(personToRemove);
  }

}
