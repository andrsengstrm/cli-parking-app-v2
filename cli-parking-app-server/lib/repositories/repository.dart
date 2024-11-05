abstract class Repository<T> {
  
  final List<T> _items = [];

  //crud
  Future<void> add (T item) async => _items.add(item);

  Future<List<T>> getAll() async => _items;

  Future<T?> getByIndex(int index) async => _items[index];

  Future<void> update(T item, T newItem) async {
    var index = _items.indexWhere((x) => x == item);
    _items[index] = newItem;
  }

  Future<void> delete(T item) async => _items.remove(item);

}