import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';
import 'package:smart_home/screens/curtainscreen.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'package:smart_home/models/rooms_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/screens/sprinkler.dart';
import 'package:smart_home/main.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'dart:async';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:toast/toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

String server_http_ip = 'http://192.168.0.109/echo';

/// test ip for esp http calls
var power_button_cmd = 208;
var power_button_zone = 0;
var scene_button_cmd = 234;
var scene_button_zone = zone_add;
var selected_lamp_id = 0;
var slider_cmd = 208;
var slider_data = 0;
var qry_cmd = 24;
var qry_add = zone_add;
Color connectivity_color = Colors.red;
var qry_wait = false;

double slider_value = 0;

/// selected lamp address

var scene_no;
Color button_color = Colors.white;
Color primaryColor = Color(0XFF26282B);

/// bg color of lamp page
Color activeColor1 = Color(0XFFED560D);

/// color for gradient
Color activeColor2 = Color(0XFFCD2A12);

/// color for gradient
Color powerbuttoncolor = Colors.white;

/// initial color for room power button

List<Icon> scene_Icons = [
  /// icons for each scenes
  Icon(Icons.lightbulb),
  Icon(Icons.brightness_high),
  Icon(Icons.brightness_6),
  Icon(Icons.nights_stay),
  Icon(Icons.nightlife),
  Icon(Icons.invert_colors_sharp),
  Icon(Icons.local_dining_rounded),
  Icon(Icons.sports_esports_outlined),
  Icon(Icons.book_outlined),
  Icon(Icons.border_all),
  Icon(Icons.ac_unit),
  Icon(Icons.settings_input_antenna_outlined),
];
List<Color> scene_color = [
  /// color of each scenes tile
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
];
List<Color> activecolor1 = [
  /// color gradient for lamp identifier tile
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
];
List<Color> activecolor2 = [
  /// color gradient for lamp identifier tile
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
  Colors.black54,
];
List<LampModel> _lamps = [
  /// lamp models initial value hard coded...
  /// to be updated from json config file
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
  LampModel(name: '9W', lid: 2),
  LampModel(name: '12W', lid: 12),
  LampModel(name: '7W', lid: 4),
  LampModel(name: '9W', lid: 10),
  LampModel(name: '7W', lid: 10),
];
List<Color> gradientColors = [activeColor1, activeColor2];

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    if (connect_flag == 0) {
      connect();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    // return MaterialApp(
    //   title: 'Flutter Demo',
    //   debugShowCheckedModeBanner: false,
    //   theme: ThemeData(primarySwatch: Colors.blue),
    //   home: HomePage(),
    // );

    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

// FToast fToast;
//
// _showToast() {
//   Widget toast = Container(
//     padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
//     decoration: BoxDecoration(
//       borderRadius: BorderRadius.circular(25.0),
//       color: Colors.greenAccent,
//     ),
//     child: Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(Icons.check),
//         SizedBox(
//           width: 12.0,
//         ),
//         Text("This is a Custom Toast"),
//       ],
//     ),
//   );
//
//   fToast.showToast(
//     child: toast,
//     gravity: ToastGravity.BOTTOM,
//     toastDuration: Duration(seconds: 2),
//   );
//
//   // Custom Toast Position
//   fToast.showToast(
//       child: toast,
//       toastDuration: Duration(seconds: 2),
//       positionedToastBuilder: (context, child) {
//         return Positioned(
//           child: child,
//           top: 16.0,
//           left: 16.0,
//         );
//       });
// }

class HomePage extends StatefulWidget {
  final String title;
  HomePage({@required this.title});
  @override
  _HomePageState createState() => _HomePageState();

  /// main app start
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _showErrorMessage(String message) {
    _scaffoldKey.currentState.hideCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      // padding: EdgeInsets.only(
      //     left: MediaQuery.of(context).size.width * 0.4, bottom: 20),
      duration: connectivity_duration,
      padding: EdgeInsets.only(bottom: 10),
      backgroundColor: connectivity_color,
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < response_dummy.length; i++)

    /// taking lamps id from json config file
    {
      _lamps[i].lid = response_dummy['lid${i + 1}'];
    }
    lamp_count = response_dummy.length;

    /// total number of lamps in a room

    return Scaffold(
      key: _scaffoldKey,

      /// main widget start (home page)
      backgroundColor: Color(0XFF26282B), //primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.01,
              width: 20,
              child: StreamBuilder<int>(
                stream: connectivity_controller.stream,
                initialData: 3,
                builder: (context, snapshot) {
                  if (mqtt_connection_status == false) {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _showErrorMessage('Server disconnected'));
                  }
                  if (mqtt_connection_status == true) {
                    WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _showErrorMessage('Server connected'));
                  }
                  return Container(
                    width: 0,
                    height: 0,
                  );
                },
              ),
            ),

            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.01,
            // ), // Athul,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                StreamBuilder<int>(
                    stream: query_button_controller.stream,
                    builder: (context, snapshot) {
                      if (qry_wait == true) {
                        return Container(
                          ////////////////////////////////////////////////////////////////////
                          height: MediaQuery.of(context).size.height * 0.06, //1
                          ////////////////////////////////////////////////////////////////////
                          width: MediaQuery.of(context).size.width * 0.11,
                          //borderRadius: 10,
                          color: Color(0XFF26282B),

                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Center(
                              child: SpinKitHourGlass(
                                color: Colors.white70,
                                size: 30.0,
                                // controller: AnimationController(
                                //     duration: const Duration(milliseconds: 1200)),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return GestureDetector(
                            child: Container(
                              ////////////////////////////////////////////////////////////////////
                              height:
                                  MediaQuery.of(context).size.height * 0.06, //1
                              ////////////////////////////////////////////////////////////////////
                              width: MediaQuery.of(context).size.width * 0.11,
                              //borderRadius: 10,
                              color: Color(0XFF26282B),

                              child: Padding(
                                padding: EdgeInsets.all(4),
                                child: Center(
                                  child: Icon(
                                    Icons.refresh,
                                    size: 33,
                                    color: qry_btn_color,
                                  ),
                                ),
                              ),
                            ),
                            onTap: () {
                              qry_wait = true;
                              query_button_controller.add(1);
                              setState(() {});
                            });
                      }

                      if (snapshot.hasData) {
                        return Container(
                          ////////////////////////////////////////////////////////////////////
                          height: MediaQuery.of(context).size.height * 0.06, //1
                          ////////////////////////////////////////////////////////////////////
                          width: MediaQuery.of(context).size.width * 0.11,
                          //borderRadius: 10,
                          color: Color(0XFF26282B),

                          child: Padding(
                            padding: EdgeInsets.all(4),
                            child: Center(
                              child: Icon(
                                Icons.refresh,
                                size: 30,
                              ),
                            ),
                          ),
                        );
                      }
                      return Container(
                        ////////////////////////////////////////////////////////////////////
                        height: MediaQuery.of(context).size.height * 0.06, //1
                        ////////////////////////////////////////////////////////////////////
                        width: MediaQuery.of(context).size.width * 0.11,
                        //borderRadius: 10,
                        color: Color(0XFF26282B),

                        child: Padding(
                          padding: EdgeInsets.all(4),
                          child: Center(
                            child: Icon(
                              Icons.refresh,
                              size: 30,
                            ),
                          ),
                        ),
                      );
                    }),

                // GestureDetector(
                //   child: Container(
                //     ////////////////////////////////////////////////////////////////////
                //     height: MediaQuery.of(context).size.height * 0.06, //1
                //     ////////////////////////////////////////////////////////////////////
                //     width: MediaQuery.of(context).size.width * 0.11,
                //     //borderRadius: 10,
                //     color: Color(0XFF26282B),
                //
                //     child: Padding(
                //       padding: EdgeInsets.all(4),
                //       child: Center(
                //         child: SpinKitFadingCircle(
                //           color: Colors.white,
                //           size: 30.0,
                //           // controller: AnimationController(
                //           //     duration: const Duration(milliseconds: 1200)),
                //         ),
                //       ),
                //     ),
                //   ),
                //   onTap: () {
                //     Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //           builder: (context) => HomeScreen(),
                //         ));
                //   },
                // ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                testWidget(),

                /// power button widget
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Container(
              ////////////////////////////////////////////////////////////////////
              height: MediaQuery.of(context).size.height * 0.14, //1
              ////////////////////////////////////////////////////////////////////
              color: primaryColor,
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: lamp(),
            ),
            // query(),
            //connectivity(),

            /// query widget
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            slider(),

            /// middle circular slider widget
            SizedBox(height: MediaQuery.of(context).size.height * .06),
            Container(
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor, //Colors.black12,
                    )
                  ]),
              padding: EdgeInsets.fromLTRB(10, 0, 15, 0),
              ////////////////////////////////////////////////////////////////////
              height: MediaQuery.of(context).size.height * 0.16, //1
              ////////////////////////////////////////////////////////////////////
              child: moodWidget(),

              /// scenes widget
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.11,
            ),
            Container(
              /// bottom navigation bar widget
              ////////////////////////////////////////////////////////////////////
              height: MediaQuery.of(context).size.height * 0.08, //1
              ////////////////////////////////////////////////////////////////////
              color: primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(children: [
                    /// lamp
                    Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.lightbulb_outline,
                                    color: activeColor1,
                                  ),
                                  onPressed: () {
                                    print("You Pressed the icon!");
                                  }),
                            ),
                          ]),
                    ),
                    Row(children: [
                      Text(
                        'Lamp',
                        style: TextStyle(color: Colors.white),
                      ),
                    ])
                  ]),
                  Column(children: [
                    /// curtain
                    Expanded(
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.border_all,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CurtainPage(
                                                  title: widget.title,
                                                )));
                                    print("You Pressed the icon!");
                                  }),
                            ),
                          ]),
                    ),
                    Row(children: [
                      Container(),
                      Text(
                        'Curtain',
                        style: TextStyle(color: Colors.white),
                      ),
                    ])
                  ]),
                  Column(

                      /// sprinlkler
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Row(children: [
                            Container(
                              child: IconButton(
                                  icon: Icon(
                                    Icons.filter_tilt_shift_outlined,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SprinklerPage(
                                                  title: widget.title,
                                                )));
                                    print("You Pressed the icon!");
                                  }),
                            ),
                          ]),
                        ),
                        Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Sprinkler',
                                style: TextStyle(color: Colors.white),
                              ),
                            ])
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// function that handles power button operation
Future<String> getData() async {
  print('get data called');
  if (powerbuttoncolor == Colors.white) {
    powerbuttoncolor = Colors.blue;
  } else {
    powerbuttoncolor = Colors.white;
  }
  return 'jj';
}

