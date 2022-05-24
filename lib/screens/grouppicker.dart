import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:smart_home/main.dart';
import 'package:smart_home/models/employee.dart';
import 'package:smart_home/screens/scheduler.dart';

//
var status;
var op_cmd_dis1;
var operation_cmd1;
var dev1_name;
var scn_name;
int hour1;
String Hour1;
String Min1;
int min1;
Duration initialtimer1 = new Duration();

class DropDownApp1 extends StatefulWidget {
  @override
  createState() => _DropDownAppState1();
}

class _DropDownAppState1 extends State<DropDownApp1> {
  List zoneslist1 = List();
  List devicesList = List();
  List scenesList = List();
  List levelList = List();
  List levelList1 = List();
  List optionList = List();
  List tempList = List();
  List tempList1 = List();
  List tempList2 = List();
  static String net;

  String net1;

  static String _state;
  String _province;
  String _level;
  String _option;
  String _scene;
  double _currentSliderValue = 50;

  Future<String> loadStatesProvincesFromFile() async {
    return await rootBundle.loadString('assets/user.json');
  }

  Future<String> _populateDropdown() async {
    String getPlaces = await loadStatesProvincesFromFile();
    final jsonResponse = json.decode(getPlaces);

    Localization places = new Localization.fromJson(jsonResponse);

    setState(() {
      zoneslist1 = places.states;
      devicesList = places.provinces;
      levelList = places.levels;
      optionList = places.options;
      scenesList = places.scenes;
    });
  }

  @override
  void initState() {
    super.initState();
    this._populateDropdown();
  }

