abstract class BaseRepository<T> {
  Future<List<T>> getAll();
  Future<T?> getById(String id);
  Future<String> create(T entity);
  Future<void> update(String id, T entity);
  Future<void> delete(String id);
  Stream<List<T>> watchAll();
}
