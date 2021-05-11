// import 'dart:mirrors';

// // Example: UserRepository extends Repository<User, int>
// // Note: First parameter is the class model, and the second is the type of id
// abstract class Repository<T, S> {
//   Future<List<T>> findAll();

//   Future<List<T>> findAllWithPagination(int limit, int pageNumber);

//   Future<T?> findOne(S value);

//   // TODO: know if delete was done via exception
//   // wrap in try
//   Future<void> deleteOne(S value);

//   Future<T?> insert(T value);

//   void update(S id, T objet, {bool withNull = true});

//   Map<String, dynamic> recaseMap(Map<String, dynamic> map);
// }
