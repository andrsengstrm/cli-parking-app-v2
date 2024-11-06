import 'package:http/http.dart' as http;

abstract class RepositoryRemote<T> {
  
  final String baseUrl = "http://localhost:8080";
  final http.Client client = http.Client();
  final List<T> _items = [];
  

  //create
  Future<void> add(T item) async {
    _items.add(item);
  }

  //read all
  Future<List<T>> getAll() async {
    return _items;
  } 

  //read single by index
  Future<T?> getByIndex(int index) async {
    return _items[index];
  } 

  //read single by id
  Future<T?> getById(int id) async {
    return _items[id];
  } 

  //update
  Future<void> update(T item) async {
    //var index = _items.indexWhere((x) => x == newItem);
    var index = _items.indexOf(item);
    _items[index] = item;
  }

  //delete
  Future<void> delete(T item) async {
    _items.remove(item);
  }
}