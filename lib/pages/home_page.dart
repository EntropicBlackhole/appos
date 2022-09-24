// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:appos/pages/settings_page.dart';
import 'package:appos/pages/edit_page.dart';
import 'package:appos/pages/add_page.dart';
import 'package:appos/api/storage_api.dart';
import 'package:appos/api/notification_api.dart';
import 'dart:convert';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<dynamic> messageObject = [];
  Map settings = {
    "interval_of_notification": 86400,
    "show_id": true,
    "dark_mode": false,
    "amount_of_priotization_of_hearted_messages": 5.0
  };
  Map settingsTemp = {};
  late final LocalNotificationService service;
  bool isNewTimer = false;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();
    super.initState();
    InternalFiles.read("main").then((value) {
      setState(() {
        if (value.isNotEmpty) {
          messageObject = json.decode(value);
        } else {
          messageObject = [
            {
              "message": "Hi there, welcome to Appos",
              "id": "1",
              "hearted": "true",
            },
            {
              "message": "Press the + button at the bottom to add a reminder",
              "id": "2",
              "hearted": "false",
            },
            {
              "message":
                  "You can long press a reminder to edit it, or delete it",
              "id": "3",
              "hearted": "true",
            },
            {
              "message":
                  "Hearted messages prioritization is not yet a feature, this will come in a future update",
              "id": "4",
              "hearted": "false",
            },
            {
              "message":
                  "Same goes for Dark Mode in Settings at the top right corner",
              "id": "5",
              "hearted": "true",
            }
          ];
        }
      });
    });
    InternalFiles.read("settings").then((value) {
      setState(() {
        if (value.isNotEmpty) {
          settings = json.decode(value);
          setNotifTimer();
          Timer.periodic(const Duration(seconds: 5), (timer) async {
            int beforeInterval = settings["interval_of_notification"];
            settings = json.decode(await InternalFiles.read("settings"));
            if (settings["interval_of_notification"] != beforeInterval) {
              isNewTimer = true;
            }
          });
          // var duration =
          //     Duration(seconds: settings["interval_of_notification"]);
          // Timer.periodic(duration, (timer) {
          //   temp(messageObject);
          //   print(timer);
          //   print(settings["interval_of_notification"]);
          // });
          // print('file exist!');
        } else {
          settings = {
            "interval_of_notification": 86400,
            "show_id": true,
            "dark_mode": false,
            "amount_of_priotization_of_hearted_messages": 5.0
          };
          InternalFiles.write(json.encode(settings), "settings");
          setNotifTimer();
          Timer.periodic(const Duration(seconds: 5), (timer) async {
            int beforeInterval = settings["interval_of_notification"];
            settings = json.decode(await InternalFiles.read("settings"));
            if (settings["interval_of_notification"] != beforeInterval) {
              isNewTimer = true;
            }
          });

          // var duration =
          //     Duration(seconds: settings["interval_of_notification"]);
          // Timer.periodic(duration, (timer) {
          //   temp(messageObject);
          //   print(timer);
          //   print(settings["interval_of_notification"]);
          // });
          // print('file does not exist');
        }
        print(settings.toString() + 'file');
      });
    });
    print(settings.toString() + '2');
    // var duration = Duration(seconds: settings["interval_of_notification"]);
    // Timer.periodic(duration, (timer) {
    //   temp(messageObject);
    //   print(timer);
    //   print(settings["interval_of_notification"]);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("lib/assets/images/background.jpg"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        drawer: Drawer(
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromARGB(255, 119, 190, 248),
                  Color.fromARGB(255, 182, 96, 231),
                ])),
                child: ListView(
                  children: <Widget>[
                    //drawer stuffs
                  ],
                ),
              ),
              ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.add_circle),
                    title: Text('Add'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddPage(messageObject: messageObject),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Help'),
                    onTap: () => showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text("About Appos:"),
                        content: const SingleChildScrollView(
                          child: Text(
                              "This app is designed to remind you of positive messages\n\nTo add a message, click the add button in the bottom right corner, and add your desired message\n\nTo edit a message, long press the message and edit it to your liking\n\nTo delete a message, long press the message and press on delete\n\nA hearted message has priority over the unhearted ones when sending a positive message"),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SettingsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Appos: Positivity"),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(20),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text("About Appos:"),
                  content: const SingleChildScrollView(
                    child: Text(
                        "I made this app as an anniversary gift for my girlfriend as she inspired me to make this, by suggesting I'd do it on my laptop, however this has actually started helping me, so I decided I'd turn it into an app!!\n\nI love you so much my Remote<3\nThank you for being here with me for over a year now, you're really the most special part of my life aren't you<3\n<3"),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'OK'),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ),
              child: const Icon(
                Icons.info_outline_rounded,
                color: Colors.white,
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.save),
            //   onPressed: () async {
            //     InternalFiles.write(json.encode(messageObject), "main");
            //   },
            // ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddPage(messageObject: messageObject),
                ),
              );
            },
            child: const Icon(Icons.add)),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 100,
            child: Stack(
              children: [
                ListView(
                  children: messageObject
                      .map<Widget>(
                        (e) => ListTile(
                          title: Text(e['message']),
                          subtitle: (settings['show_id'])
                              ? Text("#${e['id']}")
                              : null,
                          trailing: IconButton(
                            onPressed: () {
                              setState(() {
                                e['hearted'] =
                                    (e['hearted'] == 'true') ? 'false' : 'true';
                              });
                              InternalFiles.write(
                                  json.encode(messageObject), "main");
                            },
                            icon: Icon(
                              (e["hearted"] == 'true')
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            color: (e["hearted"] == 'true') ? Colors.red : null,
                          ),
                          onLongPress: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPage(
                                    messageMap: e, messageList: messageObject),
                              ),
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  setNotifTimer() async {
    Map _settings = json.decode(await InternalFiles.read("settings"));
    int notifInterval = _settings["interval_of_notification"];
    var duration = Duration(seconds: _settings["interval_of_notification"]);
    Timer.periodic(duration, (timer) async {
      Map _settings = json.decode(await InternalFiles.read("settings"));
      List _bodies = json.decode(await InternalFiles.read("main"));
      service.showRandomNotification(id: 0, title: "Appos", bodies: _bodies, heartPriority: _settings["amount_of_priotization_of_hearted_messages"]);
      if (isNewTimer) {
        timer.cancel();
        isNewTimer = false;
        setNotifTimer();
      }
    });
  }
}
