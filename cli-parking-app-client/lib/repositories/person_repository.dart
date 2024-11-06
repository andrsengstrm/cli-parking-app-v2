import 'dart:convert';
import 'package:cli_parking_app_client/models/person.dart';
import 'package:cli_parking_app_client/repositories/repository_remote.dart';

class PersonRepository extends RepositoryRemote<Person> {

  static final PersonRepository _instance = PersonRepository._internal();
  
  PersonRepository._internal();

  factory PersonRepository() => _instance;

  @override
  Future<void> add(Person item) async {
    final body = item.toJson();
    final response = await client.post(
      Uri.parse("$baseUrl/person"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body)
    );
    print(response);
    if(response.statusCode != 200) {
      throw Exception("Could not add person");
    }
  }

  @override
  Future<List<Person>> getAll() async {
    final response = await client.get(
      Uri.parse('$baseUrl/person')
    );
    if(response.statusCode == 200) {
      final personListAsJson = jsonDecode(response.body);
      var personList = List<Person>.empty(growable: true);
      for(var i=0; i< personListAsJson.length;i++) {
        final person = Person.fromJson(personListAsJson[i]);
        personList.add(person);
      }
      return personList;
  
    } else {
      throw Exception("Could not get all persons");
    }

  }

  @override
  Future<Person> getByIndex(int index) async {
    final response = await client.get(
      Uri.parse('$baseUrl/person/$index')
    );
    if(response.statusCode == 200) {
      final personAsJson = jsonDecode(response.body);
      Person person = Person.fromJson(personAsJson);
      return person;
  
    } else {
      throw Exception("Could not get person with index $index");
    }
  }

  @override
  Future<Person> getById(int id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/person/$id')
    );
    if(response.statusCode == 200) {
      final personAsJson = jsonDecode(response.body);
      Person person = Person.fromJson(personAsJson);
      return person;
  
    } else {
      throw Exception("Could not get person with id $id");
    }
  }

  @override
  Future<void> update(Person item) async {
    final body = item.toJson();
    final response = await client.put(
      Uri.parse("$baseUrl/person/${item.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body)
    );
    if(response.statusCode != 200) {
      throw Exception("Could not update person");
    }
  }

  @override
  Future<void> delete(Person item) async {
    final response = await client.delete(
      Uri.parse("$baseUrl/person/${item.id}")
    );
    if(response.statusCode != 200) {
      throw Exception("Could not delete person");
    }
  }



}