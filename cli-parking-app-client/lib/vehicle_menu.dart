import 'dart:io';
import 'package:cli_parking_app_client/main_menu.dart' as main_menu;
import 'package:cli_parking_app_client/person_menu.dart' as person_menu;
import 'package:cli_parking_app_shared/models/vehicle.dart';
import 'package:cli_parking_app_shared/models/person.dart';
import 'package:cli_parking_app_client/repositories/person_repository.dart';
import 'package:cli_parking_app_client/repositories/vehicle_repository.dart';

void showMenu() {
  
  //show the submenu for 'Personer'
  print("\nMeny för fordon, välj ett alternativ:"); 
  print("1. Registrera nytt fordon");
  print("2. Visa fordon");
  print("3. Visa alla fordon");
  print("4. Uppdatera fordon");
  print("5. Ta bort fordon");
  print("6. Gå tillbaka till huvudmenyn");
  stdout.write("\nVälj ett alternativ (1-6): ");

  //read the selected option
  readMenuSelection();

}

void readMenuSelection() {
  
  //wait for input and read the selection option
  String optionSelected = stdin.readLineSync()!;

  //select action based on the selected option
  if(optionSelected == "1") { 
    
    //add vehicle
    addVehicle();
  
  } else if(optionSelected == "2") { 
    
    //list vehicle
    getVehicle();
  
  } else if(optionSelected == "3") { 
    
    //list all vehicles
    getAllVehicles();
  
  } else if(optionSelected == "4") { 
    
    //update vehicle
    updateVehicle();
  
  } else if(optionSelected == "5") { 
    
    //delete vehicle
    deleteVehicle();
  
  } else if(optionSelected == "6") { 
    
    //go back to main menu
    main_menu.showMenu();
  
  } else { 
    
    //unsupported selection
    stdout.write("\nOgiligt val! Välj ett alternativ (1-6): ");

    readMenuSelection();
  
  }
  
}

void addVehicle() async {

  //ask for the regId. If no regId is provided, we repeat the process
  String regId = await setRegId();
  
  //ask for vehicletype, list the vehicletypes-enum with an index so the user can select
  var vehicleTypeId = await setVehicleTypeId();

  //print all persons so the user can select the owner the person-index
  var ownerId = await setOwnerId();

  try {

    //construct a Person and add Person with function from the repo
    var vehicle = Vehicle(regId: regId, vehicleTypeId: vehicleTypeId, ownerId: ownerId);
    var newVehicle = await VehicleRepository().add(vehicle);

    print("\nFordonet med regstreringsnummer ${newVehicle!.regId} har lagts till.");

  } catch(err) {

    print("\nEtt fel har uppstått: $err");

  }
  
  showMenu();

}

void getVehicle() async {

  stdout.write("\nAnge index på det fordon du vill visa (tryck enter för att avbryta): ");
  String selection = stdin.readLineSync()!;

  if(selection == "") {
    showMenu();
    return;
  }

  var id = int.parse(selection);

  try {
    //get the vehicle by its id
    var vehicle = await VehicleRepository().getById(id);
    print("\nId Regnr Fordonstyp Ägare");
    print("-------------------------------");
    print(vehicle!.printDetails);
    print("-------------------------------");


    showMenu();

  } on StateError { //no one was found, lets try again

    print("\nDet finns inget fordon med id $id");
    getVehicle();

  } on RangeError { //outside the index, lets try again

    print("\nDet finns inget fordon med id $id");
    getVehicle();

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");
    getVehicle();

  }
  
}

void getAllVehicles() async {

  //get all persons from the repo
  var vehicleList = await VehicleRepository().getAll();

  if(vehicleList!.isEmpty) {
    
    print("\nDet finns inga fordon registrerade");
  
  } else {
    
    printVehicleList(vehicleList);

  }

  showMenu();

}

