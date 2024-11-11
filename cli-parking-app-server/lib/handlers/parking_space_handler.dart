import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:cli_parking_app_shared/models/parking_space.dart';
import 'package:cli_parking_app_server/repositories/parking_space_repository.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> addParkingSpace(Request request) async {

  print("Trying to add a parking space...");

  final requestBody = await request.readAsString();
  final parkingSpace = ParkingSpace.fromJson(jsonDecode(requestBody));
  final addedParkingSpace = await ParkingSpaceRepository().add(parkingSpace);

  return Response.ok(jsonEncode(addedParkingSpace));

}

Future<Response> getAllParkingSpaces(Request request) async {

  print("Trying to get all parking space...");

  final parkingSpaceList = await ParkingSpaceRepository().getAll();

  return Response.ok(jsonEncode(parkingSpaceList));

}

Future<Response> getParkingSpaceById(Request request) async {

  print("Trying to get parking space...");

  final id = request.params['id']!;
  
  final person = await ParkingSpaceRepository().getById(int.parse(id));

  return Response.ok(jsonEncode(person));

}

Future<Response> updateParkingSpace(Request request) async {

  print("Trying to update a parking space...");

  final id = request.params['id']!;
  final requestBody = await request.readAsString();
  final parkingSpace = ParkingSpace.fromJson(jsonDecode(requestBody));
  final updatedParkingSpace = await ParkingSpaceRepository().update(int.parse(id), parkingSpace);

  return Response.ok(jsonEncode(updatedParkingSpace));

}

Future<Response> deleteParkingSpace(Request request) async {

  print("Trying to delete a parking space...");

  final id = request.params['id']!;
  final deletedPerson = await ParkingSpaceRepository().delete(int.parse(id));

  return Response.ok(jsonEncode(deletedPerson));

}
