abstract class Data<T> {
  Future<void> save(List<T> items);
  Future<List<T>> load();
}
