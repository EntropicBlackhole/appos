// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:appos/pages/home_page.dart';
import 'package:appos/api/storage_api.dart';
import 'dart:convert';

class AddPage extends StatefulWidget {
  List<dynamic> messageObject = [];
  bool darkMode = false;
  AddPage({Key? key, required this.messageObject, required this.darkMode})
      : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final newMesssageController = TextEditingController();
  int messageAmt = 0;
  Map newMessage = {};
  @override
  void initState() {
    super.initState();
    messageAmt = widget.messageObject.length;
    newMessage = {
      "id": "${widget.messageObject.length + 1}",
      "message": "",
      "hearted": "false"
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage(
                "lib/assets/images/background${(widget.darkMode ? "_darkmode" : "")}.jpg"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Appos: Add message"),
          backgroundColor: (widget.darkMode ? Colors.black12 : Colors.blue),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 8,
              ),
              TextField(
                style: TextStyle(
                    color: (widget.darkMode ? Colors.white : Colors.black)),
                decoration: InputDecoration(
                  label: Text("ID: ${messageAmt + 1}"),
                  labelStyle: TextStyle(
                      color: (widget.darkMode ? Colors.white : Colors.black)),
                  floatingLabelStyle: const TextStyle(color: Colors.blue),
                  fillColor: (widget.darkMode ? Colors.black45 : null),
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
                controller: newMesssageController,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text("Add"),
                    onPressed: () {
                      newMessage['message'] = newMesssageController.text;
                      widget.messageObject.add(newMessage);
                      widget.messageObject = correctID(widget.messageObject);
                      // print(messageObject);
                      Navigator.pop(context,
                          widget.messageObject); //add messageobject here
                      InternalFiles.write(
                          json.encode(widget.messageObject), "main");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage()), // this mainpage is your page to refresh
                        (Route<dynamic> route) => false,
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.redAccent),
                    ),
                    onPressed: () {
                      // widget.messageList.remove(widget.messageMap);
                      // Navigator.of(context).pop(widget.messageList);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage()), // this mainpage is your page to refresh
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

correctID(messageObject) {
  for (int i = 0; i < messageObject.length; i++) {
    messageObject[i]["id"] = (i + 1).toString();
  }
  return messageObject;
}