/// function that handles query button operation
Future<String> getqueryData() async {
  qry_add = _lamps[selected_lamp_id].lid;
  qry_icon_color = Colors.white;
  // final http.Response response = await http.post(
  // //   server_http_ip,
  // //   headers: <String, String>{
  // //     'Content-Type': 'application/json; charset=UTF-8',
  // //   },
  // //   body: jsonEncode(<String, int>{
  // //     'data': 5,
  // //     'cmd': qry_cmd,
  // //     'lid': qry_add,
  // //     'sid': 87,
  // //   }),
  // // );
  // // var response_json = jsonDecode(response.body);
  // // if (response.statusCode == 200) {
  // //   print(response_json);
  // //   if (response_json['cmd'] == qry_cmd) {
  // //     qry_icon_color = Colors.green;
  // //   } else {
  // //     qry_icon_color = Colors.white;
  // //   }
  // //   return 'gj';
  // // } else {
  // //   qry_icon_color = Colors.white;
  // //   throw Exception('Failed Response');
  // // }
}

bool temp = false;
bool temp2 = false;

Color light_master_color = Colors.white;
// Future<String> getsceneData() async {
//   for (int i = 0; i < 12; i++) {
//     scene_color[i] = Colors.black54;
//   }
//   print('entered scene');
//   print('selected lamp ${_lamps[selected_lamp_id].lid}');
//   final http.Response response = await http.post(
//     server_http_ip,
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, int>{
//       'data': scene_no,
//       'cmd': scene_button_cmd,
//       'lid': scene_button_zone,
//       //'sid': '87',
//     }),
//   );
//   var response_json = jsonDecode(response.body);
//   print(response_json);
//   if (response.statusCode == 200) {
//     if (response_json['cmd'] == 234 &&
//         response_json['lid'] == scene_button_zone) {
//       //  temp = true;
//       print("ok");
//       scene_color[scene_no] = Colors.deepOrange;
//       // scene_button_cmd = 208;
//     } else {
//       scene_color[response_json['data']] = Colors.black;
//     }
//
//     return 'gj';
//   } else {
//     //  temp = false;
//     throw Exception('Failed Response');
//   }
// }

// Future<String> getsliderData() async {
//   selected_lamp = _lamps[selected_lamp_id].lid;
//   for (int i = 0; i < 12; i++) {
//     scene_color[i] = Colors.black54;
//   }
//   print('entered slider ');
//   final http.Response response = await http.post(
//     server_http_ip,
//     headers: <String, String>{
//       'Conten-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, int>{
//       'data': slider_value.toInt(),
//       'cmd': slider_cmd,
//       'lid': _lamps[selected_lamp_id].lid,
//       'sid': 87,
//     }),
//   );
//   if (response.statusCode == 200) {
//     var response_json = jsonDecode(response.body);
//     print(response_json);
//
//     if (response_json['cmd'] == 201 &&
//         response_json['lid'] == _lamps[selected_lamp_id].lid) {
//       resp_test = slider_value;
//       slider_cmd = 212;
//       light_master_color = Colors.yellowAccent;
//       //  temp = true;
//       print("ok");
//     } else if (response_json['cmd'] == 208 &&
//         response_json['lid'] == _lamps[selected_lamp_id].lid) {
//       resp_test = 100;
//       slider_value = 100;
//       slider_cmd = 212;
//       light_master_color = Colors.yellowAccent;
//     } else if (response_json['cmd'] == 212 &&
//         response_json['lid'] == _lamps[selected_lamp_id].lid) {
//       resp_test = 0;
//       slider_value = 0;
//       slider_cmd = 208;
//       light_master_color = Colors.white;
//     }
//
//     print("ok");
//
//     return 'gj';
//   } else {
//     //temp = false;
//     throw Exception('Failed Response');
//   }
// }

class testWidget extends StatefulWidget {
  @override
  _testWidgetState createState() => _testWidgetState();
}

class _testWidgetState extends State<testWidget> {
  //FToast fToast;
  @override
  void initState() {
    // fToast = FToast();
    // fToast.init(context);

    super.initState();
    //  getData();
  }

  @override
  void dispose() {
    // power_button_controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('building power button');

    return StreamBuilder<int>(
      initialData: 55,
      stream: power_button_controller.stream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return Center(
            child: ArgonTimerButton(
              elevation: 0,
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.11,
              onTap: (startTimer, btnState) {
                try {
                  publish('{"lid":$power_button_zone,"cmd":$power_button_cmd}');
                } catch (e) {
                  print(e);
                }
                setState(() {});

                if (btnState == ButtonState.Idle) {
                  startTimer(1);
                }
              },
              child: Icon(
                Icons.power_settings_new,
                color: powerbuttoncolor,
                size: 32,
              ),
              loader: (timeLeft) {
                return Container(
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(50)),
                  margin: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.power_settings_new,
                    color: Colors.black,
                  ),
                );
              },
              borderRadius: 5.0,
              color: primaryColor,
            ),
          );
        }
      },
    );
  }
}

