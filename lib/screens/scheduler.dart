import 'package:flutter/material.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/screens/grouppicker.dart';

import 'package:smart_home/models/employee.dart';
import 'package:hive/hive.dart';
import 'package:smart_home/screens/add_edit.dart';

import 'package:smart_home/screens/schedulepicker.dart';
import 'package:smart_home/screens/screens.dart';
import 'package:smart_home/widgets/top_header.dart';

int edit_toggle;
var dalicmd;

var edit_id;
int j;
int my_new;
bool result;

var toggle;
var num;
var num1;
var edit;
List<int> card_id = List.filled(150, 0);
void main() => runApp(MyApp1());

class MyApp1 extends StatelessWidget {
// This widget is the root
// of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: "My Schedules",
        theme: new ThemeData(primarySwatch: Colors.blue),
        debugShowCheckedModeBanner: false,
        home: EmployeesListScreen());
  }
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Zones"),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DropDownApp()));
    },
  );
  Widget noButton = FlatButton(
    child: Text("Groups"),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DropDownApp1()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Scheduler"),
    content: Text("Zone Addressing or Group Addressing ?"),
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

class EmployeesListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return EmployeesListState();
  }
}

class EmployeesListState extends State<EmployeesListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //getEmployees();
    return new WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
          title: Text("My Schedules"),
          leading: BackButton(
            onPressed: () {
              dynamo_flag = 1;
              fetch_flag = 0;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          actions: <Widget>[],
        ),
        body: Container(
            padding: EdgeInsets.all(15),
            child: ValueListenableBuilder(
                valueListenable: sc_ui_update,
                builder: (context, value, child) {
                  try {
                    for (j = 0; j < listEmployees.length; j++) {
                      my_new = j;
                      for (int s = 0; s < deletedId.length; s++) {
                        if (listEmployees[j].empId == deletedId[s]) {
                          listEmployees.removeAt(j);
                        }
                      }
                    }
                  } catch (e) {}

                  return ListView.builder(
                      itemCount: listEmployees.length,
                      itemBuilder: (context, position) {
                        Employee getEmployee = listEmployees[position];
                        try {} catch (e) {}
                        num = position;

                        var salary = getEmployee.empSalary;
                        var age = getEmployee.empAge;

                        return Card(
                          color: Colors.black54,
                          elevation: 8,
                          child: Container(
                            height: 80,
                            padding: EdgeInsets.all(15),
                            child: Stack(
                              children: <Widget>[
                                Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(getEmployee.empName,
                                        // '$device_name',
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white))),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 75),
                                    child: SwitchScreen(
                                      Editor_id: position,
                                      Editor_stat: getEmployee.scstat,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    margin: EdgeInsets.only(right: 40),
                                    child: IconButton(
                                        icon: Icon(Icons.edit),
                                        color: Colors.white,
                                        onPressed: () {
                                          edit = position;
                                          edit_id = getEmployee.empId;
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      EditScreen()));
                                          // AddOrEditEmployeeScreen(true,
                                          //     position, getEmployee)));
                                        }),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Colors.white,
                                      onPressed: () {
                                        /// TO LOCAL HTTP
                                        publish(
                                            '{"sc_id": ${getEmployee.empId} ,"sc_cmd":"0", "dali_cmd":"0" , "dali_data":"0", "dali_addr":"0", "sc_repeat":"0", "sc_destination_addr": "0", "sc_hour": "0", "sc_min": "0" ,"sc_status": "0","dev_status": "0","sc_name":"0"}',
                                            "679303000/schedule_test");
                                        num = position;
                                      }),
                                ),
                                Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text("Status: $salary | Time: $age",
                                        //Text("Status: $device_status | Time: $device_hour:$device_min",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.white))),
                              ],
                            ),
                          ),
                        );
                      });
                })),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.blue,
            size: 40,
          ),
          backgroundColor: Colors.black54,
          onPressed: () {
            showAlertDialog(context);
          },
        ),
      )),
    );
  }
}

//SwitchScreen SWitchScreen1;
class SwitchScreen extends StatefulWidget {
  @override
  SwitchClass createState() => new SwitchClass();
  var Editor_id;
  var Editor_stat;
  SwitchScreen({@required this.Editor_id, @required this.Editor_stat});
}

class SwitchClass extends State<SwitchScreen> {
  bool isSwitched = result;
  var textValue = 'Switch is OFF';
  void toggleSwitch(bool value) {
    var dummy_stat = "0";
    print("enterd swtch");
    int a = widget.Editor_id;
    edit_toggle = a;
    String timefrmt = listEmployees[a].empAge;
    String hourval = timefrmt.split(":")[0];
    String minval = timefrmt.split(":")[1];
    if ("${listEmployees[a].empSalary}" == 'On') {
      dalicmd = 208;
    } else if ("${listEmployees[a].empSalary}" == 'Off') {
      dalicmd = 212;
    } else {
      dalicmd = 201;
    }

    if (widget.Editor_stat == "1") {
      dummy_stat = "0";
    } else {
      dummy_stat = "1";
    }
    /// TO LOCAL HTTP
    publish(
        '{"sc_id": ${listEmployees[a].empId},"sc_name":"${listEmployees[a].empName}", "sc_cmd":"3", "dali_cmd":"$dalicmd" , "dali_data":"${listEmployees[a].dalidata}", "dali_addr":"${listEmployees[a].daliaddr}", "sc_repeat":"${listEmployees[a].screpeat}", "sc_destination_addr": "${listEmployees[a].scdestaddr}", "sc_hour": "$hourval", "sc_min": "$minval" ,"sc_status":"$dummy_stat","dev_status":"${listEmployees[a].empSalary}" }',
        "679303000/schedule_test");
  }

  @override
  Widget build(BuildContext context) {
    if (widget.Editor_stat == "1") {
      isSwitched = true;
    } else {
      isSwitched = false;
    }

    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Transform.scale(
          scale: 1,
          child: Switch(
            onChanged: toggleSwitch,
            value: isSwitched,
            activeColor: Colors.blue,
            activeTrackColor: Colors.blue[200],
            inactiveThumbColor: Colors.blue,
            inactiveTrackColor: Colors.grey,
          )),
    ]);
  }
}
