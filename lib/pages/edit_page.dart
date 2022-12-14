import 'package:flutter/material.dart';
import 'package:appos/pages/home_page.dart';
import 'package:appos/api/storage_api.dart';
import 'dart:convert';

// ignore: must_be_immutable
class EditPage extends StatefulWidget {
  Map messageMap = {};
  List messageList = [];
  bool darkMode = false;
  EditPage({Key? key, required this.messageMap, required this.messageList, required this.darkMode})
      : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  String controllerText = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("lib/assets/images/background${(widget.darkMode ? "_darkmode" : "")}.jpg"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: (widget.darkMode ? Colors.black12 : Colors.blue),
          title: Text("Edit: #${widget.messageMap['id'] ?? "ID missing"}"),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   type: BottomNavigationBarType.fixed,
        //   items: [
        //     BottomNavigationBarItem(
        //         icon: Icon(Icons.home),
        //         label: 'Home',
        //         tooltip: "Sends you to the home page"),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.add),
        //       label: 'Add',
        //       tooltip: "Sends you to the add page",
        //     ),
        //   ],
        // ),
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
                  label: const Text("Message"),
                  labelStyle: TextStyle(
                      color: (widget.darkMode ? Colors.white : Colors.black)),
                  floatingLabelStyle: const TextStyle(color: Colors.blue),
                  fillColor: (widget.darkMode ? Colors.black45 : null),
                  filled: true,
                  border: const OutlineInputBorder(),
                ),
                controller: TextEditingController(
                  text: widget.messageMap['message'],
                ),
                onChanged: (value) {
                  controllerText = value;
                },
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton(
                    child: const Text("Save"),
                    onPressed: () {
                      if (!(controllerText == '')) {
                        widget.messageMap['message'] = controllerText;
                      }
                      widget.messageList = correctID(widget.messageList);
                      Navigator.pop(context, widget.messageMap);
                      InternalFiles.write(
                          json.encode(widget.messageList), "main");
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
                      backgroundColor: MaterialStateProperty.all(Colors.red),
                    ),
                    onPressed: () {
                      widget.messageList.remove(widget.messageMap);
                      widget.messageList = correctID(widget.messageList);
                      InternalFiles.write(
                          json.encode(widget.messageList), "main");
                      Navigator.of(context).pop(widget.messageList);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage()), // this mainpage is your page to refresh
                        (Route<dynamic> route) => false,
                      );
                    },
                    child: const Text("Delete"),
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
