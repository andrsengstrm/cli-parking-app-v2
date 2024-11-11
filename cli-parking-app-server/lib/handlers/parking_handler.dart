import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:cli_parking_app_shared/models/parking.dart';
import 'package:cli_parking_app_server/repositories/parking_repository.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> addParking(Request request) async {

  print("Trying to start a parking...");

  final requestBody = await request.readAsString();
  print(requestBody);
  final parking = Parking.fromJson(jsonDecode(requestBody));
  final addedParking = await ParkingRepository().add(parking);

  return Response.ok(jsonEncode(addedParking));

}

Future<Response> getAllParkings(Request request) async {

  print("Trying to get all parkings...");
  
  final parkingList = await ParkingRepository().getAll();
  
  return Response.ok(jsonEncode(parkingList));

}

Future<Response> getParkingById(Request request) async {
  
  print("Trying to get parking...");
  
  final id = request.params['id']!;
  final parking = await ParkingRepository().getById(int.parse(id));
  
  return Response.ok(jsonEncode(parking));

}

Future<Response> updateParking(Request request) async {
  
  print("Trying to update a parking...");
  
  final id = request.params['id']!;
  final requestBody = await request.readAsString();
  final parking = Parking.fromJson(jsonDecode(requestBody));
  final updatedParking = await ParkingRepository().update(int.parse(id), parking);
  
  return Response.ok(jsonEncode(updatedParking));

}

Future<Response> deleteParking(Request request) async {
  
  print("Trying to delete a parking...");
  
  final id = request.params['id']!;
  final deletedParking = await ParkingRepository().delete(int.parse(id));
  
  return Response.ok(jsonEncode(deletedParking));

}
