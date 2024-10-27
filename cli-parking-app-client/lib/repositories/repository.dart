abstract class Repository<T> {
  
  final List<T> _items = [];

  //crud
  void add (T item) => _items.add(item);

  List<T> getAll() => _items;

  T? getByIndex(int index) => _items[index];

  T? update(T item, T newItem) {
    var index = _items.indexWhere((x) => x == item);
    _items[index] = newItem;
    return _items[index];
  }

  void delete(T item) => _items.remove(item);

}