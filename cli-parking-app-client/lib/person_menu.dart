import "dart:convert";
import "dart:io";
import "package:cli/main_menu.dart" as main_menu;
import "package:cli/models/person.dart";
import "package:cli/repositories/person_repsoitory.dart";

void showMenu() {
  
  //show the submenu for 'Personer'
  print("\nMeny för personer, välj ett alternativ:"); 
  print("1. Lägg till person");
  print("2. Visa person");
  print("3. Visa alla personer");
  print("4. Uppdatera person");
  print("5. Ta bort person");
  print("6. Gå tillbaka till huvudmenyn");
  stdout.write("\nVälj ett alternativ (1-6): ");

  //read the selected option
  readMenuSelection();

}

void readMenuSelection() {
  
  //wait for input and read the selection option
  String optionSelected = stdin.readLineSync()!;

  //select action based on the selected option
  if(optionSelected == "1") { //add person

    addPerson();
  
  } else if(optionSelected == "2") { //list all persons
  
    getPerson();
  
  } else if(optionSelected == "3") { //list all persons
  
    getAllPersons();
  
  } else if(optionSelected == "4") { //update person
  
    updatePerson();
  
  } else if(optionSelected == "5") { //delete person
  
    deletePerson();
  
  } else if(optionSelected == "6") { //go back to main menu
  
    main_menu.showMenu();
  
  } else { //unsupported selection
  
    stdout.write("\nOgiligt val! Välj ett alternativ (1-6): ");

    readMenuSelection();
  
  }
  
}

void addPerson() async {

  //ask for the name
  String name = setName();

  //ask for personId
  String personId = setPersonId();
    
  try {

    //construct a Person and add Person with function from the repo
    var newPerson = Person(personId: personId, name: name);
    await PersonRepository().add(newPerson);
  
    print("\nPersonen ${newPerson.name} har lagts till.");

  } catch(err) {

    print("\nEtt fel har uppstått: $err");

  }
  
  
  showMenu();

}

void getPerson() async {

  stdout.write("\nAnge index på den person du vill visa (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") {
    showMenu();
    return;
  }

  try {

    //get the person by its index
    var person = await PersonRepository().getByIndex(int.parse(index));
    print("\nIndex Id Namn Personnummer");
    print("-------------------------------");
    print("$index ${person!.printDetails}");
    print("-------------------------------");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen person med index $index");
    getPerson();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen person med index $index");
    getPerson();

  } catch(err) { 
    
    //some other error
    print("\nEtt fel har uppstått: $err"); 

  }

  showMenu();
  
}

void getAllPersons() async {

  //get all persons from the repo
  var personList = await PersonRepository().getAll();

  if(personList.isEmpty) {
    
    print("\nDet finns inga personer registrerade");
  
  } else {
    
    //print all persons by using a subfunction
    printPersonList(personList);

  }

  showMenu();

}

void updatePerson() async {

  //get all persons, if empty we return to the menu
  var personList = await PersonRepository().getAll();
  if(personList.isEmpty) {

    stdout.write("\nDet finns inga personer registrerade");
    showMenu();

  }

  stdout.write("\nAnge index på den person du vill uppdatera (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") {

    showMenu();

  }

  try {

    //try to get the person from the personrepository
    var person = await PersonRepository().getByIndex(int.parse(index));

    //ask to update the name
    String name = setName("\nVilket namn har personen? [Nuvarande värde: ${person!.name}] ");

    //ask to update the personId
    String personId = setPersonId("Vilket personnummer har personen? [Nuvarande värde: ${person.personId}] ");

    var updatedPerson = Person(id: person.id, personId: personId, name: name);

    //update the person
    await PersonRepository().update(person, updatedPerson);
    print("\nPersonen har uppdaterats");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen person med index $index");
    updatePerson();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen person med index $index");
    updatePerson();

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}

void deletePerson() async {

  //get all persons, if empty we return to the menu
  var personList = await PersonRepository().getAll();
  if(personList.isEmpty) {

    stdout.write("\nDet finns inga personer registrerade");
    showMenu();

  }

  stdout.write("\nAnge index på den person du vill ta bort (tryck enter för att avbryta): ");
  String index = stdin.readLineSync()!;

  if(index == "") { //no value provided
    showMenu();
  }

  try {

    //try to get the person from the personrepository
    var person = await PersonRepository().getByIndex(int.parse(index));

    //delete the person
    await PersonRepository().delete(person!);
    print("\nPersonen ${person.name} har tagits bort");

  } on StateError { 
    
    //no one was found, lets try again
    print("\nDet finns ingen person med index $index");
    deletePerson();

  } on RangeError { 
    
    //outside the index, lets try again
    print("\nDet finns ingen person med index $index");
    deletePerson();

  } catch(err) { 
    
    //some other error, exit function
    print("\nEtt fel har uppstått: $err");

  }

  showMenu();

}


/*---------------- subfunctions -----------------------*/

//sunfunction to set or update the name
String setName([String message = "\nVilket namn har personen? "]) {

  //set the name, make sure its not empty
  String name;
  do {
    stdout.write(message);
    name = stdin.readLineSync(encoding: utf8)!;
  } while(name.isEmpty);

  //return the name
  return name;

}

//subfunction to set personId
String setPersonId([String message = "Vilket personnummer har personen? "]) {

  //set the personId, make sure its not empty
  String personId;
  do {
    stdout.write(message);
    personId = stdin.readLineSync()!;
  } while(personId.isEmpty);

  //return the personId
  return personId;

}

//print list of persons
void printPersonList(List<Person> personList) {

    print("\nIndex Id Namn Personnummer");
    print("-------------------------------");
    for(var person in personList) {
      print("${personList.indexOf(person)} ${person.printDetails}");
    }
    print("-------------------------------");

  }