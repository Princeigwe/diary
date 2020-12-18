//import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // for file system location
import 'dart:io'; //used by File
import 'dart:convert'; //used by json

class DatabaseFileRoutines {
  // method that returns the document directory path
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  //method that returns the Future file with respect to json file
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/local_persistence.json');
  }

  Future<String> readJournals() async {
    try {
      // serarching for file data, if the file does not exist...
      final file = await _localFile;
      if (!file.existsSync()) {
        print('File does not Exist: ${file.absolute}');
        await writeJournals('{"journals": [] }');
      }
      //if the file exists read  function
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print('error readJournals: $e');
      return '';
    }
  }

  Future<File> writeJournals(String json) async {
    final file = await _localFile;
    // writing the file
    return file.writeAsString('$json');
  }
}

// class that contains a list of journals
class Database {
  List<Journal> journal;

  Database({
    this.journal,
  });

  //decodes database objects from json
  factory Database.fromJson(Map<String, dynamic> json) => Database(
    journal: List<Journal>.from(
        json["journals"].map((x) => Journal.fromJson(x))),
  );

  //decodes database objects from json
  Map<String, dynamic> toJson() => {
    "journals": List<dynamic>.from(journal.map((x) => x.toJson())),
  };
}

//methods for JSON encoding and decoding for the database in the database class
//decoding from json
Database databaseFromJson(String str) {
  final dataFromJson = json.decode(str);
  return Database.fromJson(dataFromJson);
}

//encoding to json
String databaseToJson(Database data) {
  final datatoJson = data.toJson();
  return json.encode(datatoJson);
}

// creating a journal class that contains id,date,mood,note for creating journals
class Journal {
  String id;
  String date;
  String mood;
  String note;

  Journal({
    this.id,
    this.date,
    this.mood,
    this.note,
  });

  // method for decoding journal data from json format
  factory Journal.fromJson(Map<String, dynamic> json) => Journal(
    id: json["id"],
    date: json["date"],
    mood: json["mood"],
    note: json["note"],
  );

  // method for encoding journal data to json format
  Map<String, dynamic> toJson() => {
    "id": id,
    "date": date,
    "mood": mood,
    "note": note,
  };
}

// class for editing journals
class JournalEdit {
  String action;

  //calling the journal class
  Journal journal;

  //function for perfoming action on the journal class
  JournalEdit({this.action, this.journal});
}