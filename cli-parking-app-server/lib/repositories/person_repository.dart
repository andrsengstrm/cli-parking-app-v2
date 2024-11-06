import 'package:cli_parking_app_shared/models/person.dart';
import 'package:cli_parking_app_shared/repositories/repository_interface.dart';

class PersonRepository implements RepositoryInterface<Person> {

  static final PersonRepository _instance = PersonRepository._internal();
  
  PersonRepository._internal();

  factory PersonRepository() => _instance;

  final List<Person> _items = [];

  @override
  Future<Person> add(Person item) async {
    //var personList = await items.length;
    item.id = _items.length+1;
    _items.add(item);
    return item;
  }
  
  @override
  Future<List<Person>?> getAll() async {
    return _items;
  }

  @override
  Future<Person> getById(id) async { 
    return _items.where((p) => p.id == id).first;
  }

  @override
  Future<Person> update(int id, Person personToUpdate) async { 
    var personInList = _items.where((person) => person.id == id).first;
    var index = _items.indexOf(personInList);
    _items[index] = personToUpdate;
    return _items[index];
  }

  @override
  Future<Person> delete(int id) async {
    var personToRemove = _items.where((person) => person.id == id).first;
    _items.remove(personToRemove);
    return personToRemove;
  }

}