import "dart:io";
import "package:cli/main_menu.dart" as main_menu;
import "package:cli/models/parking.dart";
import "package:cli/repositories/parking_repository.dart";
import "package:cli/models/vehicle.dart";
import "package:cli/vehicle_menu.dart" as vehicle_menu;
import "package:cli/repositories/vehicle_repository.dart";
import "package:cli/parking_space_menu.dart" as parking_space_menu;
import "package:cli/models/parking_space.dart";
import "package:cli/repositories/parking_space_repository.dart";

//show the menu for parkings
void showMenu() {
  
  //show the submenu for 'Personer'
  print("\nMeny för parkingar, välj ett alternativ:"); 
  print("1. Starta parkering");
  print("2. Avsluta parkering");
  print("3. Visa parkering");
  print("4. Visa alla parkeringar");
  print("5. Uppdatera parkering");
  print("6. Ta bort parkering");
  print("7. Gå tillbaka till huvudmenyn");
  stdout.write("\nVälj ett alternativ (1-7): ");

  //read the selected option
  readMenuSelection();

}

//read the menu selection and goto the function selected
void readMenuSelection() {
  
  //wait for input and read the selection option
  String optionSelected = stdin.readLineSync()!;

  //select action based on the selected option
  if(optionSelected == "1") { 
    
    //add parking
    startParking();
  
  } else if(optionSelected == "2") { 
    
    //end parking
    endParking();
  
  } else if(optionSelected == "3") { 
    
    //list all parkings
    getParking();
  
  } else if(optionSelected == "4") { 
    
    //list all parkings
    getAllParkings();
  
  } else if(optionSelected == "5") { 
    
    //update parkings
    updateParking();
  
  } else if(optionSelected == "6") { 
    
    //update parkings
    deleteParking();
  
  } else if(optionSelected == "7") { 

    //go back to main menu
    main_menu.showMenu();
  
  } else { 
    
    //unsupported selection
    stdout.write("\nOgiligt val! Välj ett alternativ (1-7): ");

    readMenuSelection();
  
  }
  
}

