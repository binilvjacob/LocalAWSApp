import 'dart:io';
import 'dart:async';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/models.dart';
import 'package:smart_home/screens/lamppage.dart';
import 'package:smart_home/widgets/widgets.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/services.dart';
import 'package:smart_home/screens/scheduler.dart';

Timer toast_timer;

class HomeScreen extends StatelessWidget {
  static int roomIndex;
  List<RoomsModel> _listRooms = [
    RoomsModel(image: 'assets/images/lobby.jpg', name: 'Lobby', temp: '24'),
    RoomsModel(
        image: 'assets/images/livingroom.jpg', name: 'Lobby', temp: '25'),
    RoomsModel(
        image: 'assets/images/dining_area.png',
        name: 'Gnd Floor Dining',
        temp: '28'),
    RoomsModel(
        image: 'assets/images/gndfloormaster.jpg',
        name: 'Gnd.F Master',
        temp: '27'),
    RoomsModel(image: 'assets/images/bedr3.jpg', name: 'Gnd Bed 2', temp: '27'),
    RoomsModel(
        image: 'assets/images/lvngroom.jpg',
        name: 'Frst Floor hall',
        temp: '27'),
    RoomsModel(
        image: 'assets/images/bedroom5.jfif',
        name: 'Frst Master  Bedroom',
        temp: '28'),
    RoomsModel(
        image: 'assets/images/frstfloormaster.jpg',
        name: 'Frst Floor bed2',
        temp: '27'),
    RoomsModel(
        image: 'assets/images/bed2.jpg', name: 'Frst f bed 3', temp: '27'),
    RoomsModel(
        image: 'assets/images/kitchen.jpg', name: 'testroom', temp: '27'),
    RoomsModel(
        image: 'assets/images/kitchen.jpg', name: 'testroom', temp: '27'),
  ];

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;

