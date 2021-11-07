import 'dart:ffi';

import 'package:dumbometer/models/DumbPoint.dart';
import 'package:dumbometer/models/base.dart';
import 'package:dumbometer/models/database.dart';
import 'package:sqflite/sqflite.dart';

abstract class BaseRepository<T extends BaseModel> extends BaseDatabase {
  final String table;
  final T model;
  final List<String> columns;

  BaseRepository(
      {required this.table, required this.model, required this.columns})
      : super(null);

  Future<void> insert(T obj) async {
    final db = await database;

    await db.insert(
      table,
      obj.toMap(),
      ConflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  Future<DumbPoint> find(int id) async {
    final db = await database;

    final Map<String, dynamic> map = await db.query(
      table,
      where: 'id = ?',
      whereArgs: id,
    );

    return model.toObj(map);
    ;
  }

  // Retrieve all the items
  Future<List<T>> findAll() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(table);

    return List.generate(maps.length, (index) => model.toObj(maps[index]));
  }

  // Count all the items
  Future<int> count() async {
    final data = await db.rawQuery('''SELECT COUNT(*) FROM $table''');

    int count = data[0].values.elementAt(0);
    int idForNewItem = count++;
    return idForNewItem;
  }

  // clear the table
  Future<void> delete() async {
    // truncate current database table
    await db.rawQuery('''DELETE FROM $table''');
  }
}
