import 'package:flutter/material.dart';
import 'package:appos/pages/home_page.dart';
import 'package:appos/api/storage_api.dart';
import 'dart:convert';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

enum SingingCharacter { minute, hour, day, week }

class _SettingsPageState extends State<SettingsPage> {
  Map settings = {};
  double prioritization = 5.0;
  bool idShow = true;
  bool darkMode = true;
  int interval = 86400;
  SingingCharacter? _character = SingingCharacter.day;

  @override
  void initState() {
    super.initState();
    InternalFiles.read("settings").then((value) {
      setState(() {
        if (value.isNotEmpty) {
          settings = json.decode(value);
        } else {
          settings = {
            "interval_of_notification": 86400,
            "show_id": true,
            "dark_mode": false,
            "amount_of_priotization_of_hearted_messages": 5.0
          };
        }
        interval = settings['interval_of_notification'];
        prioritization = settings['amount_of_priotization_of_hearted_messages'];
        idShow = settings['show_id'];
        darkMode = settings['dark_mode'];
        if (interval == 60) _character = SingingCharacter.minute;
        if (interval == 3600) _character = SingingCharacter.hour;
        if (interval == 86400) _character = SingingCharacter.day;
        if (interval == 604800) _character = SingingCharacter.week;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("lib/assets/images/background.jpg"),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("Appos: Settings"),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Interval of notification:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "",
                    ),
                  ),
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('Every minute'),
                  value: SingingCharacter.minute,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      interval = 60;
                    });
                  },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('Hourly'),
                  value: SingingCharacter.hour,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      interval = 3600;
                    });
                  },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('Daily'),
                  value: SingingCharacter.day,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      interval = 86400;
                    });
                  },
                ),
                RadioListTile<SingingCharacter>(
                  title: const Text('Weekly'),
                  value: SingingCharacter.week,
                  groupValue: _character,
                  onChanged: (SingingCharacter? value) {
                    setState(() {
                      _character = value;
                      interval = 604800;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "Prioritization of hearted messages: ${prioritization.toInt().toString()}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "",
                    ),
                  ),
                ),
                Slider(
                  value: prioritization,
                  min: 1.0,
                  max: 10.0,
                  divisions: 9,
                  label: prioritization.toInt().toString(),
                  onChanged: (value) {
                    setState(() {
                      prioritization = value.toDouble();
                    });
                  },
                ),
                const Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Text(
                    "Other:",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "",
                    ),
                  ),
                ),
                SwitchListTile(
                  title: const Text("Show ID"),
                  value: idShow,
                  onChanged: (value) {
                    setState(() {
                      idShow = !idShow;
                    });
                  },
                ),
                SwitchListTile(
                  title: const Text("Dark mode"),
                  value: darkMode,
                  onChanged: (value) {
                    setState(() {
                      darkMode = value;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ElevatedButton(
                    onPressed: () {
                      settings['interval_of_notification'] = interval;
                      settings['amount_of_priotization_of_hearted_messages'] =
                          prioritization.toDouble();
                      settings['show_id'] = idShow;
                      settings['dark_mode'] = darkMode;
                      InternalFiles.write(json.encode(settings), "settings");
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const HomePage()), // this mainpage is your page to refresh
                        (Route<dynamic> route) => false,
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      ),
                      // foregroundColor: ,
                    ),
                    child: const Text("Save"),
                  ),
                )
              ],
            ),
          )),
    );
  }
}

zTrim(double x) {
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  return x.toString().replaceAll(regex, '');
}
