import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

import 'package:taskmanager_app/model/journal_class.dart';

class DatabaseFileRoutlines {
  //access path of phone directory
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

//path of file directory
  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/.local_persistance.json');
  }

  //read file
  Future<String> readJournals() async {
    try {
      final file = await _localFile;
      if (!file.existsSync()) {
        print("there is no file: ${file.absolute}");
        await writeJournals('{"journals": []}');
      }
      //read file
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      print("read error journal : $e");
      return " ";
    }
  }

  //write the journal since it doesn't exist
  Future<File> writeJournals(String json) async {
    final file = await _localFile;

    return file.writeAsString('$json');
  }
  // To read and parse from JSON data - databaseFromJson(jsonString);

  Database databaseFromJson(String str) {
    late final dataFromJson = json.decode(str);
    return Database.fromJson(dataFromJson);
  }

  // To save and parse to JSON Data - databaseToJson(jsonString);
  String databaseToJson(Database data) {
    final dataToJson = data.toJson();
    return json.encode(dataToJson);
  }
}

class Database {
  List<Journal> journal;
  Database({required this.journal});

  factory Database.fromJson(Map<String, dynamic> json) => Database(
        journal: List<Journal>.from(
            json["journals"].map((x) => Journal.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "journals": List<dynamic>.from(journal.map((x) => x.toJson())),
      };
}
