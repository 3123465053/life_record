import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:life_record/database/image/media.dart';

import '../../../database/note/note.dart';
import '../home/logic.dart';

class ShowNoteLogic extends GetxController {
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  Note note = Note();

  @override
  void onInit() {
    super.onInit();
    note = Get.arguments["note"];
    initData();
  }

  initData() {
    imageList = note.images.toList();
    if (note.title != null) {
      titleController.text = note.title!;
    }
    if (note.time != null) {
      timeController.text = note.time!;
    }
    if (note.content != null) {
      contentController.text = note.content!;
    }
  }

  saveNote() async {
    final isar = Isar.getInstance("LifeRecord")!;
    note.title = titleController.text;
    note.time = timeController.text;
    note.content = contentController.text;
    note.images.addAll(imageList);

    await isar.writeTxn(() async {
      await isar.notes.put(note);
      await isar.medias.putAll(imageList);
      await note.images.save();
    });

    final logic = Get.find<HomeLogic>();
    logic.getNoteList();
    logic.update();
    Get.back();
    Get.snackbar('提示', '修改成功',
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.grey.shade200);
  }
}

deleteImage(Media media) async {
  final isar = Isar.getInstance("LifeRecord")!;
  await isar.writeTxn(() async {
    await isar.medias.delete(media.id);
  });
}
