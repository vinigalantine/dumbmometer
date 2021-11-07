import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'DumbPoint.dart';

class BaseDatabase {
  late final database;
  // Initialization script split into seperate statements
  final initScript = [];
  // Migration sql scripts, containing a single statements per migration
  final migrationScripts = [];

  BaseDatabase(this.database) {
    WidgetsFlutterBinding.ensureInitialized();
    this.database = openDatabase(join(getDbPath().toString(), 'dumbometer.db'),
        version: 1, onCreate: (db, version) {
      initScript.forEach((script) async => await db.execute(script));
    }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
      migrationScripts.forEach((script) async => await db.execute(script));
    });
  }

  Future<String> getDbPath() async {
    return await getDatabasesPath();
  }
}

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final database = openDatabase(join(await getDatabasesPath(), 'dumbometer.db'),
  //     version: 1, onCreate: (db, version) {
  //   initScript.forEach((script) async => await db.execute(script));
  // }, onUpgrade: (Database db, int oldVersion, int newVersion) async {
  //   migrationScripts.forEach((script) async => await db.execute(script));
  // });

  Future<void> insertDog(DumbPoint dumbPoint) async {
    final db = await database;

    await db.insert(
      'dumbPoints',
      dumbPoint.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DumbPoint>> dumbPoints() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('dumbPoints');

    return List.generate(maps.length, (i) {
      return DumbPoint(
        id: maps[i]['id'],
        when: maps[i]['when'],
      );
    });
  }

  Future<void> updateDog(Dog dog) async {
    // Get a reference to the database.
    final db = await database;

    // Update the given Dog.
    await db.update(
      'dogs',
      dog.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [dog.id],
    );
  }

  Future<void> deleteDog(int id) async {
    final db = await database;

    await db.delete(
      'dumbPoints',
      // Use a `where` clause to delete a specific dog.
      where: 'id = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  await insertDog(fido);

  // Now, use the method above to retrieve all the dogs.
  print(await dogs()); // Prints a list that include Fido.

  // Update Fido's age and save it to the database.
  fido = Dog(
    id: fido.id,
    name: fido.name,
    age: fido.age + 7,
  );
  await updateDog(fido);

  // Print the updated results.
  print(await dogs()); // Prints Fido with age 42.

  // Delete Fido from the database.
  await deleteDog(fido.id);

  // Print the list of dogs (empty).
  print(await dogs());
}
