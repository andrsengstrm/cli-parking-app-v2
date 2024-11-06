import 'dart:convert';
import 'dart:io';
import 'package:cli_parking_app_client/main_menu.dart' as main_menu;
import 'package:cli_parking_app_shared/models/parking_space.dart';
import 'package:cli_parking_app_shared/repositories/parking_space_repository.dart';

void showMenu() {
  
  //show the submenu for 'Personer'
  print("\nMeny för parkingsplatser, välj ett alternativ:"); 
  print("1. Lägg till parkeringsplats");
  print("2. Visa parkeringsplats");
  print("3. Visa alla parkeringsplats");
  print("4. Uppdatera parkeringsplats");
  print("5. Ta bort parkeringsplats");
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
    
    //add parkingspace
    addParkingSpace();
  
  } else if(optionSelected == "2") { 
    
    //list parkingspace
    getParkingSpace();
  
  } else if(optionSelected == "3") { 
    
    //list all parkingspaces
    getAllParkingSpaces();
  
  } else if(optionSelected == "4") { 
    
    //update parkingspace
    updateParkingSpace();
  
  } else if(optionSelected == "5") { 
    
    //delete parkingspace
    deleteParkingSpace();
  
  } else if(optionSelected == "6") { 
    
    //go back to main menu
    main_menu.showMenu();
  
  } else { 
    
    //unsupported selection
    stdout.write("\nOgiligt val! Välj ett alternativ (1-6): ");

    readMenuSelection();
  
  }
  
}

void addParkingSpace()  async{

  //ask for the address
  String address = setAddress();

  //ask for pricePerHour
  double pricePerHour = setPricePerHour();

  try {

    //construct a ParkingSpace and add it with function from the repo
    var newParkingSpace = ParkingSpace(address: address, pricePerHour: pricePerHour);
    await ParkingSpaceRepository().add(newParkingSpace);
  
    print("\nParkeringsplatsen ${newParkingSpace.address} har lagts till.");

  } catch(err) {

    print("\nEtt fel har uppstått: $err");

  }
  
  showMenu();


}

void getParkingSpace() async {

  stdout.write("\nAnge index på den parkeringsplats du vill visa (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") {
    showMenu();
    return;
  }

  try {

    //get the parkingspace by its id
    var parkingSpace = await ParkingSpaceRepository().getByIndex(int.parse(index));
    print("\nIndex Id Adress Pris/timme");
    print("-------------------------------");
    print("$index ${parkingSpace!.printDetails}");
    print("-------------------------------");

  } on StateError { 
    
    //no one was found, lets try again
    print("Det finns ingen parkeringsplats med index $index");
    getParkingSpace();

  } on RangeError { 
    
    //outside the index, lets try again
    print("Det finns ingen parkeringsplats med index $index");
    getParkingSpace();

  } catch(err) { //some other error

    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}

void getAllParkingSpaces() async {

  var parkingSpaceList = await ParkingSpaceRepository().getAll();

  if(parkingSpaceList.isEmpty) {

    print("Det finns inga parkeringsplatser registrerade");

  } else {

    printParkingSpaceList(parkingSpaceList);

  }

  showMenu();

}

void updateParkingSpace() async {

  var parkingSpaceList = await ParkingSpaceRepository().getAll();
  if(parkingSpaceList.isEmpty) {

    print("\nDet finns inga parkeringsplatser registrerade");
    showMenu();

  }

  stdout.write("\nAnge index på den parkeringsplats du vill uppdatera (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") {

    showMenu();
    return;

  }

  try {

    //try to get the person from the personrepository
    var parkingSpace = await ParkingSpaceRepository().getByIndex(int.parse(index));

    //ask to update the name
    String address = setAddress("\nVilken adress har parkeringsplatsen? [Nuvarande värde: ${parkingSpace!.address}] ");

    //ask to update the personId
    double pricePerHour = setPricePerHour("Vilket pris per timme har parkeringsplatsen? [Nuvarande värde: ${parkingSpace.pricePerHour}] ");

    var updatedParkingSpace = ParkingSpace(id: parkingSpace.id, address: address, pricePerHour: pricePerHour);

    //update the person
    await ParkingSpaceRepository().update(parkingSpace, updatedParkingSpace);
    print("\nParkeringsplatsen har uppdaterats");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkeringsplats med index $index");
    updateParkingSpace();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkeringsplats med index $index");
    updateParkingSpace();

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}

void deleteParkingSpace() async {

  var parkingSpaceList = await ParkingSpaceRepository().getAll();
  if(parkingSpaceList.isEmpty) {

    print("\nDet finns inga parkeringsplatser registrerade");
    showMenu();
  }

  //select parkingspace by index
  String input;
  do {
    stdout.write("\nVälj index för parkeringsplatsen som du vill ta bort: ");
    input = stdin.readLineSync()!;
  } while(input.isEmpty || int.tryParse(input) == null);
  int index = int.parse(input);

  try {

    //try to get the person from the personrepository
    var parkingSpace = await ParkingSpaceRepository().getByIndex(index);

    //delete the person
    await ParkingSpaceRepository().delete(parkingSpace!);
    print("\nParkeringsplatsen ${parkingSpace.address} har tagits bort");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen parkeingsplats med index $index");
    deleteParkingSpace();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen parkeingsplats med index $index");
    deleteParkingSpace();

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();


}


/*---------------- subfunctions ------------------*/

//subfunction to set or update the address
String setAddress([String message = "\nVilken adress har parkeringsplatsen? "]) {

  //set the adress
  String address;
  do {
    stdout.write(message);
    address = stdin.readLineSync(encoding: utf8)!;
  } while(address.isEmpty);

  //return the address
  return address;

}

//subfunction to set or update priceperhour
double setPricePerHour([String message = "Vilket pris per timme har parkeringsplatsen? Fyll i ett numeriskt värde: "]) {

  //set the price, make sure its a double
  String input;
  do {
    stdout.write(message);
    input = stdin.readLineSync()!;
  } while(input.isEmpty || double.tryParse(input) == null);
  
  //return the price
  return double.parse(input);

}

//print list of parkingspaces
void printParkingSpaceList(List<ParkingSpace> parkingSpaceList) {

    print("\nIndex Id Adress Pris/timme");
    print("-------------------------------");
    for(var parkingSpace in parkingSpaceList) {
      print("${parkingSpaceList.indexOf(parkingSpace)} ${parkingSpace.printDetails}");
    }
    print("-------------------------------");

  }