    ///message on disabling back button
    return new WillPopScope(
      onWillPop: () async {
        Fluttertoast.showToast(
          msg: 'Press Home to Exit!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        // //Colors.blueGrey[900],
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TopHeader(),
                SizedBox(
                  height: _height * 0.05,
                ),
                textCate(nameCate: 'Zones'),
                SizedBox(
                  height: 60,
                ),
                Container(
                  // decoration: BoxDecoration(
                  //   image: DecorationImage(
                  //     image: AssetImage("assets/images/tv.png"),
                  //     fit: BoxFit.fill,
                  //   ),
                  // ),
                  height: _height * 0.6,
                  child: FutureBuilder<String>(
                      future: test(),
                      initialData: "athul",
                      builder: (context, snapshot) {
                        tmp_snap = snapshot;

                        if (snapshot.hasData) {
                          return ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: ourList?.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: CateContainer(
                                  image: _listRooms[index].image,
                                  name: ourList[index]['name'] ??
                                      ourList[0]['name'],
                                  temp: _listRooms[index].temp,
                                  onTap: () {
                                    refresh_flag = 1;
                                    roomIndex = index;
                                    zone_add = ourList[index]['zid'];
                                    List<dynamic> needList =
                                        ourList[index]['lamps'] != null
                                            ? List.from(ourList[2]['lamps'])
                                            : null;

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                title: ourList[index]['name'],
                                                needList: needList)));
                                  },
                                ),
                              );
                            },
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                ),
                SizedBox(
                  height: 60,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                ),
                Container(
                  //color: Colors.white,
                  height: MediaQuery.of(context).size.height * .08,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ///Column for sprinkler
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 8, 0, 0),
                            child: ArgonTimerButton(
                              roundLoadingShape: false,
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.2,
                              borderRadius: 10,
                              color: Colors.black12,
                              child: IconButton(
                                icon:
                                    Image.asset("assets/images/sprinkler.png"),
                              ),
                              loader: (timeLeft) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(50)),
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: SpinKitWave(
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                );
                              },
                              onTap: (startTimer, btnState) {
                                isInternet1();
                                try {
                                  if (mqtt_connection_status == true &&
                                      mqtt_sub_status == true) {
                                    showAlertDialog(context);
                                  }
                                } catch (e) {}
                                if (btnState == ButtonState.Idle) {
                                  startTimer(2);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      ///column for main gate
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 10, 0, 0),
                            child: ArgonTimerButton(
                              roundLoadingShape: false,
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.2,
                              borderRadius: 10,
                              color: Colors.black12,
                              child: IconButton(
                                icon: Image.asset(
                                    "assets/images/icons8-gate-50.png"),
                              ),
                              loader: (timeLeft) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(50)),
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: SpinKitWave(
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                );
                              },
                              onTap: (startTimer, btnState) {
                                isInternet1();
                                try {
                                  if (mqtt_connection_status == true &&
                                      mqtt_sub_status == true) {
                                    showAlertDialog1(context);
                                  }
                                } catch (e) {}
                                if (btnState == ButtonState.Idle) {
                                  startTimer(2);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      ///column fpr mini gate
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 10, 0, 0),
                            child: ArgonTimerButton(
                              roundLoadingShape: false,
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.2,
                              borderRadius: 10,
                              color: Colors.black12,
                              child: IconButton(
                                icon: Image.asset(
                                    "assets/images/icons8-closed-door-50.png"),
                              ),
                              loader: (timeLeft) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(50)),
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: SpinKitWave(
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                );
                              },
                              onTap: (startTimer, btnState) {
                                isInternet1();
                                try {
                                  if (mqtt_connection_status == true &&
                                      mqtt_sub_status == true) {
                                    //qry_add1 = selected_lamp;
                                    showAlertDialog2(context);
                                  }
                                } catch (e) {}
                                if (btnState == ButtonState.Idle) {
                                  startTimer(2);
                                }
                              },
                            ),
                          ),
                        ],
                      ),

                      /// column for sliding gate
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(2, 10, 0, 0),
                            child: ArgonTimerButton(
                              roundLoadingShape: false,
                              height: MediaQuery.of(context).size.width * 0.12,
                              width: MediaQuery.of(context).size.width * 0.2,
                              borderRadius: 10,
                              color: Colors.black12,
                              child: IconButton(
                                icon: Image.asset(
                                    "assets/images/icons8-doorway-50.png"),
                              ),
                              loader: (timeLeft) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black12,
                                      borderRadius: BorderRadius.circular(50)),
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  child: SpinKitWave(
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                );
                              },
                              onTap: (startTimer, btnState) {
                                isInternet1();
                                try {
                                  if (mqtt_connection_status == true &&
                                      mqtt_sub_status == true) {
                                    showAlertDialog3(context);
                                  }
                                } catch (e) {}
                                if (btnState == ButtonState.Idle) {
                                  startTimer(2);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textCate({nameCate}) {
    return Text(
      nameCate,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

var tmp_snap;
String data;
List<dynamic> ourList = [];
Future<String> test() async {
  data = await getFileData(
      '/storage/emulated/0/Android/data/com.ligero.lihome/files/conh.json');

  var tagsJson = await jsonDecode(data)['data'];
  ourList = tagsJson != null ? List.from(tagsJson) : null;

  if (ourList != null) {
    List<dynamic> lampList =
        ourList[2]['lamps'] != null ? List.from(ourList[2]['lamps']) : null;
  }

  return 'aswin';
}

Future<String> getFileData(String path) async {
  File fileJson = File(
      '/storage/emulated/0/Android/data/com.ligero.lihome/files/conh.json');
  final contents = await fileJson.readAsString();

  return contents;
}

///alert for sprinkler
showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Turn on"),
    onPressed: () {
      toast_flag = 0;
      //publish('{"lid":212,"cmd":205,"data":100,"echo":1}', '679303000/008');
      toast_timer = Timer(Duration(seconds: 2), toastfunc);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );
  Widget noButton = FlatButton(
    child: Text("Turn off"),
    onPressed: () {
      toast_flag = 0;
      //publish('{"lid":212,"cmd":205,"data":0,"echo":1}', '679303000/008');
      toast_timer = Timer(Duration(seconds: 2), toastfunc);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(" Sprinkler Control"),
    content: Text("Turn on/off sprinkler?"),
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

///main gate alert
showAlertDialog1(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      toast_flag = 0;
      //publish('{"lid":67,"cmd":206,"data":0,"echo":1}', '679303000/000');
      toast_timer = Timer(Duration(seconds: 2), toastfunc);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );
  Widget noButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(" Gate Control"),
    content: Text("Open/Close main gate?"),
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

///alert for mini gate
showAlertDialog2(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      toast_flag = 0;
      //publish('{"lid":68,"cmd":206,"data":0,"echo":1}', '679303000/000');
      toast_timer = Timer(Duration(seconds: 2), toastfunc);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );
  Widget noButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(" Gate Control"),
    content: Text("Open/Close mini gate?"),
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

///alert for sliding gate
showAlertDialog3(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      toast_flag = 0;
      //publish('{"lid":66,"cmd":206,"data":0,"echo":1}', '679303000/000');
      toast_timer = Timer(Duration(seconds: 2), toastfunc);

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );
  Widget noButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      // Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(" Gate Control"),
    content: Text("Open/Close Sliding gate?"),
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

void toastfunc() {
  if (toast_flag != 1) {
    qry_btn_color = Colors.red;
    Fluttertoast.showToast(
      textColor: Colors.red,
      backgroundColor: Colors.grey[800],
      msg: 'Try again!!',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }
}

Future<bool> isInternet1() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    if (await DataConnectionChecker().hasConnection) {
      return true;
    } else {
      // Mobile data detected but no internet connection found.
      Fluttertoast.showToast(
        backgroundColor: Colors.grey[800],
        msg: 'No internet...Check connection',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
      );
      return false;
    }
  } else if (connectivityResult == ConnectivityResult.wifi) {
    if (await DataConnectionChecker().hasConnection) {
      return true;
    } else {
      // Wifi detected but no internet connection found.
      return false;
    }
  } else {
    Fluttertoast.showToast(
      backgroundColor: Colors.grey[800],
      msg: 'No internet!...Check connection',
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
    );
    return false;
  }
}
