import 'package:path_provider/path_provider.dart';
import 'dart:io';

class InternalFiles {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> _localFile(String where) async {
    final path = await _localPath;
    if (where == 'main') {
      return File('$path/messages.dart');
    } else {
      return File('$path/settings.dart');
    }
  }

  static Future<File> write(String text, String whereTo) async {
    final file = await _localFile(whereTo);
    return file.writeAsString(text);
  }

  static Future<String> read(String whereTo) async {
    try {
      final file = await _localFile(whereTo);
      final contents = await file.readAsString();
      return contents;
    } catch (e) {
      return "";
    }
  }
}
