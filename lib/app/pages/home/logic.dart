import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar/isar.dart';
import 'package:life_record/app/pages/show/logic.dart';
import 'package:life_record/database/image/media.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';
import 'dart:io';

import '../../../database/note/note.dart';

final ImagePicker picker = ImagePicker();
List<Media> imageList = [];

class HomeLogic extends GetxController {
  // Note note = Note();
  List<Note> noteList = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getNoteList();
  }

  getNoteList() {
    final isar = Isar.getInstance("LifeRecord")!;
    noteList = isar.notes.where().findAllSync();
    noteList.forEach((element) {
      print(element.images);
    });
  }

  createNoteDialog(BuildContext context) {
    Get.defaultDialog(
        title: "新建",
        content: Column(
          children: [
            TextField(
              controller: titleController,
              decoration:
                  InputDecoration(icon: Icon(Icons.title), hintText: "请输入标题"),
            ).paddingOnly(right: 20),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                  icon: Icon(Icons.timelapse), hintText: "完成时间"),
            ).paddingOnly(right: 20),
            ShowImage(),
          ],
        ),
        textConfirm: "确认",
        textCancel: "取消",
        onCancel: () {
          Get.back();
        },
        onConfirm: () async {
          await saveNote();
          getNoteList();
          update();
          Get.back();
        });
  }

  saveNote() async {
    Note note = Note();
    final isar = Isar.getInstance("LifeRecord")!;
    note.title = titleController.text.toString();
    note.time = timeController.text.toString();
    List<Media> images = [];
    imageList.forEach((element) {
      images.add(element);
    });

    note.images.addAll(images);
    await isar.writeTxn(() async {
      await isar.notes.put(note);
      await isar.medias.putAll(imageList);
      await note.images.save();
    });
  }

  bottomSheet(Note note) {
    Get.bottomSheet(SizedBox(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            width: Get.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    signDo(note);
                  },
                  child: Text(
                    "标为已完成",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).paddingOnly(top: 13),
                Divider(),
                InkWell(
                  onTap: () {
                    deleteNote(note);
                  },
                  child: Text(
                    "删除笔记",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 17),
                  ).paddingOnly(bottom: 13),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Text(
                "取消",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontSize: 17),
              ),
            ),
          )
        ],
      ),
    ));
  }

  deleteNote(Note note) async {
    final isar = Isar.getInstance("LifeRecord")!;
    await isar.writeTxn(() async {
      await isar.notes.delete(note.id);
    });
    getNoteList();
    update();
    Get.back();
  }

  signDo(Note note) async {
    final isar = Isar.getInstance("LifeRecord")!;
    note.isDone = true;
    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
    getNoteList();
    update();
    Get.back();
  }

  screenNote(String range) {
    final isar = Isar.getInstance("LifeRecord")!;
    switch (range) {
      case "所有":
        noteList = isar.notes.where().findAllSync();
        break;
      case "已完成":
        noteList = isar.notes.filter().isDoneEqualTo(true).findAllSync();
        break;
      case "规划中":
        noteList = isar.notes.filter().isDoneEqualTo(false).findAllSync();
        break;
    }
    update();
  }
}

class ShowImage extends StatefulWidget {
  ShowImage({super.key, this.height = 200});
  double height;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  deleteImageDialog(Media media) {
    Get.bottomSheet(SizedBox(
      height: 180,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: 100,
            width: Get.width,
            margin: EdgeInsets.only(left: 10, right: 10),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("照片将从笔记中删除").paddingOnly(top: 10),
                Divider(),
                InkWell(
                  onTap: () async {
                    imageList.remove(media);
                    // await deleteImage(media);
                    setState(() {});
                    Get.back();
                  },
                  child: Text(
                    "删除照片",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        fontSize: 17),
                  ).paddingOnly(bottom: 13),
                )
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Get.back();
            },
            child: Container(
              height: 50,
              margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Text(
                "取消",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                    fontSize: 17),
              ),
            ),
          )
        ],
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      margin: EdgeInsets.only(top: 20),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(10)),
      child: imageList.length == 0
          ? Center(
              child: InkWell(
                onTap: () async {
                  List<AssetEntity>? images = await AssetPicker.pickAssets(
                    context,
                    pickerConfig: AssetPickerConfig(maxAssets: 99),
                  );
                  if (images != null) {
                    images.forEach((image) {
                      String path =
                          '/storage/emulated/0/${image.relativePath!}${image.title!}';
                      Media media = Media()..path = path;
                      imageList.add(media);
                    });
                  }
                  setState(() {});
                },
                child: Text("点击上传图片"),
              ),
            )
          : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //主轴方向个数
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1 //宽高比
                  ),
              scrollDirection: Axis.vertical, //滑动方向
              //physics: NeverScrollableScrollPhysics(),禁止滚动
              itemCount: imageList.length + 1,
              itemBuilder: (BuildContext context, index) {
                if (index == imageList.length) {
                  return InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.add),
                    ),
                    onTap: () async {
                      List<AssetEntity>? images = await AssetPicker.pickAssets(
                        context,
                        pickerConfig: AssetPickerConfig(maxAssets: 99),
                      );
                      if (images != null) {
                        images.forEach((image) {
                          String path =
                              '/storage/emulated/0/${image.relativePath!}${image.title!}';
                          Media media = Media()..path = path;
                          imageList.add(media);
                        });
                      }
                      setState(() {});
                    },
                  );
                } else {
                  return InkWell(
                    onTap: () async {
                      await deleteImageDialog(imageList[index]);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                              image: FileImage(File(imageList[index].path!)),
                              fit: BoxFit.cover)),
                    ),
                  );
                }
              }),
    );
  }
}

selectImageDialog(BuildContext context) {
  return WoltModalSheetPage.withSingleChild(
      isTopBarLayerAlwaysVisible: true,
      topBarTitle: const Center(
        child: Text("您将从哪里获取照片",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900)),
      ),
      child: Column(
        children: [
          TextButton(
              onPressed: () async {
                var image = await picker.pickImage(
                  source: ImageSource.camera,
                );
                // if (image != null) {
                //   Get.offAndToNamed(AppRoutes.RecognitionResultPage,
                //       arguments: <String, dynamic>{
                //         'imagePath': image.path,
                //         "functionValue": functionValue
                //       });
                // }
              },
              child: const Text(
                "拍照",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
          TextButton(
              onPressed: () async {
                // var image = await picker.pickImage(
                //     source: ImageSource.gallery,
                //     requestFullMetadata: false);
                List<AssetEntity>? images = await AssetPicker.pickAssets(
                  context,
                  pickerConfig: AssetPickerConfig(maxAssets: 99),
                );

                // if (image != null) {
                //   String path =
                //       '/storage/emulated/0/${image[0].relativePath!}${image[0].title!}';
                //   Get.offAndToNamed(AppRoutes.RecognitionResultPage,
                //       arguments: <String, dynamic>{
                //         'imagePath': path,
                //         "functionValue": functionValue
                //       });
                // }
              },
              child: const Text(
                "从相册中获取",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              )),
        ],
      ).paddingOnly(bottom: 10));
}
