import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:cli_parking_app_shared/models/vehicle.dart';
import 'package:cli_parking_app_server/repositories/vehicle_repository.dart';
import 'package:shelf_router/shelf_router.dart';

Future<Response> addVehicle(Request request) async {
  
  print("Trying to add a vehicle...");
  
  final requestBody = await request.readAsString();

  final vehicle = Vehicle.fromJson(jsonDecode(requestBody));
  final addedVehicle = await VehicleRepository().add(vehicle);
  
  return Response.ok(jsonEncode(addedVehicle));

}

Future<Response> getAllVehicles(Request request) async {
  
  print("Trying to get all vehicles...");
  
  var vehicleList = await VehicleRepository().getAll();
  
  return Response.ok(jsonEncode(vehicleList));

}

Future<Response> getVehicleById(Request request) async {
  
  print("Trying to get vehicle...");

  final id = request.params['id']!;
  final vehicle = await VehicleRepository().getById(int.parse(id));
  
  return Response.ok(jsonEncode(vehicle));

}

Future<Response> updateVehicle(Request request) async {
  
  print("Trying to update a vehicle...");
  
  final id = request.params['id']!;
  final requestBody = await request.readAsString();
  final vehicle = Vehicle.fromJson(jsonDecode(requestBody));
  final updatedVehicle = await VehicleRepository().update(int.parse(id), vehicle);
  
  return Response.ok(jsonEncode(updatedVehicle));

}

Future<Response> deleteVehicle(Request request) async {
  
  print("Trying to delete a vehicle...");
  
  final id = request.params['id']!;
  final deletedVehicle = await VehicleRepository().delete(int.parse(id));
  
  return Response.ok(jsonEncode(deletedVehicle));

}
