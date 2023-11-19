import 'package:life_record/database/image/media.dart';

import 'package:isar/isar.dart';
part 'note.g.dart';

@collection
class Note {
  Id id = Isar.autoIncrement;
  String? title;
  String? time;
  String? content;
  bool isDone = false;
  final images = IsarLinks<Media>();

  @override
  toString() {
    return 'Note{id: $id, title: $title, time: $time, isDone: $isDone, images: $images}';
  }
}
