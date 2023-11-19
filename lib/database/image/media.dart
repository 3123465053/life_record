import 'package:isar/isar.dart';
part 'media.g.dart';

@collection
class Media {
  Id id = Isar.autoIncrement;
  String? path;
  @override
  toString() {
    return 'Image{path: $path}';
  }
}
