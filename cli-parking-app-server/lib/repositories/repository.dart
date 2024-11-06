abstract class Repository<T> {
  
  final List<T> items = [];

  //crud
  Future<void> add (T item) async => items.add(item);

  Future<List<T>> getAll() async => items;

  Future<T?> getByIndex(int index) async => items[index];

  Future<T?> getById(int id) async => throw Exception("Not implemented");

  Future<void> update(int id, T updatedItem) async {
    throw Exception("Not implemented");
  }

  Future<void> delete(int id) async => throw Exception("Not implemented");

}