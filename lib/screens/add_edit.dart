// import 'package:flutter/material.dart';
// import 'package:smart_home/models/employee.dart';
// import 'package:smart_home/screens/scheduler.dart';
// import 'package:hive/hive.dart';
// import 'package:smart_home/screens/schedulepicker.dart';
//
// var getEmpName;
// var name1;
// bool isEdit;
// int position;
// Employee employeeModel;
//
// class AddOrEditEmployeeScreen extends StatefulWidget {
//   bool isEdit;
//   int position;
//   Employee employeeModel;
//
//   AddOrEditEmployeeScreen(this.isEdit, [this.position, this.employeeModel]);
//
//   @override
//   State<StatefulWidget> createState() {
//     return AddEditEmployeeState();
//   }
// }
//
// class AddEditEmployeeState extends State<AddOrEditEmployeeScreen> {
//   TextEditingController controllerName = new TextEditingController();
//   TextEditingController controllerSalary = new TextEditingController();
//   TextEditingController controllerAge = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     if (widget.isEdit) {
//       print("Point 1");
//       controllerName.text = widget.employeeModel.empName;
//       name1 = controllerName.text;
//       controllerSalary.text = widget.employeeModel.empSalary.toString();
//       controllerAge.text = widget.employeeModel.empAge.toString();
//     }
//
//     return SafeArea(
//       child: Scaffold(
//           body: SingleChildScrollView(
//         child: Container(
//           margin: EdgeInsets.all(25),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Text("Device Name:", style: TextStyle(fontSize: 18)),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: TextField(controller: controllerName),
//                   )
//                 ],
//               ),
//               SizedBox(height: 60),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Text("Status:", style: TextStyle(fontSize: 18)),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: TextField(
//                         controller: controllerSalary,
//                         keyboardType: TextInputType.number),
//                   )
//                 ],
//               ),
//               SizedBox(height: 60),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: <Widget>[
//                   Text("Time:", style: TextStyle(fontSize: 18)),
//                   SizedBox(width: 20),
//                   Expanded(
//                     child: TextField(
//                         controller: controllerAge,
//                         keyboardType: TextInputType.number),
//                   )
//                 ],
//               ),
//               SizedBox(height: 100),
//               RaisedButton(
//                 color: Colors.grey,
//                 child: Text("Submit",
//                     style: TextStyle(color: Colors.white, fontSize: 18)),
//                 onPressed: () async {
//                   getEmpName = controllerName.text;
//                   var getEmpSalary = controllerSalary.text;
//                   var getEmpAge = controllerAge.text;
//                   if (getEmpName.isNotEmpty &&
//                       getEmpSalary.isNotEmpty &&
//                       getEmpAge.isNotEmpty) {
//                     if (widget.isEdit) {
//                       Employee updateEmployee = new Employee(
//                           empName: getEmpName,
//                           empSalary: getEmpSalary,
//                           empAge: getEmpAge);
//                       var box = await Hive.openBox<Employee>('employee');
//                       box.putAt(widget.position, updateEmployee);
//                     } else {
//                       print("point 2");
//                       Employee addEmployee = new Employee(
//                           empName: "Athul", empSalary: '25', empAge: getEmpAge);
//                       var box = await Hive.openBox<Employee>('employee');
//                       box.add(addEmployee);
//                     }
//                     Navigator.pushAndRemoveUntil(
//                         context,
//                         MaterialPageRoute(
//                             builder: (_) => EmployeesListScreen()),
//                         (r) => true);
//                   }
//                 },
//               )
//             ],
//           ),
//         ),
//       )),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
//import 'dart:io';
import 'package:smart_home/main.dart';
import 'package:smart_home/screens/add_edit.dart';
import 'package:smart_home/screens/schedulepicker.dart';
import 'package:smart_home/screens/scheduler.dart';
import 'package:smart_home/models/employee.dart';
import 'package:hive/hive.dart';
import 'package:smart_home/widgets/top_header.dart';

import 'home_screen.dart';

var gatewayid;

var dev_name;
bool isChecked = true;
var sc_repeat = isChecked;
var sc_repeat_val = 0;
bool isChecked1 = false;

var op_cmd_dis;
var op_cmd_dis_val;
var operation_cmd;
var operation_cmd1;
var status;
int hour;
String Hour;
String Min;
int min;
var dev;
var name;
var gateway;
var devices;
Duration initialtimer = new Duration();
Employee employeeModel;

class EditScreen extends StatefulWidget {
  @override
  createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  List zoneslist = List();
  List devicesList = List();
  List scenesList = List();
  List levelList = List();
  List levelList1 = List();
  List optionList = List();
  List tempList = List();
  List tempList1 = List();
  List tempList2 = List();

  List curtainList = List();
  List sprinklerList = List();
  List fanList = List();