class moodWidget extends StatefulWidget {
  int scene_index;
  moodWidget({
    @required this.scene_index,
  });
  @override
  _moodWidgetState createState() => _moodWidgetState();
}

class _moodWidgetState extends State<moodWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (connect_flag == 0) {
    //   connect();
    // }
    print('building mood');
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 3,
            childAspectRatio: .7),
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (BuildContext context, int index) {
          return StreamBuilder<int>(
              initialData: 2,
              stream: scene_button_controller.stream,
              builder: (ctx, snapshot) {
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                } else {
                  return Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: ArgonTimerButton(
                      height: MediaQuery.of(context).size.width * 0.18,
                      width: MediaQuery.of(context).size.width * 0.18,
                      onTap: (startTimer, btnState) {
                        print("temp value $temp");
                        setState(() {
                          scene_no = index;
                        });
                        try {
                          publish(
                              '{"data":$scene_button_zone,"cmd":$scene_button_cmd,"lid":$scene_no}');
                        } catch (e) {
                          print(e);
                        }
                        if (btnState == ButtonState.Idle) {
                          startTimer(1);
                        }
                      },
                      child: Icon(
                        scene_Icons[index].icon,
                        color: Colors.white,
                      ),
                      loader: (timeLeft) {
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(50)),
                          margin: EdgeInsets.all(5),
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          child: Icon(
                            scene_Icons[index].icon,
                            color: Colors.white,
                          ),
                        );
                      },
                      borderRadius: 5.0,
                      color: scene_color[index],
                    ),
                  );
                }
              });
        });
  }
}

