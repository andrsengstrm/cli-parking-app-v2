import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cli_parking_app_shared/models/person.dart';
import 'package:cli_parking_app_shared/repositories/repository_interface.dart';

class PersonRepository implements RepositoryInterface<Person> {

  //static final PersonRepository _instance = PersonRepository._internal();
  
  //PersonRepository._internal();

  //factory PersonRepository() => _instance;

  
  var client = http.Client();
  final baseUrl = "http://localhost:8080";

  @override
  Future<Person> add(Person item) async {

    final body = item.toJson();

    final response = await client.post(
      Uri.parse("$baseUrl/person"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body)
    );
    
    if(response.statusCode == 200) {
    
      final personAsJson = jsonDecode(response.body);
      Person person = Person.fromJson(personAsJson);
      return person;
    
    } else {
    
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
  Future<Person> getById(int id) async {

    final response = await client.get(
      Uri.parse('$baseUrl/person/$id')
    );
    
    if(response.statusCode == 200) {
    
      final personAsJson = jsonDecode(response.body);
      Person person = Person.fromJson(personAsJson);
      return person;
    
    } else {
    
      throw Exception("Could not get person with index $id");
    
    }
  
  }

  @override
  Future<Person> update(int id, Person item) async {
  
    final body = item.toJson();

    final response = await client.put(
      Uri.parse("$baseUrl/person/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body)
    );
  
    if(response.statusCode == 200) {
  
      var personAsJson = jsonDecode(response.body);
      return Person.fromJson(personAsJson);
      
    } else {

      throw Exception("Could not update person");

    }
  
  }

  @override
  Future<Person> delete(int id) async {
  
    final response = await client.delete(
      Uri.parse("$baseUrl/person/$id")
    );
  
    if(response.statusCode == 200) {
  
      var personAsJson = jsonDecode(response.body);
      return Person.fromJson(personAsJson);
  
    } else {

      throw Exception("Could not delete person");

    }
  
  }



}