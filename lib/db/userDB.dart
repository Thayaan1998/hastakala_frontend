import 'package:flutter/widgets.dart';
import 'package:fyp/db/User.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class userDB {

  const userDB();

  Future<Database> dbCall() async {
    WidgetsFlutterBinding.ensureInitialized();
    // Open the database and store the reference.
    var database = openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(await getDatabasesPath(), 'hastkala.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return db.execute(
          'CREATE TABLE users(userId  INTEGER PRIMARY KEY, type TEXT)',
        );
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    return database;
  }

  Future<void> insertUser(User user) async {
    var db = await dbCall();

    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUser() async {
    // Get a reference to the database.
    final db = await dbCall();

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('users');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return User(
          userId: maps[i]['userId'],
          type: maps[i]['type']
      );
    });
  }

  Future<void> updateUser(User user) async {
    // Get a reference to the database.
    final db = await dbCall();

    // Update the given Dog.
    await db.update(
      'users',
      user.toMap(),
      // Ensure that the Dog has a matching id.
      where: 'userId = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [user.userId],
    );
  }

  Future<void> deleteUser(int id) async {
    // Get a reference to the database.
    final db = await dbCall();

    // Remove the Dog from the database.
    await db.delete(
      'users',
      // Use a `where` clause to delete a specific dog.
      where: 'userId = ?',
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }
}