Color qry_icon_color = Colors.white;

class query extends StatefulWidget {
  @override
  _queryState createState() => _queryState();
}

class _queryState extends State<query> {
  @override
  void dispose() {
    //_fetchqueryData = getqueryData();
    //query_button_controller.close();
    super.dispose();
  }

  @override
  void initState() {
    //_fetchqueryData = getqueryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        initialData: 20,
        stream: query_button_controller.stream,
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            return Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width * .7),
              child: ArgonTimerButton(
                elevation: 0,
                color: primaryColor,
                width: MediaQuery.of(context).size.width * .1,
                ////////////////////////////////////////////////////////////////////
                height: MediaQuery.of(context).size.height * 0.05, //1
                ////////////////////////////////////////////////////////////////////
                child: Icon(
                  Icons.info_outline,
                  color: qry_icon_color,
                  size: 30,
                ),
                onTap: (startTimer, btnState) {
                  if (mqtt_connection_status == true &&
                      mqtt_sub_status == true) {
                    qry_add = selected_lamp;
                    publish('{"lid":$qry_add,"cmd":$qry_cmd}');
                  } else {
                    qry_icon_color = Colors.white;
                    // if (mqtt_connection_status == false) {
                    //   connect();
                    // } else {
                    //   subscribe('testtopic');
                    // }
                  }
                  setState(() {});

                  if (btnState == ButtonState.Idle) {
                    startTimer(1);
                  }
                  setState(() {
                    //    _fetchqueryData = getqueryData();
                  });
                  if (btnState == ButtonState.Idle) {
                    startTimer(1);
                  }
                },
                loader: (timeLeft) {
                  return Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                  );
                },
              ),
            );
          }
        });
  }
}

