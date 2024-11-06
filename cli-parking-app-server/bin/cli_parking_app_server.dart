import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:cli_parking_app_server/handlers/person_handler.dart' as person_handler;

// Configure routes.
final _routerPerson = Router()
  ..get('/', _rootHandler)
  ..post('/person', person_handler.addPerson)
  ..get('/person', person_handler.getAllPersons)
  ..get('/person/<id>', person_handler.getPersonById)
  ..put('/person/<id>', person_handler.updatePerson)
  ..delete('/person/<id>', person_handler.deletePerson);
  //..put('/person', person_handler.updatePerson);
  //..get('/echo/<message>', _echoHandler);

Response _rootHandler(Request req) {
  return Response.ok('Server for Parking-app v2 running...');
}

/*
Future<Response> _addPersonHandler(Request request) async {
  print("Getting a post request...");
  final person = await request.readAsString();
  print(person);
  return Response.ok("Ok");
}


Response _echoHandler(Request request) {
  final message = request.params['message'];
  return Response.ok('$message\n');
}
*/

void main(List<String> args) async {
  // Use any available host or container IP (usually `0.0.0.0`).
  final ip = InternetAddress.anyIPv4;

  // Configure a pipeline that logs requests.
  final handler =
      Pipeline().addMiddleware(logRequests()).addHandler(_routerPerson.call);

  // For running in containers, we respect the PORT environment variable.
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');
}
