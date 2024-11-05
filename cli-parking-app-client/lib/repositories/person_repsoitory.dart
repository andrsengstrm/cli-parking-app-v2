import 'package:cli_parking_app_client/models/person.dart';
import 'package:cli_parking_app_client/repositories/repository.dart';

class PersonRepository extends Repository<Person> {

  static final PersonRepository _instance = PersonRepository._internal();
  
  PersonRepository._internal();

  factory PersonRepository() => _instance;

  Future<Person> getPersonById(id) async { 
    var personList = await PersonRepository().getAll();
    return personList.where((p) => p.id == id).first;
  }

}