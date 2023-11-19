import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:life_record/app/pages/home/logic.dart';
import 'package:life_record/router/app_pages.dart';
import 'package:life_record/router/app_routes.dart';

import '../../../database/note/note.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget body = GetBuilder<HomeLogic>(builder: (logic) {
      return ListView.builder(
        itemCount: logic.noteList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            onTap: () {
              Get.toNamed(AppRoutes.SHOW_NOTE_PAGE,
                  arguments: {"note": logic.noteList[index]});
            },
            onLongPress: () {
              logic.bottomSheet(logic.noteList[index]);
            },
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: logic.noteList[index].images.isEmpty
                        ? Image.asset("asset/image.png").image
                        : FileImage(
                            File(logic.noteList[index].images.first.path!)),
                  )),
            ),
            title: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                logic.noteList[index].title == null
                    ? "暂无标题"
                    : logic.noteList[index].title!,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    logic.noteList[index].time == null
                        ? "暂无时间"
                        : logic.noteList[index].time!,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                Divider()
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: logic.noteList[index].isDone
                        ? Colors.grey
                        : Colors.green,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                Text(
                  logic.noteList[index].isDone ? "已完成" : "规划中",
                  style: TextStyle(
                      fontSize: 13,
                      color: logic.noteList[index].isDone
                          ? Colors.grey
                          : Colors.black),
                )
              ],
            ).paddingOnly(bottom: 20),
          );
        },
      );
    });
    return GetBuilder<HomeLogic>(builder: (logic) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "笔记",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
          ),
          actions: [
            PopupMenuButton(
                onSelected: (value) {
                  logic.screenNote(value);
                },
                child: Icon(
                  Icons.sort,
                  color: Colors.black,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: "所有",
                      child: Text("所有笔记"),
                    ),
                    PopupMenuItem(
                      value: "规划中",
                      child: Text("规划中"),
                    ),
                    PopupMenuItem(
                      value: "已完成",
                      child: Text("已完成"),
                    ),
                  ];
                }),
            // IconButton(
            //     onPressed: () {},
            //     icon: Icon(
            //       Icons.sort,
            //       color: Colors.black,
            //     )),
            IconButton(
                onPressed: () {
                  logic.createNoteDialog(context);
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                )),
          ],
        ),
        body: body,
      );
    });
  }
}
