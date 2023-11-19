import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:life_record/app/pages/show/logic.dart';

import '../home/logic.dart';

class ShowNotePage extends StatelessWidget {
  const ShowNotePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget body = GetBuilder<ShowNoteLogic>(builder: (logic) {
      return ListView(
        children: [
          TextField(
            controller: logic.titleController,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            decoration: InputDecoration(
              icon: Icon(Icons.title),
              hintText: "请输入标题",
              border: InputBorder.none,
            ),
          ).paddingOnly(left: 20),
          TextField(
            controller: logic.timeController,
            decoration: InputDecoration(
                icon: Icon(Icons.timelapse),
                hintText: "完成时间",
                border: InputBorder.none),
          ).paddingOnly(left: 20),
          Container(
            margin: const EdgeInsets.only(right: 20, left: 20, top: 20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
              maxLines: 6,
              controller: logic.contentController,
              decoration: InputDecoration(
                  hintText: "填写内容，记录美好生活~", border: InputBorder.none),
            ),
          ),
          ShowImage(
            height: Get.height * 0.4,
          ).paddingAll(20)
        ],
      ).paddingOnly(top: 20);
    });

    return GetBuilder<ShowNoteLogic>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.transparent,
          title: const Text(
            "编辑",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: [
            InkWell(
              onTap: () {
                logic.saveNote();
              },
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 15, bottom: 10, top: 10),
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  "修改",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
        body: body,
      );
    });
  }
}
