import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'image/media.dart';
import 'note/note.dart';

//单例类（保证只创建一个数据库）
class DBUtil {
  // static DBUtil? instance;
  late Isar isar;
  static late String path;

  static Future<void> init() async {
    Directory document = await getApplicationDocumentsDirectory();
    path = document.path;
    await Isar.open([NoteSchema, MediaSchema],
        directory: path, name: "LifeRecord");
  }
}
