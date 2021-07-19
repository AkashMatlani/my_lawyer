import 'package:my_lawyer/models/CountyModel.dart';
import 'package:my_lawyer/models/StateModel.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class DatabaseHelper {
  //... Singleton DatabaseHelper
  static DatabaseHelper _databaseHelper;

  //... Singleton Database
  static Database _database;

  String stateTable = 'state_table';
  String countyTable = 'county_table';

  String countyID = 'countyId';
  String stateID = 'stateId';
  String name = 'name';
  String id = 'id';

  //... Name constructor to create DatabaseHelper Instance
  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    //... Get document directory path for both iOS and Android to store database
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + '/mylawyer.db';

    print('Database Path - $path');
    //... Open/Create Database
    var lawyerDB = openDatabase(path, version: 1, onCreate: createDB);
    return lawyerDB;
  }

  void createDB(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute(
        'CREATE TABLE $stateTable($stateID INTEGER PRIMARY KEY , $name TEXT)');
    batch.execute(
        'CREATE TABLE $countyTable($countyID INTEGER PRIMARY KEY, $name TEXT, $stateID INTEGER)');

    //
    List<dynamic> result = await batch.commit();
  }

  //...Fetch all state from database
  Future<List<Map<String, dynamic>>> getStateMapList() async {
    Database db = await this.database;
    var result = await db.query(stateTable, orderBy: '$name ASC');
    return result;
  }

  //...Fetch all county from database
  Future<List<Map<String, dynamic>>> getCountyMapList() async {
    Database db = await this.database;
    var result = await db.query(countyTable, orderBy: '$name ASC');
    return result;
  }

  //... Insert State data
  Future<int> insertStateData(StateModel stateModel) async {
    Database db = await this.database;
    var result = await db.insert(stateTable, stateModel.toMap());
    return result;
  }

  //... Insert County data
  Future<int> insertCountyData(CountyModel countyModel) async {
    Database db = await this.database;
    var result = await db.insert(countyTable, countyModel.toMap());
    return result;
  }

  Future<List<StateModel>> getStateList() async {
    // Get a reference to the database.
    final db = await this.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query(stateTable);

    // Convert the List<Map<String, dynamic> into a List<StateModel>.
    return List.generate(maps.length, (i) {
      return StateModel(maps[i][stateID], maps[i][name]);
    });
  }

  Future<List<CountyModel>> getCountyList(int state_id) async {
    // Get a reference to the database.
    final db = await this.database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db
        .query(countyTable, where: '$stateID = ?', whereArgs: [state_id]);

    // Convert the List<Map<String, dynamic> into a List<CountyModel>.
    return List.generate(maps.length, (i) {
      return CountyModel(maps[i][countyID], maps[i][name],
          maps[i][stateID]);
    });
  }
}