class slider extends StatefulWidget {
  @override
  _sliderState createState() => _sliderState();
}

class _sliderState extends State<slider> {
  @override
  void initState() {
    // _fetchsliderData = getsliderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connect_flag == 0) {
      connect();
    }
    print("builiding slider");
    return StreamBuilder<int>(
        initialData: 30,
        stream: slider_controller.stream,
        builder: (ctx, snapshot) {
          if (mqtt_connection_status == false) {
            print("b5");
            return ClayContainer(
              ////////////////////////////////////////////////////////////////////
              height: MediaQuery.of(context).size.height * 0.25,
              //1
              ////////////////////////////////////////////////////////////////////
              width: MediaQuery.of(context).size.height * 0.25,
              color: Color(0XFF26282B),
              //// A
              borderRadius: 200,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: SleekCircularSlider(
                  innerWidget: (value) {
                    return Container(
                      decoration: BoxDecoration(shape: BoxShape.circle),
                      width: MediaQuery.of(context).size.width * .14, //200,
                      height: MediaQuery.of(context).size.width * .14, //200,
                      child: Padding(
                        padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * .1,
                        ),
                        child: Column(children: [
                          ArgonTimerButton(
                            height: MediaQuery.of(context).size.height * .08,
                            width: MediaQuery.of(context).size.width * .2,
                            onTap: (startTimer, btnState) {
                              if (mqtt_connection_status == true &&
                                  mqtt_sub_status == true) {
                                qry_add = selected_lamp;
                                publish(
                                    '{"lid":$selected_lamp,"cmd":$slider_cmd}');
                              } else {
                                //   if (mqtt_connection_status == false) {
                                //     connect();
                                //   } else {
                                //     subscribe('testtopic');
                                //   }
                              }

                              setState(() {
                                //    _fetchqueryData = getqueryData();
                              });
                              if (btnState == ButtonState.Idle) {
                                startTimer(1);
                              }
                            },
                            child: Icon(
                              Icons.wb_incandescent,
                              color: light_master_color,
                              size: MediaQuery.of(context).size.height * .07,
                            ),
                            loader: (timeLeft) {
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(200)),
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width * .25,
                                height: MediaQuery.of(context).size.width * .25,
                                child: Icon(
                                  Icons.wb_incandescent,
                                  color: Colors.yellowAccent,
                                ),
                              );
                            },
                            borderRadius: 5.0,
                            color: primaryColor,
                            //Colors.black54,
                            elevation: 0,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Expanded(
                            child: AutoSizeText(
                              '${value.ceil().toInt().toString()}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      MediaQuery.of(context).size.height * 0.03,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                  appearance: CircularSliderAppearance(
                    //animationEnabled: false,
                    customColors: CustomSliderColors(
                      trackColor: Colors.white,
                      progressBarColors: gradientColors,
                      hideShadow: true,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                  onChange: null,
                  onChangeEnd: null, // {
                  // slider_value = value;
                  // //slider_cmd = 201;
                  //
                  // // qry_add = selected_lamp;
                  // // try {
                  // //   publish(
                  // //       '{"lid":$selected_lamp,"cmd":$slider_cmd,"data":$slider_value}');
                  // // } catch (e) {
                  // //   print(e);
                  // // }
                  // //  slider_controller.add(1);
                  //
                  // resp_test = slider_value;
                  // setState(() {
                  //   print('mqqqqq');
                  //   value = 5;
                  //   // print(mqtt_connection_status);
                  //   // if (mqtt_connection_status == false) {
                  //   //   resp_test = slider_value;
                  //   // }
                  //   //    _fetchqueryData = getqueryData();
                  // });
                  // slider_controller.close();
                  //},
                  initialValue: slider_value,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            print("b 1");
            return CircularProgressIndicator();
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              print("b 2");
              return CircularProgressIndicator();
            } else {
              print("o");
              return ClayContainer(
                ////////////////////////////////////////////////////////////////////
                height: MediaQuery.of(context).size.height * 0.25,
                //1
                ////////////////////////////////////////////////////////////////////
                width: MediaQuery.of(context).size.height * 0.25,
                color: Color(0XFF26282B),
                //// A
                borderRadius: 200,
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: SleekCircularSlider(
                    innerWidget: (value) {
                      return Container(
                        decoration: BoxDecoration(shape: BoxShape.circle),
                        width: MediaQuery.of(context).size.width * .14, //200,
                        height: MediaQuery.of(context).size.width * .14, //200,
                        child: Padding(
                          padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * .1,
                          ),
                          child: Column(children: [
                            ArgonTimerButton(
                              height: MediaQuery.of(context).size.height * .08,
                              width: MediaQuery.of(context).size.width * .2,
                              onTap: (startTimer, btnState) {
                                if (mqtt_connection_status == true &&
                                    mqtt_sub_status == true) {
                                  qry_add = selected_lamp;
                                  publish(
                                      '{"lid":$selected_lamp,"cmd":$slider_cmd}');
                                } else {
                                  //   if (mqtt_connection_status == false) {
                                  //     connect();
                                  //   } else {
                                  //     subscribe('testtopic');
                                  //   }
                                }

                                setState(() {
                                  //    _fetchqueryData = getqueryData();
                                });
                                if (btnState == ButtonState.Idle) {
                                  startTimer(1);
                                }
                              },
                              child: Icon(
                                Icons.wb_incandescent,
                                color: light_master_color,
                                size: MediaQuery.of(context).size.height * .07,
                              ),
                              loader: (timeLeft) {
                                return Container(
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(200)),
                                  alignment: Alignment.center,
                                  width:
                                      MediaQuery.of(context).size.width * .25,
                                  height:
                                      MediaQuery.of(context).size.width * .25,
                                  child: Icon(
                                    Icons.wb_incandescent,
                                    color: Colors.yellowAccent,
                                  ),
                                );
                              },
                              borderRadius: 5.0,
                              color: primaryColor,
                              //Colors.black54,
                              elevation: 0,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Expanded(
                              child: AutoSizeText(
                                '${value.ceil().toInt().toString()}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        MediaQuery.of(context).size.height *
                                            0.03,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ]),
                        ),
                      );
                    },
                    appearance: CircularSliderAppearance(
                      animationEnabled: slider_animation,
                      customColors: CustomSliderColors(
                        trackColor: Colors.white,
                        progressBarColors: gradientColors,
                        hideShadow: true,
                        shadowColor: Colors.transparent,
                      ),
                    ),
                    onChange: (double value) {
                      print(MediaQuery.of(context).size.height);
                      print(value);
                    },
                    onChangeEnd: (value) {
                      slider_value = value;
                      slider_cmd = 201;
                      int int_slider_value = slider_value.toInt();

                      qry_add = selected_lamp;
                      try {
                        publish(
                            '{"lid":$selected_lamp,"cmd":$slider_cmd,"data":$int_slider_value}');
                      } catch (e) {
                        print(e);
                      }
                      resp_test = slider_value;
                      setState(() {
                        print('mqqqqq');
                        // print(mqtt_connection_status);
                        // if (mqtt_connection_status == false) {
                        //   resp_test = slider_value;
                        // }
                        //    _fetchqueryData = getqueryData();
                      });
                    },
                    initialValue: resp_test,
                  ),
                ),
              );
            }
          }
        });
  }
}

class lamp extends StatefulWidget {
  @override
  _lampState createState() => _lampState();
}

class _lampState extends State<lamp> {
  // double itemWidth = 200.0;
  int itemCount = 40;
  int selected = 0;
  FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);
  @override
  Widget build(BuildContext context) {
    print('building row 2 mood');
    return RotatedBox(
        quarterTurns: -1,
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification) {
            if (scrollNotification is ScrollStartNotification) {
              // print("started");
            } else if (scrollNotification is ScrollUpdateNotification) {
              // print("updated");
            } else if (scrollNotification is ScrollEndNotification) {
              if (mqtt_connection_status == true && mqtt_sub_status == true) {
                qry_add = selected_lamp;
                publish('{"lid":$selected,"cmd":$qry_cmd,"data":57}');
                qry_wait = true;
                query_button_controller.add(1);
                //  await Future.delayed(const Duration(milliseconds: 3000));
              }
              //  print("end");
            }
            return true;
          },
          child: ListWheelScrollView(
            physics: FixedExtentScrollPhysics(),
            diameterRatio: 3,
            //  offAxisFraction: 1,
            //renderChildrenOutsideViewport: true,
            //useMagnifier: true,
            // squeeze: 1,
            perspective: 0.008,
            offAxisFraction: 0,
            //clipBehavior: Clip.none,
            //overAndUnderCenterOpacity: 0.9,
            // magnification: 1.2,
            onSelectedItemChanged: (x) async {
              setState(() {
                // print("chanege");
                selected = x;
                selected_lamp_id = x;
                selected_lamp = _lamps[selected_lamp_id].lid;
              });
            },
            controller: _scrollController,
            children: List.generate(
                itemCount,
                (x) => Padding(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      child: RotatedBox(
                          quarterTurns: 1,
                          child: AnimatedContainer(
                              //padding: EdgeInsets.all(20),
                              //color: Colors.white,
                              duration: Duration(milliseconds: 0),
                              width: x == selected ? 50 : 50,
                              height: x == selected ? 65 : 65,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: x == selected ? Colors.red : Colors.grey,
                                shape: x == selected
                                    ? BoxShape.rectangle
                                    : BoxShape.rectangle,
                                borderRadius: x == selected
                                    ? BorderRadius.circular(400)
                                    : BorderRadius.circular(400),
                              ),
                              child: Text(
                                'Lamp  $x  ${_lamps[x].lid}',
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ))),
                    )),
            itemExtent: 200,
          ),
        ));

    // return ListView.builder(
    //   semanticChildCount: 1,
    //   scrollDirection: Axis.horizontal,
    //   itemCount: lamp_count,
    //   itemBuilder: (context, index) {
    //     String device_type = 'lamp';
    //
    //     if (index == 0) {
    //       device_type = "Master Control";
    //     } else {
    //       device_type = "Lamp";
    //     }
    //     return GestureDetector(
    //       child: SafeArea(
    //         child: Container(
    //           width: MediaQuery.of(context).size.width * .9,
    //           height: MediaQuery.of(context).size.width * .3,
    //           margin: EdgeInsets.only(left: 16, right: 16),
    //           decoration: BoxDecoration(
    //             gradient: LinearGradient(colors: [
    //               activecolor1[index],
    //               activecolor2[index],
    //             ]),
    //             borderRadius: BorderRadius.circular(20),
    //           ),
    //           child: Padding(
    //             padding: EdgeInsets.all(6),
    //             child: ListTile(
    //               leading: Icon(
    //                 Icons.lightbulb,
    //                 color: Colors.white,
    //                 size: 34,
    //               ),
    //               title: Text(
    //                 //  '$device_type ${index}   ${_lamps[index].lid}',
    //                 '$device_type',
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.bold,
    //                   color: Colors.white,
    //                   fontSize: 22,
    //                 ),
    //               ),
    //               subtitle: Text(
    //                 _lamps[index].name,
    //                 style: TextStyle(
    //                   fontWeight: FontWeight.w500,
    //                   color: Colors.white,
    //                   fontSize: 15,
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //       ),
    //       onTap: () {
    //         selected_lamp_id = index;
    //         selected_lamp = _lamps[selected_lamp_id].lid;
    //         print(selected_lamp);
    //         setState(() {
    //           for (int i = 0; i < 12; i++) {
    //             activecolor1[i] = Colors.black54;
    //             activecolor2[i] = Colors.black54;
    //           }
    //           activecolor1[index] = Color(0XFFED560D);
    //           activecolor2[index] = Color(0XFFCD2A12);
    //         });
    //       },
    //     );
    //   },
    // );
  }
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

class connectivity extends StatefulWidget {
  final String title = 'athul';
  @override
  _connectivityState createState() => _connectivityState();
}

class _connectivityState extends State<connectivity> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        height: 30,
        width: 30,
        child: ConnectivityWidget(
          onlineCallback: _incrementCounter,
          builder: (context, isOnline) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "${isOnline ? 'Online' : 'Offline'}",
                  style: TextStyle(
                      fontSize: 30,
                      color: isOnline ? Colors.green : Colors.red),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Number of times we connected to the internet:',
                ),
                Text(
                  '$_counter',
                  //style: Theme.of(context).textTheme.display1,
                ),
              ],
            ),
          ),
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