//function to start a new parking
void startParking() async {

  //set the vehicle
  var vehicle = await setVehicle();

  //set the parkingspace
  var parkingSpace = await setParkingSpace();

  //set the time to now
  DateTime startTime = DateTime.now();

  try {

    //set the parking-object
    Parking newParking = Parking(vehicle: vehicle, parkingSpace: parkingSpace, startTime: startTime);
    await ParkingRepository().add(newParking);

    print("\nParkeringen har startats.");

  } catch(err) {

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();


}

//function to end a parking
void endParking() async {

  //get all active parkings
  var parkingList = await ParkingRepository().getAll();

  if(parkingList.where((p) => p.endTime == null).isEmpty) {

    print("\nDet finns inga aktiva parkeringar");
    showMenu();

  }

  //print a list of parkings
  print("\nVlken parkering du vill avluta?");
  printParkingList(parkingList, true);

  stdout.write("\nVälj parkeringens index: ");
  var index = stdin.readLineSync()!;

  try {

    //get the parking by its id
    var parking = await ParkingRepository().getByIndex(int.parse(index));
    var newParking = parking!;
    newParking.endTime = DateTime.now();
    await ParkingRepository().update(parking, newParking);

    print("\nParkering har avslutats.");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med index $index");
    endParking();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen person med index $index");
    endParking();

  } catch(err) { 
    
    //some other error
    print("\nEtt fel har uppstått: $err"); 

  }

  showMenu();

}

//function to get a parking
void getParking() async {

  //get all parkings
  var parkingList = await ParkingRepository().getAll();

  if(parkingList.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");
    showMenu();
    return;

  }

  stdout.write("\nAnge index på den parkering du vill visa (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") {
    showMenu();
    return;
  }

  try {

    //get the parking by its index
    var parking = await ParkingRepository().getByIndex(int.parse(index));
    print("\nIndex Id Registraringsnr Adress Starttid Sluttid Kostnad");
    print("-------------------------------");
    print("$index ${parking!.printDetails}");
    print("-------------------------------");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med index $index");
    getParking();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkering med index $index");
    getParking();

  } catch(err) { 
    
    //some other error
    print("\nEtt fel har uppstått: $err"); 

  }

  showMenu();

}

//function to list all parkings
void getAllParkings() async {

  //get all parkings
  var parkingList = await ParkingRepository().getAll();

  if(parkingList.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");

  } else {

    printParkingList(parkingList);

  }

  showMenu();

}

//function to update a parking
void updateParking() async {

  //get all parkings, if empty we return to the menu
  var parkingList = await ParkingRepository().getAll();
  if(parkingList.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");
    showMenu();

  }

  stdout.write("\nAnge index på den parkering du vill uppdatera (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") { //no value provided
    showMenu();
  }

  try {
    
    //get the old parking by its id
    var parking = await ParkingRepository().getByIndex(int.parse(index));

    //update vehicleIs
    var vehicle = await setVehicle("\nVilket fordon är parkerat? [Nuvarande fordon: ${parking!.vehicle.regId}]");

    //update parkingspace
    ParkingSpace parkingSpace = await setParkingSpace("\nVilken parkeingsplats? [Nuvarande parkeringsplats: ${parking.parkingSpace.address}]");

    //set the starttime
    DateTime startTime = setTime("Uppdatera tidpunkt för starttid");

    //set the endtime
    DateTime endTime = setTime("Uppdatera tidpunkt för sluttid");

    //set the new parkingobject
    var newParking = Parking(vehicle: vehicle, parkingSpace: parkingSpace, startTime: startTime, endTime: endTime);

    await ParkingRepository().update(parking, newParking);

    print("\nParkeringen har uppdaterats");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med index $index");
    endParking();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen person med index $index");
    endParking();

  } catch(err) { 
    
    //some other error
    print("\nEtt fel har uppstått: $err"); 

  }

  showMenu();

}

//function to delete a parking
void deleteParking() async {

  //get all parkings, if empty we return to the menu
  var parkingList = await ParkingRepository().getAll();
  if(parkingList.isEmpty) {

    print("\nDet finns inga parkeringar registrerade");
    showMenu();

  }

  stdout.write("\nAnge index på den parkering du vill ta bort (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") { //no value provided
    showMenu();
  }

  try {

    //try to get the parking from the personrepository
    var parking = await ParkingRepository().getByIndex(int.parse(index));

    //delete the parking
    await ParkingRepository().delete(parking!);
    print("\nParkeringen har tagits bort");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkering med index $index");
    deleteParking();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkering med index $index");
    deleteParking();

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}



/*---------------- subfunctions ----------------*/

//set the vehicle
Future<Vehicle> setVehicle([String message = "\nVilket fordon vill du parkera?"]) async {

  print(message);

  //list all vehicles
  var vehicleList = await VehicleRepository().getAll();
  vehicle_menu.printVehicleList(vehicleList);

  //ask for index
  String inputVehicleIndex;
  do {
    stdout.write("Välj fordonets index: ");
    inputVehicleIndex = stdin.readLineSync()!;
  } while(inputVehicleIndex.isEmpty || int.tryParse(inputVehicleIndex) == null || int.tryParse(inputVehicleIndex)! >= vehicleList.length);

  //select the item by index and return it
  var vehicle = await VehicleRepository().getByIndex(int.parse(inputVehicleIndex));
  return vehicle!;

}

//set the parkingspace
Future<ParkingSpace> setParkingSpace([String message = "\nVilken perkeringsplats vill du använda?"]) async {

  print(message);

  //list all parkingspaces
  var parkingSpaceList = await ParkingSpaceRepository().getAll();
  parking_space_menu.printParkingSpaceList(parkingSpaceList);

  //ask for index
  String inputParkingSpaceIndex;
  do {
    stdout.write("Välj parkeringsplatsens index: ");
    inputParkingSpaceIndex = stdin.readLineSync()!;
  } while(inputParkingSpaceIndex.isEmpty || int.tryParse(inputParkingSpaceIndex) == null || int.tryParse(inputParkingSpaceIndex)! >= parkingSpaceList.length);

  //select the item by index and return it
  var parkingSpace = await ParkingSpaceRepository().getByIndex(int.parse(inputParkingSpaceIndex));
  return parkingSpace!;

}

//set a manual time
DateTime setTime([String message = "Välj tidpunkt"]) {

  print(message);

  String input;
  do {
    stdout.write("Fyll i datum och tid [YYYY-MM-DD HH:MM]: ");
    input = stdin.readLineSync()!;
  } while(input.isEmpty || DateTime.tryParse(input) == null);

  return DateTime.parse(input);

}

//print list of parkings
void printParkingList(List<Parking> parkingList, [bool showOnlyActive = false]) {

    print("\nIndex Id Registreringsnr Adress Starttid Sluttid Kostnad");
    print("--------------------------------------------------------------");
    for(var parking in parkingList) {
      if(showOnlyActive) {
        if(parking.endTime == null) {
          print("${parkingList.indexOf(parking)} ${parking.printDetails}");
        }
      } else {
        print("${parkingList.indexOf(parking)} ${parking.printDetails}");
      }
    }
    print("--------------------------------------------------------------");

  }