  Widget build(BuildContext context) {
    // TODO: implement build

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Group Addressing'),
        ),
        body: Container(
          child: new Form(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 28),
              child: new Container(
                width: 350,
                child: Column(
                  children: <Widget>[
                    // new TextFormField(
                    //   keyboardType: TextInputType.emailAddress,
                    //   decoration: const InputDecoration(
                    //     icon: const Icon(Icons.email),
                    //     hintText: 'Type your name',
                    //     labelText: 'Name',
                    //   ),
                    // ),
                    new DropdownButton(
                      isExpanded: true,
                      icon: const Icon(Icons.gps_fixed),
                      items: zoneslist1.map((item) {
                        net = item.name;
                        return new DropdownMenuItem(
                          child: new Text(net),
                          value: item.zid.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _level = null;
                          _province = null;
                          _state = newVal;
                          tempList1 = optionList;

                          for (int i = 0; i < zoneslist1.length; i++) {
                            if (zoneslist1[i].zid == int.parse(_state)) {
                              dev1_name = zoneslist1[i].name;
                            }
                          }
                        });
                      },
                      value: _state,
                      hint: Text(
                        'Select a Group',
                        style: TextStyle(color: Colors.black.withOpacity(.3)),
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    DropdownButton(
                      isExpanded: true,
                      icon: const Icon(Icons.add),
                      items: tempList1.map((item) {
                        net1 = item.name;
                        return new DropdownMenuItem(
                          child: new Text(item.name),
                          value: item.lid.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _option = newVal;
                          if (_option == "1") {
                            tempList2 = levelList;
                          } else {
                            _currentSliderValue = 0;
                            tempList2 = levelList1;
                            tempList = scenesList;
                          }
                        });
                      },
                      value: _option,
                      hint: Text(
                        'Devices or Scenes ?',
                        style: TextStyle(color: Colors.black.withOpacity(.3)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    DropdownButton(
                      isExpanded: true,
                      // isDense: false,
                      icon: const Icon(Icons.add_location),
                      items: tempList.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item.name),
                          value: item.lid.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          _province = newVal;
                          for (int i = 0; i < tempList.length; i++) {
                            if (tempList[i].lid == int.parse(_province)) {
                              scn_name = tempList[i].name;
                            }
                          }
                        });
                      },
                      value: _province,
                      hint: Text(
                        'Select a scene ',
                        style: TextStyle(color: Colors.black.withOpacity(.3)),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    DropdownButton(
                      isExpanded: true,
                      icon: const Icon(Icons.power_settings_new),
                      items: tempList2.map((item) {
                        return new DropdownMenuItem(
                          child: new Text(item.data),
                          value: item.lid.toString(),
                        );
                      }).toList(),
                      onChanged: (newVal) {
                        setState(() {
                          setState(() {
                            _level = newVal;
                            if (_level == '1') {
                              operation_cmd1 = 208;
                              op_cmd_dis1 = "On";

                              _currentSliderValue = 100;
                            } else if (_level == "2") {
                              operation_cmd1 = 212;
                              op_cmd_dis1 = "Off";
                              _currentSliderValue = 0;
                            } else {
                              _currentSliderValue = 50;
                            }
                          });
                        });
                      },
                      value: _level,
                      hint: Text(
                        'Operation State',
                        style: TextStyle(color: Colors.black.withOpacity(.3)),
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Slider(
                      value: _currentSliderValue,
                      min: 0,
                      max: 100,
                      divisions: 100,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          if (_option == "1") {
                            if (_level == '1') {
                              _currentSliderValue = 100;
                            } else if (_level == "2") {
                              _currentSliderValue = 0;
                            } else {
                              _currentSliderValue = value;
                              operation_cmd1 = _currentSliderValue;
                              var y = value.toInt();
                              op_cmd_dis1 = "$y";
                            }
                          } else {
                            _currentSliderValue = 0;
                          }
                        });
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: CupertinoTimerPicker(
                        mode: CupertinoTimerPickerMode.hm,
                        minuteInterval: 1,
                        secondInterval: 1,
                        initialTimerDuration: initialtimer1,
                        onTimerDurationChanged: (Duration changedtimer) {
                          setState(() {
                            initialtimer1 = changedtimer;
                          });
                          String rawData = initialtimer1.toString();
                          Hour1 = rawData.split(":")[0];
                          Min1 = rawData.split(":")[1];
                          hour1 = int.parse(rawData.split(":")[0]);
                          min1 = int.parse(rawData.split(":")[1]);
                        },
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),

                    Material(
                      child: ElevatedButton(
                          onPressed: () {
                            status = true;
                            showAlertDialog(context);
                          },
                          child: Text("ADD")),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Localization {
  final List<Provinces> provinces;
  final List<States> states;
  final List<Level> levels;
  final List<Level1> levels1;
  final List<Option> options;
  final List<Scene> scenes;
  Localization(
      {this.provinces,
      this.states,
      this.levels,
      this.options,
      this.scenes,
      this.levels1});

  factory Localization.fromJson(Map<String, dynamic> json) {
    return Localization(
      states: parseStates(json),
      provinces: parseProvinces(json),
      levels: parseLevel(json),
      options: parseOption(json),
      scenes: parseScene(json),
    );
  }

  static List<States> parseStates(statesJson) {
    var slist = statesJson['group'] as List;
    List<States> zoneslist1 =
        slist.map((data) => States.fromJson(data)).toList();
    return zoneslist1;
  }

  static List<Provinces> parseProvinces(provincesJson) {
    var plist = provincesJson['emptylist'] as List;
    List<Provinces> devicesList =
        plist.map((data) => Provinces.fromJson(data)).toList();
    return devicesList;
  }

  static List<Level> parseLevel(levelsJson) {
    var llist = levelsJson['level'] as List;
    List<Level> levelList = llist.map((data) => Level.fromJson(data)).toList();
    return levelList;
  }

  static List<Level1> parseLevel1(levels1Json) {
    var llist = levels1Json['level1'] as List;
    List<Level1> levelList1 =
        llist.map((data) => Level1.fromJson(data)).toList();
    return levelList1;
  }

  static List<Option> parseOption(optionsJson) {
    var olist = optionsJson['option'] as List;
    List<Option> optionList =
        olist.map((data) => Option.fromJson(data)).toList();
    return optionList;
  }

  static List<Scene> parseScene(scenesJson) {
    var nlist = scenesJson['scenes'] as List;
    List<Scene> scenesList = nlist.map((data) => Scene.fromJson(data)).toList();
    return scenesList;
  }
}

class States {
  final int zid;
  final String name;

  States({this.zid, this.name});

  factory States.fromJson(Map<String, dynamic> parsedJson) {
    return States(zid: parsedJson['zid'], name: parsedJson['name']);
  }
}

class Provinces {
  final int lid;
  final String name;
  final int stateId;

  Provinces({this.lid, this.name, this.stateId});

  factory Provinces.fromJson(Map<String, dynamic> parsedJson) {
    return Provinces(
        lid: parsedJson['lid'],
        name: parsedJson['name'],
        stateId: parsedJson['state_id']);
  }
}

class Level1 {
  final String data;
  final int lid;

  Level1({
    this.data,
    this.lid,
  });
  factory Level1.fromJson(Map<String, dynamic> parsedJson) {
    return Level1(
      lid: parsedJson['lid'],
      data: parsedJson['data'],
    );
  }
}

class Level {
  final String data;
  final int lid;

  Level({
    this.data,
    this.lid,
  });
  factory Level.fromJson(Map<String, dynamic> parsedJson) {
    return Level(
      lid: parsedJson['lid'],
      data: parsedJson['data'],
    );
  }
}

class Scene {
  final String name;
  final int lid;
  final int stateId;
  Scene({
    this.name,
    this.lid,
    this.stateId,
  });
  factory Scene.fromJson(Map<String, dynamic> parsedJson) {
    return Scene(
        lid: parsedJson['lid'],
        name: parsedJson['name'],
        stateId: parsedJson['state_id']);
  }
}

class Option {
  final String name;
  final int lid;
  Option({
    this.name,
    this.lid,
  });
  factory Option.fromJson(Map<String, dynamic> parsedJson) {
    return Option(
      lid: parsedJson['lid'],
      name: parsedJson['name'],
    );
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Yes"),
    onPressed: () async {
      Employee addEmployee = new Employee(
          empName: dev1_name, empSalary: op_cmd_dis1, empAge: "$Hour1:$Min1");
      var box = await Hive.openBox<Employee>('employee');
      box.add(addEmployee);
      /// TO LOCAL HTTP
      publish(
          '{"gateway": "gateway", "lid":devices,"cmd":$operation_cmd1,"data":$operation_cmd1, "hour": $hour1, "min": $min1 ,"status":"$status" }',
          "pattambi/gatewayM");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyApp1()));
    },
  );
  Widget noButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Scheduler"),
    content: Text("Confirm new schedule ?"),
    actions: [
      okButton,
      noButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