  static String net;

  String net1;
  String net2 = "Selection";

  static String _state;
  String _province;
  String _level;
  String _option;
  String _scene;
  double _currentSliderValue = 50;

  Future<String> loadStatesProvincesFromFile() async {
    File fileSchJson = File(
        '/storage/emulated/0/Android/data/com.ligero.lihome/files/sch.json');
    final contentsch = await fileSchJson.readAsString();

    return contentsch;
  }

  Future<String> _populateDropdown() async {
    String getPlaces = await loadStatesProvincesFromFile();
    final jsonResponse = json.decode(getPlaces);
    States gate = new States.fromJson(jsonResponse);
    print(gate.name);
    Localization places = new Localization.fromJson(jsonResponse);

    setState(() {
      zoneslist = places.states;
      devicesList = places.provinces;
      levelList = places.levels;
      // levelList1 = places.levels1;
      optionList = places.options;
      scenesList = places.scenes;
      curtainList = places.curtainlist;
      sprinklerList = places.sprinklerlist;
      fanList = places.fanlist;
    });
  }

  @override
  void initState() {
    super.initState();
    this._populateDropdown();
  }

  Widget build(BuildContext context) {
    // print(zoneslist);

    return new WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MyApp1()));
        return false;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: BackButton(
              color: Colors.white,
              onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EmployeesListScreen())),
              },
            ),
            title: Text('Edit Schedule'),
          ),
          body: Container(
            child: new Form(
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, left: 28),
                child: new Container(
                  width: 350,
                  child: Column(
                    children: <Widget>[
                      new DropdownButton(
                        isExpanded: true,
                        icon: const Icon(Icons.gps_fixed),
                        items: zoneslist.map((item) {
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
                            print(newVal);
                            var num = int.parse(_state);
                            gateway = zoneslist[num].gatesub;
                            tempList2 = levelList;

                            tempList = devicesList
                                .where((x) =>
                                    x.stateId.toString() == (_state.toString()))
                                .toList();
                          });
                        },
                        value: _state,
                        hint: Text(
                          'Select a Zone',
                          style:
                              TextStyle(color: Colors.black.withOpacity(0.3)),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      DropdownButton(
                        isExpanded: true,
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
                            devices = _province;
                            var num1 = int.parse(_province);
                            for (int i = 0; i < tempList.length; i++) {
                              if (tempList[i].lid == int.parse(_province)) {
                                dev_name = tempList[i].name;
                                gatewayid = tempList[i].gatewayid;
                                if (tempList[i].devId == 1) {
                                  tempList2 = levelList;
                                } else if (tempList[i].devId == 2) {
                                  tempList2 = curtainList;
                                } else if (tempList[i].devId == 3) {
                                  tempList2 = sprinklerList;
                                } else if (tempList[i].devId == 4) {
                                  tempList2 = fanList;
                                }
                              }
                            }
                          });
                        },
                        value: _province,
                        hint: Text(
                          "Select a device",
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
                            _level = newVal;

                            /// for light on
                            if (_level == '1000') {
                              operation_cmd = 208;
                              op_cmd_dis = "On";
                              op_cmd_dis_val = 0;
                              _currentSliderValue = 100;
                            }

                            ///for light off
                            else if (_level == "1001") {
                              operation_cmd = 212;
                              op_cmd_dis = "Off";
                              op_cmd_dis_val = 100;
                              _currentSliderValue = 0;
                            }

                            ///for sprinkler on
                            else if (_level == "100") {
                              operation_cmd = 205;
                              op_cmd_dis = "On";
                              op_cmd_dis_val = 100;
                              _currentSliderValue = 100;
                            }

                            ///for sprinkler off
                            else if (_level == "0") {
                              operation_cmd = 205;
                              op_cmd_dis = "Off";
                              op_cmd_dis_val = 0;
                              _currentSliderValue = 0;
                            }

                            ///curtain open
                            else if (_level == "203") {
                              operation_cmd = 203;
                              op_cmd_dis = "Open";
                              op_cmd_dis_val = 0;
                              _currentSliderValue = 100;
                            }

                            ///shutter toggle
                            else if (_level == "204") {
                              op_cmd_dis = "Toggle";
                              operation_cmd = 204;
                              op_cmd_dis_val = 100;
                              _currentSliderValue = 0;
                            }

                            /// for curtain goto
                            else if (_level == "202") {
                              operation_cmd = 202;
                              _currentSliderValue = 30;
                            } else if (_level == "150") {
                              operation_cmd = 100;
                              _currentSliderValue = 50;
                            }

                            /// lights go to
                            else if (_level == '201') {
                              operation_cmd = 201;
                              _currentSliderValue = 20;

                              op_cmd_dis_val = _currentSliderValue;
                            }

                            ///for scene scheduling
                            else {
                              operation_cmd = 234;
                              op_cmd_dis_val = _level;
                              int w = int.parse(_level);

                              op_cmd_dis = levelList[w + 3].data;
                            }
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
                            if (_level == '1000' || _level == '100') {
                              _currentSliderValue = 100;
                            } else if (_level == "1001" || _level == '0') {
                              _currentSliderValue = 0;
                            } else if (_level == "204") {
                              _currentSliderValue = 50;
                            } else if (_level == "205") {
                              _currentSliderValue = value;
                            } else if (_level == '201') {
                              _currentSliderValue = value;
                            } else {
                              _currentSliderValue = 50;
                            }
                          });
                        },
                        onChangeEnd: (value) {
                          setState(() {
                            if (_level == '1000' || _level == '100') {
                              _currentSliderValue = 100;
                              operation_cmd1 = _currentSliderValue;
                            } else if (_level == "1001" || _level == '0') {
                              _currentSliderValue = 0;
                              operation_cmd1 = _currentSliderValue;
                            }

                            ///for shutter toggle
                            else if (_level == "204") {
                              _currentSliderValue = 50;
                            }

                            ///for curtain goto
                            else if (_level == "202") {
                              operation_cmd1 = _currentSliderValue;
                              var y = value.toInt();
                              operation_cmd = 202;
                              op_cmd_dis = "$y";
                              op_cmd_dis_val = "$y";
                            }

                            ///for fan goto
                            else if (_level == "150") {
                              operation_cmd1 = _currentSliderValue;
                              var y = value.toInt();
                              operation_cmd = 100;
                              op_cmd_dis = "$y";
                              op_cmd_dis_val = "$y";
                            } else if (_level == '201') {
                              _currentSliderValue = value;
                              operation_cmd1 = _currentSliderValue;
                              var y = value.toInt();
                              operation_cmd = 201;
                              op_cmd_dis = "$y";
                              op_cmd_dis_val = "$y";
                            } else {
                              _currentSliderValue = 50;
                              operation_cmd1 = _currentSliderValue;
                              operation_cmd = 234;
                              op_cmd_dis_val = _level;
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
                          initialTimerDuration: initialtimer,
                          onTimerDurationChanged: (Duration changedtimer) {
                            setState(() {
                              initialtimer = changedtimer;
                            });
                            String rawData = initialtimer.toString();
                            Hour = rawData.split(":")[0];
                            Min = rawData.split(":")[1];
                            hour = int.parse(rawData.split(":")[0]);
                            min = int.parse(rawData.split(":")[1]);
                          },
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Container(
                          child: DropdownButton(
                        items: [
                          DropdownMenuItem(
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isChecked = value;
                                      sc_repeat = isChecked;
                                      if (sc_repeat == true) {
                                        sc_repeat_val = 0;
                                      } else {
                                        sc_repeat_val = 1;
                                      }
                                      isChecked1 = false;
                                      print("Value1 is:$isChecked");
                                      print("Repeat Stat:$sc_repeat_val");
                                    });
                                  },
                                ),
                                Text('Once'),
                                Checkbox(
                                  value: isChecked1,
                                  onChanged: (bool value) {
                                    setState(() {
                                      isChecked1 = value;
                                      sc_repeat = isChecked1;
                                      if (sc_repeat == true) {
                                        sc_repeat_val = 1;
                                      } else {
                                        sc_repeat_val = 0;
                                      }
                                      isChecked = false;
                                    });
                                  },
                                ),
                                Text('Daily'),
                              ],
                            ),
                          ),
                        ],
                      )),
                      Material(
                        child: ElevatedButton(
                            onPressed: () {
                              status = 1;
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
  final List<CurtainList> curtainlist;
  final List<FanList> fanlist;
  final List<SprinklerList> sprinklerlist;
  Localization(
      {this.provinces,
      this.states,
      this.levels,
      this.options,
      this.scenes,
      this.curtainlist,
      this.fanlist,
      this.sprinklerlist,
      this.levels1});

  factory Localization.fromJson(Map<String, dynamic> json) {
    return Localization(
      states: parseStates(json),
      provinces: parseProvinces(json),
      levels: parseLevel(json),
      options: parseOption(json),
      scenes: parseScene(json),
      sprinklerlist: parseSprinklerList(json),
      fanlist: parseFanList(json),
      curtainlist: parseCurtainList(json),
    );
  }

  static List<States> parseStates(statesJson) {
    var slist = statesJson['data'] as List;
    List<States> zoneslist =
        slist.map((data) => States.fromJson(data)).toList();
    return zoneslist;
  }

  static List<Provinces> parseProvinces(provincesJson) {
    var plist = provincesJson['provinces'] as List;
    List<Provinces> devicesList =
        plist.map((data) => Provinces.fromJson(data)).toList();
    return devicesList;
  }

  static List<Level> parseLevel(levelsJson) {
    var llist = levelsJson['level'] as List;
    List<Level> levelList = llist.map((data) => Level.fromJson(data)).toList();
    return levelList;
  }

  static List<CurtainList> parseCurtainList(curtainlistJson) {
    var clist = curtainlistJson['curtainlist'] as List;
    List<CurtainList> curtainlist =
        clist.map((data) => CurtainList.fromJson(data)).toList();
    return curtainlist;
  }

  static List<SprinklerList> parseSprinklerList(sprinklerlistJson) {
    var splist = sprinklerlistJson['sprinklerlist'] as List;
    List<SprinklerList> sprinklerlist =
        splist.map((data) => SprinklerList.fromJson(data)).toList();
    return sprinklerlist;
  }

  static List<FanList> parseFanList(fanlistJson) {
    var flist = fanlistJson['fanlist'] as List;
    List<FanList> fanlist =
        flist.map((data) => FanList.fromJson(data)).toList();
    return fanlist;
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
  final String gatesub;
  final String name;

  States({this.zid, this.name, this.gatesub});

  factory States.fromJson(Map<String, dynamic> parsedJson) {
    return States(
        zid: parsedJson['zid'],
        name: parsedJson['name'],
        gatesub: parsedJson['gatesub']);
  }
}

class Provinces {
  final int lid;
  final String name;
  final int stateId;
  final int devId;
  final String gatewayid;

  Provinces({this.lid, this.name, this.stateId, this.devId, this.gatewayid});

  factory Provinces.fromJson(Map<String, dynamic> parsedJson) {
    return Provinces(
        lid: parsedJson['lid'],
        name: parsedJson['name'],
        gatewayid: parsedJson['gateway_id'],
        devId: parsedJson['devID'],
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

///class for curtain operation sleection
class CurtainList {
  final String data;
  final int lid;

  CurtainList({
    this.data,
    this.lid,
  });
  factory CurtainList.fromJson(Map<String, dynamic> parsedJson) {
    return CurtainList(
      lid: parsedJson['lid'],
      data: parsedJson['data'],
    );
  }
}

class SprinklerList {
  final String data;
  final int lid;

  SprinklerList({
    this.data,
    this.lid,
  });
  factory SprinklerList.fromJson(Map<String, dynamic> parsedJson) {
    return SprinklerList(
      lid: parsedJson['lid'],
      data: parsedJson['data'],
    );
  }
}

class FanList {
  final String data;
  final int lid;

  FanList({
    this.data,
    this.lid,
  });
  factory FanList.fromJson(Map<String, dynamic> parsedJson) {
    return FanList(
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
  Widget okButton = FlatButton(
    child: Text("Yes"),
    onPressed: () async {
      if (edit == null) {
        num = 0;
      } else {
        edit = edit;
      }
      edit_sc_ui();
      publish(
          '{"sc_id": $edit_id,"sc_name":"$dev_name" , "sc_cmd": "2", "dali_cmd":"$operation_cmd" , "dali_data":"$op_cmd_dis_val", "dali_addr":"$devices", "sc_repeat":"$sc_repeat_val", "sc_destination_addr": "$gatewayid", "sc_hour": "$Hour", "sc_min": "$Min" ,"sc_status":"$status" ,"dev_status": "$op_cmd_dis"  }',
          "679303000/schedule_test");

      ///remove all routes pushed until MyApp1 reached
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => NavDrawer()),
          (Route<dynamic> route) => false);
    },
  );
  Widget noButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text("Scheduler"),
    content: Text("Confirm new schedule ?"),
    actions: [
      okButton,
      noButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void edit_sc_ui() async {
  Employee updateEmployee = new Employee(
    empName: '$light_name',
    empSalary: '$device_status',
    empAge: "$device_hour:$device_min",
    empId: device_name.toString(),
    dalidata: '$resp_dali_data',
    daliaddr: '$resp_dali_addr',
    screpeat: '$resp_sc_repeat',
    scdestaddr: '$resp_sc_dest_sddr',
    scstat: '$sc_stat1',
  );
  listEmployees[edit] = updateEmployee;
  sc_ui_update.value = !sc_ui_update.value;
}

void edit_sc_ui_for_toggle() async {
  Employee updateEmployee = new Employee(
    empName: '$light_name',
    empSalary: '$device_status',
    empAge: "$device_hour:$device_min",
    empId: device_name.toString(),
    dalidata: '$resp_dali_data',
    daliaddr: '$resp_dali_addr',
    screpeat: '$resp_sc_repeat',
    scdestaddr: '$resp_sc_dest_sddr',
    scstat: '$sc_stat1',
  );

  listEmployees[edit_toggle] = updateEmployee;

  sc_ui_update.value = !sc_ui_update.value;
}
