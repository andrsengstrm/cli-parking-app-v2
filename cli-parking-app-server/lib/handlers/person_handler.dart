import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:cli_parking_app_shared/models/person.dart';
import 'package:cli_parking_app_server/repositories/person_repository.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> addPerson(Request request) async {
  print("Trying to add a person...");
  final requestBody = await request.readAsString();
  print(requestBody);
  final person = Person.fromJson(jsonDecode(requestBody));
  var addedPerson = await PersonRepository().add(person);
  return Response.ok(jsonEncode(addedPerson));
}

Future<Response> getAllPersons(Request request) async {
  print("Trying to get all persons...");
  var personList = await PersonRepository().getAll();
  return Response.ok(jsonEncode(personList));
}

Future<Response> getPersonById(Request request) async {
  final id = request.params['id']!;
  print("Trying to get person with id $id");
  var person = await PersonRepository().getById(int.parse(id));
  return Response.ok(jsonEncode(person));
}

Future<Response> updatePerson(Request request) async {
  print("Trying to update a person...");
  final id = request.params['id']!;
  final requestBody = await request.readAsString();
  final person = Person.fromJson(jsonDecode(requestBody));
  var updatedPerson = await PersonRepository().update(int.parse(id), person);
  return Response.ok(jsonEncode(updatedPerson));
}

Future<Response> deletePerson(Request request) async {
  print("Trying to delete a person...");
  final id = request.params['id']!;
  var deletedPerson = await PersonRepository().delete(int.parse(id));
  return Response.ok(jsonEncode(deletedPerson));
}

/*
Future<Response> updatePerson(Request request) async {
  print("Trying to update person...");
  final personAsString = await request.readAsString();
  final personAsJson = jsonDecode(personAsString);
  final person = Person.fromJson(personAsJson);
  await PersonRepository().update(item, newItem)
}
*/