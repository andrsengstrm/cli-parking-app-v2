import 'package:cli_parking_app_shared/objectbox.g.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:cli_parking_app_server/handlers/person_handler.dart' as person_handler;

class ServerConfig {

  ServerConfig._privateConstructor() {
    initialize();
  }

  static final ServerConfig _instance = ServerConfig._privateConstructor();

  static ServerConfig get instance => _instance;

  late Store store;

  late Router router;

  Router initialize() {

    router = Router();

    store = openStore();
    
    //person routes
    router.post('/person', person_handler.addPerson);
    router.get('/person', person_handler.getAllPersons);
    router.get('/person/<id>', person_handler.getPersonById);
    router.put('/person/<id>', person_handler.updatePerson);
    router.delete('/person/<id>', person_handler.deletePerson);

    return router;

  }

}