void updateVehicle() async {

  //get all vehicle, if empty we return to the menu
  var vehicleList = await VehicleRepository().getAll();

  if(vehicleList!.isEmpty) {

    print("\nDet finns inga fordon registrerade");
    showMenu();
  }

  stdout.write("\nAnge index på det fordon du vill uppdatera (tryck enter för att avbryta): ");
  String selection = stdin.readLineSync()!;

  if(selection == "") {

    print("\nDet finns inga fordon registrerade");
    showMenu();

  }

  var id = int.parse(selection);

  try {
    //ask for the regId. If no regId is provided, we repeat the process
    String regId = await setRegId("\nVilket registreringsnummer har fordonet? ");
    
    //ask for vehicletype, list the vehicletypes-enum with an index so the user can select
    int vehicleTypeId = await setVehicleTypeId("\nVilken typ av fordon är det? ");

    //print all persons so the user can select the owner the person-index
    var ownerId = await setOwnerId("\nVem är ägaren av fordonet? ");

    //object for updated vehicle
    var vehicle = Vehicle(id: id, regId: regId, vehicleTypeId: vehicleTypeId, ownerId: ownerId );

    //update the vehicle
    var updatedVehicle = await VehicleRepository().update(id, vehicle);
    print("\nFordonet ${updatedVehicle!.regId} har uppdaterats");

  } on StateError { //no one was found, lets try again

    print("\nDet finns inget fordon med id $id");
    updateVehicle();

  } on RangeError { //outside the index, lets try again

    print("\nDet finns inget fordon med id $id");
    updateVehicle();

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}

void deleteVehicle() async {

  //get all vehicle, if empty we return to the menu
  var vehicleList = await VehicleRepository().getAll();

  if(vehicleList!.isEmpty) {

    print("\nDet finns inga fordon registrerade");
    showMenu();
  }

  stdout.write("\nAnge index på det fordon som du vill ta bort (tryck enter för att avbryta): ");
  String selection = stdin.readLineSync()!;

  if(selection == "") { //no value provided
    showMenu();
  }

  var id = int.parse(selection);

  try {

    //delete the vehicle
    var deletedVehicle = await VehicleRepository().delete(id);
    print("\nFordonet med registreringsnummer ${deletedVehicle!.regId} har tagits bort");

  } on StateError { //no one was found, lets try again

    print("\nDet finns inget fordon med id $id");
    deleteVehicle();

  } on RangeError { //outside the index, lets try again

    print("\nDet finns inget forodn med id $id");
    deleteVehicle();

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}


/*------------ subfunctions ------------------*/

//subfunction to set regId
Future<String> setRegId([String message = "\nVilket registreringsnummer har fordonet? "]) async {

  String regId;
  do {
    stdout.write(message);
    regId = stdin.readLineSync()!;
  } while(regId.isEmpty);

  return regId;

}

//subfunction to set the vehicletype
Future<int> setVehicleTypeId([String message = "\nVilken typ av fordon är det?"]) async {

  print(message);

  //loop thru the vehicletypes and print them with an index
  var vehicleTypes = ["0 - Bil", "1 - Lastbil", "2 - MC", "3 - Annat fordon"];
  String typeSelection = "";
  for(var type in vehicleTypes) {
    typeSelection += "$type, ";
  }
  print(typeSelection);

  //ask user to select index and make sure we get an index within the range for the enum
  String inputVehicleIndex;
  do {
    stdout.write("\nVälj fordonstyp: ");
    inputVehicleIndex = stdin.readLineSync()!;
  } while(inputVehicleIndex.isEmpty || int.tryParse(inputVehicleIndex) == null || int.tryParse(inputVehicleIndex)! >= vehicleTypes.length); 
  
  var id = int.parse(inputVehicleIndex);

  return id;

}

//subfunction to set the ownerperson
Future<int> setOwnerId([String message = "\nVem är ägaren av fordonet?"]) async {

  print(message);

  //list all persons using a function from the person-menu
  var personList = await PersonRepository().getAll();
  person_menu.printPersonList(personList);
  print("");
  
  //ask the user to select index and make sure we get an index within the range for the persons registrered
  String selection;
  do {
    stdout.write("Välj personens id: ");
    selection = stdin.readLineSync()!;
  } while(selection.isEmpty || int.tryParse(selection) == null || int.tryParse(selection)! >= (await PersonRepository().getAll()).length);
  
  var id = int.parse(selection);
  return id;

}

//print a list of vehicles
void printVehicleList(List<Vehicle> vehicleList) {

    print("\nIndex Id Regnr Fordonstyp Ägare");
    print("-------------------------------");
    for(var vehicle in vehicleList) {
      print("${vehicleList.indexOf(vehicle)} ${vehicle.printDetails}");
    }
    print("-------------------------------");

  }