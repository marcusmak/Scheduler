import 'dart:async';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart'; //required.

import 'HomePage(old).dart';

class LocalDataManager{
  static Database? database;

  static void InitialiseDatabase() async{

    // Open the database and store the reference.
    var dbPath = join(await getDatabasesPath(), 'localDB.db');
    if (!File(dbPath).existsSync()){
        ByteData data = await rootBundle.load("assets/localDB.db");
        List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
        print(dbPath);
      try{
        await File(dbPath).writeAsBytes(bytes);
        print("Copy database structure");
      }catch(e){
        print(e);
      }
    }else{
      print("exist database");
    }

    // print("DATABASE: " + database.toString());
    // List<Map<String, dynamic>> results = await database.rawQuery('PRAGMA table_info(custom_rule);');
    // print(results);



    // final Future<Database> database = openDatabase(
    //   join(await getDatabasesPath(), 'local_database.db'),
    //   version: 1,
    //   onCreate: (db, version) {
    //     print("Create database");
    //     // return db.execute(
    //     //   "CREATE TABLE custom_rule("
    //     // );
    //   },
    //   onOpen: (db){
    //     print("Open database");
    //   }
    // );
  }

  static Future<void> DeleteDatabase() async{
    WidgetsFlutterBinding.ensureInitialized();
    print("Delete database");
    await deleteDatabase(join(await getDatabasesPath(), 'localDB.db'));
    print("Finish deleteing database");
  }

  static void DownloadDatabase() async{
    var dbPath = join(await getDatabasesPath(), 'localDB.db');
    Directory? temp = await getExternalStorageDirectory();
    print(temp?.path);
    print(dbPath);
    await temp?.create(recursive: true);
    File(dbPath).copy(temp!.path+'/localDB.db');
  }


  static void BrosweData(String table) async{
    try{
      var dbPath = join(await getDatabasesPath(), 'localDB.db');
      database = await openDatabase(dbPath);
      print("Broswing Table " + table.toString() + (await database?.query(table)).toString());
      database?.close();
    }catch(e){
      print(e);
    }
  }

  static Future<List<EventData>?> FetchEvents() async{
    var dbPath = join(await getDatabasesPath(),'localDB.db');
        print("fetching all items");
        // if(!database.isOpen || database == null){
        database = await openDatabase(dbPath);
        // }
        try {
          String sql = "SELECT * FROM Event";
          List<Map<String,dynamic>> res = await database!.rawQuery(sql);
          database!.close();
          return res.map((element)=>new EventData.fromMap(element)).toList();
        }catch(e){
          print("error in line 89 localdatamanager.dart");
          print(e);
        }

        database!.close();
        return null;
      }

  static void AddEvent(String title,Function callback) async{
    var dbPath = join(await getDatabasesPath(),'localDB.db');
    print("fetching all items");
    // if(!database.isOpen || database == null){
    database = await openDatabase(dbPath);
    // }
    try {
      // String sql = "";
      await database!.insert("Event",{
        "title" : title,
      });
      database!.close();
      callback();
    }catch(e){
      print("error in line 89 localdatamanager.dart");
      print(e);
    }

    database!.close();
    return null;
  }

}