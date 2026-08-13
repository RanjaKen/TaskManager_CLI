abstract class Repository<T> {
  Future<void> add(T item);
  Future<void> update(T item);
  Future<void> delete(int id);
  Future<List<T>> getAll();
}