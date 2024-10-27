import "package:cli/init_data.dart";
import "package:cli/main_menu.dart" as main_menu;


void main(List<String> arguments) {
  
  //init some data, only used it for quick testing
  initData();

  //show the main menu
  main_menu.showMenu();

}


