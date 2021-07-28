import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rstrivia/domain/user_data.dart';

class UserDataService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> _localFile(String uid) async {
    final path = await _localPath;
    return File('$path/data-$uid}.json');
  }

  void writeUserDataToJson(String json, String uid) async {
    final file = await _localFile(uid);

    // Write the file.
    file.writeAsStringSync(json);
  }

  Future<String> readUserData(String uid) async {
    try {
      final file = await _localFile(uid);

      // Read the file.
      String contents = await file.readAsString();

      if (contents.length == 0) {
        return await _loadJsonFromAsset();
      }

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return await _loadJsonFromAsset();
    }
  }

  Future<UserData> getUserData(String uid) async {
    String userDataJson = await readUserData(uid);
    Map userDataMap = jsonDecode(userDataJson);
    return UserData.fromJson(userDataMap);
  }

  void updateUserData(UserData userData, String uid) async {
    String json = jsonEncode(userData);
    writeUserDataToJson(json, uid);
  }

  void resetUserData(String uid) async {
    String userDataJson = await _loadJsonFromAsset();
    writeUserDataToJson(userDataJson, uid);
  }

  Future<String> _loadJsonFromAsset() async {
    return await rootBundle.loadString('assets/data/data.json');
  }
}
