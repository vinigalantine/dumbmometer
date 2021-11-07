import 'package:dumbometer/models/base.dart';

class DumbPoint implements BaseModel {
  final int id;
  final DateTime when;

  DumbPoint({
    required this.id,
    required this.when,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'when': when,
    };
  }

  DumbPoint toObj(Map<String, dynamic> map) {
    return DumbPoint(id: map['id'], when: map['when']);
  }

  @override
  String toString() {
    return 'DumbPoint{id: $id, name: $when}';
  }
}
