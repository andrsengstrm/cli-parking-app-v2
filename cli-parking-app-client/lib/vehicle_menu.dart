import "dart:io";
import "package:cli/main_menu.dart" as main_menu;
import "package:cli/person_menu.dart" as person_menu;
import "package:cli/models/vehicle.dart";
import "package:cli/repositories/person_repsoitory.dart";
import "package:cli/repositories/vehicle_repository.dart";

import "models/person.dart";

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
  String regId = setRegId();
  
  //ask for vehicletype, list the vehicletypes-enum with an index so the user can select
  VehicleType vehicleType = setVehicleType();

  //print all persons so the user can select the owner the person-index
  var owner = await setOwner();

  try {

    //construct a Person and add Person with function from the repo
    var newVehicle = Vehicle(regId: regId, vehicleType: vehicleType, owner: owner);
    VehicleRepository().add(newVehicle);

    print("\nFordonet med regstreringsnummer ${newVehicle.regId} har lagts till.");

  } catch(err) {

    print("\nEtt fel har uppstått: $err");

  }
  
  showMenu();

}

void getVehicle() async {

  stdout.write("\nAnge index på det fordon du vill visa (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") {
    showMenu();
    return;
  }

  try {
    //get the vehicle by its id
    var vehicle = await VehicleRepository().getByIndex(int.parse(index));
    print("\nIndex Id Regnr Fordonstyp Ägare");
    print("-------------------------------");
    print("$index ${vehicle!.printDetails}");
    print("-------------------------------");


    showMenu();

  } on StateError { //no one was found, lets try again

    print("\nDet finns inget fordon med index $index");
    getVehicle();

  } on RangeError { //outside the index, lets try again

    print("\nDet finns inget fordon med index $index");
    getVehicle();

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");
    getVehicle();

  }
  
}

void getAllVehicles() async {

  //get all persons from the repo
  var vehicleList = await VehicleRepository().getAll();

  if(vehicleList.isEmpty) {
    
    print("\nDet finns inga fordon registrerade");
  
  } else {
    
    printVehicleList(vehicleList);

  }

  showMenu();

}

void updateVehicle() async {

  //get all vehicle, if empty we return to the menu
  var vehicleList = await VehicleRepository().getAll();

  if(vehicleList.isEmpty) {

    print("\nDet finns inga fordon registrerade");
    showMenu();
  }

  stdout.write("\nAnge index på det fordon du vill uppdatera (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") {

    print("\nDet finns inga fordon registrerade");
    showMenu();

  }

  try {

    //try to get the vehicle from the personrepository
    var vehicle = await VehicleRepository().getByIndex(int.parse(index));

    //ask for the regId. If no regId is provided, we repeat the process
    String regId = setRegId("\nVilket registreringsnummer har fordonet? [Nuvarande värde: ${vehicle!.regId}] ");
    
    //ask for vehicletype, list the vehicletypes-enum with an index so the user can select
    VehicleType vehicleType = setVehicleType("\nVilken typ av fordon är det? [Nuvarande fordonstyp: ${vehicle.vehicleType.name.toUpperCase()}] ");

    //print all persons so the user can select the owner the person-index
    var owner = await setOwner("\nVem är ägaren av fordonet? [Nuvarande ägare: ${vehicle.owner.name}] ");

    //object for updated vehicle
    var updatedVehicle = Vehicle(id: vehicle.id, regId: regId, vehicleType: vehicleType, owner: owner );

    //update the vehicle
    await VehicleRepository().update(vehicle, updatedVehicle);
    print("\nFordonet har uppdaterats");

  } on StateError { //no one was found, lets try again

    print("\nDet finns inget fordon med index $index");
    updateVehicle();

  } on RangeError { //outside the index, lets try again

    print("\nDet finns inget fordon med index $index");
    updateVehicle();

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}

void deleteVehicle() async {

  //get all vehicle, if empty we return to the menu
  var vehicleList = await VehicleRepository().getAll();

  if(vehicleList.isEmpty) {

    print("\nDet finns inga fordon registrerade");
    showMenu();
  }

  stdout.write("\nAnge index på det fordon som du vill ta bort (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") { //no value provided

    showMenu();

  }

  try {
    //try to get the person from the personrepository
    var vehicle = await VehicleRepository().getByIndex(int.parse(index));

    //delete the person
    await VehicleRepository().delete(vehicle!);
    print("\nFordonet med registreringsnummer ${vehicle.regId} har tagits bort");

  } on StateError { //no one was found, lets try again

    print("\nDet finns inget fordon med index $index");
    deleteVehicle();

  } on RangeError { //outside the index, lets try again

    print("\nDet finns inget forodn med index $index");
    deleteVehicle();

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}


/*------------ subfunctions ------------------*/

//subfunction to set regId
String setRegId([String message = "\nVilket registreringsnummer har fordonet? "]) {

  String regId;
  do {
    stdout.write(message);
    regId = stdin.readLineSync()!;
  } while(regId.isEmpty);

  return regId;

}

//subfunction to set the vehicletype
VehicleType setVehicleType([String message = "\nVilken typ av fordon är det?"]) {

  print(message);

  //loop thru the vehicletypes and print them with an index
  var vehicleTypes = VehicleType.values;
  String typeSelection = "";
  for(var type in vehicleTypes) {
    typeSelection += "${vehicleTypes.indexOf(type)} - ${type.name.toUpperCase()}, ";
  }
  print(typeSelection);

  //ask user to select index and make sure we get an index within the range for the enum
  String inputVehicleIndex;
  do {
    stdout.write("\nVälj fordonstyp: ");
    inputVehicleIndex = stdin.readLineSync()!;
  } while(inputVehicleIndex.isEmpty || int.tryParse(inputVehicleIndex) == null || int.tryParse(inputVehicleIndex)! >= vehicleTypes.length); 
  
  //select the enum-value by index and return it
  return VehicleType.values[int.parse(inputVehicleIndex)];

}

//subfunction to set the ownerperson
Future<Person> setOwner([String message = "\nVem är ägaren av fordonet?"]) async {

  print(message);

  //list all persons using a function from the person-menu
  var personList = await PersonRepository().getAll();
  person_menu.printPersonList(personList);
  print("");
  
  //ask the user to select index and make sure we get an index within the range for the persons registrered
  String inputOwnerIndex;
  do {
    stdout.write("Välj personens index: ");
    inputOwnerIndex = stdin.readLineSync()!;
  } while(inputOwnerIndex.isEmpty || int.tryParse(inputOwnerIndex) == null || int.tryParse(inputOwnerIndex)! >= (await PersonRepository().getAll()).length);
  
  //select the person by index and return it
  var person = await PersonRepository().getByIndex(int.parse(inputOwnerIndex));
  return person!;

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