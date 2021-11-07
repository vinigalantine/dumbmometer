abstract class BaseModel<T> {
  final int id;

  BaseModel({required this.id});

  Map<String, dynamic> toMap() {
    throw Exception('Error trying to parse to Map');
  }

  // T toObj(Map<String, dynamic> map) {
  //   throw Exception('Error trying to parse to Object');
  // }
}
