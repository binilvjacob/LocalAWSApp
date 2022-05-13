import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';
import 'package:smart_home/screens/curtainscreen.dart';
import 'package:smart_home/models/rooms_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/screens/screens.dart';
import 'package:smart_home/screens/sprinkler.dart';
import 'package:smart_home/main.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:smart_home/screens/home_screen.dart';

String server_http_ip = 'http://192.168.0.109/echo';
var selectedindex = 0;

/// to initialise first lamp variable called on back button
var selected_lamp = lampList[0]['lid'];
var gateway_id = lampList[0]['gateway_id'];

/// test ip for esp http calls

var power_button_cmd = 208;
var power_button_zone = 0;
var scene_button_cmd = 234;
var scene_button_zone = ourList[HomeScreen.roomIndex]['zid'];
var scene_no_main;

///zone_add
var selected_lamp_id = 0;
var slider_cmd = 208;
var slider_data = 0;
var qry_cmd = 24;
var qry_add = zone_add;
Color connectivity_color = Colors.red;
var qry_wait = false;
var device_id = 0;

double slider_value = 0;

/// selected lamp address

var scene_no;
Color button_color = Colors.white;
Color primaryColor = Color(0XFF26282B);

/// bg color of lamp page
Color activeColor1 = Colors.lightGreenAccent[200];
//Color(0XFFED560D);

/// color for gradient
Color activeColor2 = Colors.teal[300];

/// color for gradient
Color powerbuttoncolor = Colors.white;

/// initial color for room power button

List<Icon> scene_Icons = [
  /// icons for each scenes
  Icon(Icons.wb_sunny_outlined),
  Icon(Icons.nights_stay),
  Icon(Icons.hotel_outlined),
  Icon(Icons.nightlife_outlined),
  Icon(Icons.local_library_outlined),
  Icon(Icons.theaters_rounded),
  Icon(Icons.brightness_1),
  Icon(Icons.brightness_1_outlined),
  Icon(Icons.sports_esports_outlined),
  Icon(Icons.local_cafe_outlined),
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
      client.disconnect();
      connect();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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

class HomePage extends StatefulWidget {
  final String title;
  final List needList;

  HomePage({@required this.title, this.needList});
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
    return new WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                    //title: widget.title,
                    )));
        return false;
      },
      child: Scaffold(
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

              ///top header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      refresh_flag = 1;

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  StreamBuilder<int>(
                      stream: query_button_controller.stream,
                      builder: (context, snapshot) {
                        if (qry_wait == true) {
                          return Container(
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
                                child: SpinKitHourGlass(
                                  color: Colors.white70,
                                  size: 30.0,
                                ),
                              ),
                            ),
                          );
                        } else {
                          return GestureDetector(
                              child: Container(
                                ////////////////////////////////////////////////////////////////////
                                height: MediaQuery.of(context).size.height *
                                    0.06, //1
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
                                toast_flag = 0;
                                publish(
                                    '{"lid":$selected_lamp,"cmd":$qry_cmd,"data":50,"echo":0}',
                                    gateway_id);
                                toast_timer =
                                    Timer(Duration(seconds: 2), toastfunc);
                                qry_wait = true;
                                query_button_controller.add(1);
                                setState(() {
                                  qry_wait = true;
                                });
                              });
                        }
                      }),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.02),
              Container(
                ////////////////////////////////////////////////////////////////////
                height: MediaQuery.of(context).size.height * 0.14, //1
                ////////////////////////////////////////////////////////////////////
                color: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),

                /// scrollable lamp names
                child: lamp(),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              ///slider and lamp on/off classs
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
                ///scene control class
                child: moodWidget(),
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
                                      color: activeColor2,
                                    ),
                                    onPressed: () {}),
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
                                      selected_lamp1 = lampList1[0]['lid'];
                                      gateway_id1 = lampList1[0]['gateway_id'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CurtainPage(
                                                    title: widget.title,
                                                  )));
                                    }),
                              ),
                            ]),
                      ),
                      Row(children: [
                        Container(),
                        Text(
                          'Shutter',
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
                                      selected_lamp2 = lampList2[0]['lid'];
                                      gateway_id2 = lampList2[0]['gateway_id'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SprinklerPage(
                                                    title: widget.title,
                                                  )));
                                    }),
                              ),
                            ]),
                          ),
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Others',
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
      ),
    );
  }
}

/// function that handles power button operation
Future<String> getData() async {
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
}

bool temp = false;
bool temp2 = false;

Color light_master_color = Colors.white;

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
    return StreamBuilder<int>(
      initialData: 55,
      stream: power_button_controller.stream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        } else {
          return Center(
            child: FutureBuilder(
                //initialData: 'initial',
                future: test2(),
                builder: (context, snapshot) {
                  ///power button for all on/off
                  return ArgonTimerButton(
                    elevation: 0,
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * 0.11,
                    onTap: (startTimer, btnState) {
                      try {
                        toast_flag = 0;
                        publish(
                            '{"lid":${ourList[HomeScreen.roomIndex]['zid']},"cmd":$power_button_cmd,"devid":$device_id,"echo":1}',
                            gateway_id);
                        toast_timer = Timer(Duration(seconds: 2), toastfunc);
                      } catch (e) {}
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
                  );
                }),
          );
        }
      },
    );
  }
}

/// class building scenes
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

  int indexNum = 0;
  showAlertDialog(BuildContext context) {
    // Create button
    Widget okButton = FlatButton(
      child: Text("Yes"),
      onPressed: () {
        setState(() {
          scene_no = indexNum;
        });
        try {
          toast_flag = 0;
          publish(
              '{"data":$scene_no,"cmd":231,"lid":${ourList[HomeScreen.roomIndex]['zid']},"echo":1}',
              ourList[HomeScreen.roomIndex]['lamps'][0]['gateway_id']);
          toast_timer = Timer(Duration(seconds: 2), toastfunc);
          scene_button_zone = ourList[HomeScreen.roomIndex]['zid'];
          scene_no_main = scene_no;
        } catch (e) {}
        Navigator.of(context).pop();
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
      title: Text("Update Scene"),
      content: Text("Are you sure you want to update this scene?"),
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

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 3,
            childAspectRatio: .7),
        scrollDirection: Axis.horizontal,
        itemCount: 10,
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
                    child: FutureBuilder(
                        future: test2(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return GestureDetector(
                              onLongPress: () {
                                indexNum = index;
                                showAlertDialog(context);
                                setState(() {
                                  scene_no = index;
                                });
                              },
                              child: ArgonTimerButton(
                                height:
                                    MediaQuery.of(context).size.width * 0.18,
                                width: MediaQuery.of(context).size.width * 0.18,
                                onTap: (startTimer, btnState) {
                                  setState(() {
                                    scene_no = index;
                                  });
                                  try {
                                    toast_flag = 0;
                                    publish(
                                        '{"data":$scene_no,"cmd":$scene_button_cmd,"lid":${ourList[HomeScreen.roomIndex]['zid']},"echo":1}',
                                        ourList[HomeScreen.roomIndex]['lamps']
                                            [0]['gateway_id']);
                                    toast_timer =
                                        Timer(Duration(seconds: 2), toastfunc);

                                    scene_button_zone =
                                        ourList[HomeScreen.roomIndex]['zid'];
                                    scene_no_main = scene_no;
                                  } catch (e) {}
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
                                        color: Colors.teal[400],
                                        borderRadius:
                                            BorderRadius.circular(50)),
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
                          } else {
                            return CircularProgressIndicator();
                          }
                        }),
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
    super.dispose();
  }

  @override
  void initState() {
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
                  } else {
                    qry_icon_color = Colors.white;
                  }
                  setState(() {});

                  if (btnState == ButtonState.Idle) {
                    startTimer(1);
                  }
                  setState(() {});
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

///slider class
class slider extends StatefulWidget {
  @override
  _sliderState createState() => _sliderState();
}

class _sliderState extends State<slider> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (connect_flag == 0) {
      connect();
    }

    return StreamBuilder<int>(
        initialData: 30,
        stream: slider_controller.stream,
        builder: (ctx, snapshot) {
          if (mqtt_connection_status == false) {
            return ClayContainer(
              ////////////////////////////////////////////////////////////////////
              height: MediaQuery.of(context).size.height * 0.25,
              //1
              ////////////////////////////////////////////////////////////////////
              width: MediaQuery.of(context).size.height * 0.25,
              color: Colors.teal[50],

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
                          FutureBuilder(
                              future: DefaultAssetBundle.of(context)
                                  .loadString('assets/user.json'),
                              builder: (context, snapshot) {
                                var tagsJson = jsonDecode(
                                    snapshot.data.toString())['data'];
                                List<dynamic> ourList = tagsJson != null
                                    ? List.from(tagsJson)
                                    : null;
                                return ArgonTimerButton(
                                  height:
                                      MediaQuery.of(context).size.height * .08,
                                  width: MediaQuery.of(context).size.width * .2,
                                  onTap: (startTimer, btnState) {
                                    if (mqtt_connection_status == true &&
                                        mqtt_sub_status == true) {
                                      qry_add = selected_lamp;
                                      toast_flag = 0;
                                      publish(
                                          '{"lid":$selected_lamp,"cmd":$slider_cmd,"echo":1 }',
                                          gateway_id);
                                      toast_timer = Timer(
                                          Duration(seconds: 2), toastfunc);
                                    } else {}

                                    setState(() {});
                                    if (btnState == ButtonState.Idle) {
                                      startTimer(1);
                                    }
                                  },
                                  child: Icon(
                                    Icons.wb_incandescent,
                                    color: light_master_color,
                                    size: MediaQuery.of(context).size.height *
                                        .07,
                                  ),
                                  loader: (timeLeft) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(200)),
                                      alignment: Alignment.center,
                                      width: MediaQuery.of(context).size.width *
                                          .25,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .25,
                                      child: Icon(
                                        Icons.wb_incandescent,
                                        color: Colors.yellowAccent,
                                      ),
                                    );
                                  },
                                  borderRadius: 5.0,
                                  color: primaryColor,
                                  elevation: 0,
                                );
                              }),
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
                    customColors: CustomSliderColors(
                      trackColor: Colors.white,
                      progressBarColors: gradientColors,
                      hideShadow: true,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                  onChange: null,
                  onChangeEnd: null, // {

                  initialValue: slider_value,
                ),
              ),
            );
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          } else {
            if (snapshot.connectionState == ConnectionState.done) {
              return CircularProgressIndicator();
            } else {
              return ClayContainer(
                ////////////////////////////////////////////////////////////////////
                height: MediaQuery.of(context).size.height * 0.25,
                //1
                ////////////////////////////////////////////////////////////////////
                width: MediaQuery.of(context).size.height * 0.25,
                color: Color(0XFF26282B),
                //// A
                borderRadius: 200,
                child: FutureBuilder(
                    //initialData:
                    future: test2(),
                    builder: (context, snapshot) {
                      return Padding(
                        padding: EdgeInsets.all(12),
                        child: SleekCircularSlider(
                          innerWidget: (value) {
                            return Container(
                              decoration: BoxDecoration(shape: BoxShape.circle),
                              width: MediaQuery.of(context).size.width *
                                  .14, //200,
                              height: MediaQuery.of(context).size.width *
                                  .14, //200,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * .1,
                                ),
                                child: FutureBuilder(
                                    future: test2(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return Column(children: [
                                          ArgonTimerButton(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .08,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .2,
                                            onTap: (startTimer, btnState) {
                                              try {
                                                if (mqtt_connection_status ==
                                                    true) {
                                                  toast_flag = 0;
                                                  if (refresh_flag == 1) {
                                                    selected_lamp = ourList[
                                                            HomeScreen
                                                                .roomIndex]
                                                        ['lamps'][0]['lid'];
                                                    gateway_id = ourList[
                                                                HomeScreen
                                                                    .roomIndex]
                                                            ['lamps'][0]
                                                        ['gateway_id'];
                                                    refresh_flag = 0;
                                                  } else {
                                                    print('o man');
                                                  }

                                                  publish(
                                                      '{"lid":$selected_lamp,"cmd":$slider_cmd,"echo":1}',
                                                      gateway_id);
                                                  toast_timer = Timer(
                                                      Duration(seconds: 2),
                                                      toastfunc);
                                                }
                                              } catch (e) {}
                                              setState(() {});
                                              if (btnState ==
                                                  ButtonState.Idle) {
                                                startTimer(1);
                                              }
                                            },
                                            child: Icon(
                                              Icons.wb_incandescent,
                                              color: light_master_color,
                                              size: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .07,
                                            ),
                                            loader: (timeLeft) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            200)),
                                                alignment: Alignment.center,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .25,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    .25,
                                                child: Icon(
                                                  Icons.wb_incandescent,
                                                  color: Colors.yellowAccent,
                                                ),
                                              );
                                            },
                                            borderRadius: 5.0,
                                            color: primaryColor,
                                            elevation: 0,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.01,
                                          ),
                                          Expanded(
                                            child: AutoSizeText(
                                              '${value.ceil().toInt().toString()}',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.03,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ]);
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    }),
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
                          onChange: (double value) {},
                          onChangeEnd: (value) {
                            slider_value = value;
                            slider_cmd = 201;
                            int int_slider_value = slider_value.toInt();

                            qry_add = selected_lamp;
                            try {
                              toast_flag = 0;
                              publish(
                                  '{"lid":$selected_lamp,"cmd":$slider_cmd,"data":$int_slider_value,"echo":1}',
                                  gateway_id);
                              toast_timer =
                                  Timer(Duration(seconds: 2), toastfunc);
                            } catch (e) {}
                            resp_test = slider_value;
                            setState(() {});
                          },
                          initialValue: resp_test,
                        ),
                      );
                    }),
              );
            }
          }
        });
  }
}

///listwheel widget(lamps) class
class lamp extends StatefulWidget {
  @override
  _lampState createState() => _lampState();
}

class _lampState extends State<lamp> {
  List data;
  int itemCount = 40;
  int selected = 0;
  FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);
  @override
  Widget build(BuildContext context) {
    selectedindex = 0;
    return RotatedBox(
        quarterTurns: -1,
        child: FutureBuilder(
            future: test2(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                    } else if (scrollNotification is ScrollUpdateNotification) {
                    } else if (scrollNotification is ScrollEndNotification) {
                      selectedindex = selected;
                      Future.delayed(const Duration(milliseconds: 500), () {
                        print('index:$selectedindex');
                        if (selected == selectedindex) {
                          if (mqtt_connection_status == true &&
                              mqtt_sub_status == true) {
                            var tagsJson =
                                jsonDecode(snapshot.data.toString())['data'];
                            List<dynamic> ourList =
                                tagsJson != null ? List.from(tagsJson) : null;
                            qry_add = selected_lamp;
                            if (selected_lamp <= 65) {
                              refresh_flag = 0;
                              toast_flag = 0;
                              print('$selected_lamp');
                              publish(
                                  '{"lid":$selected_lamp,"cmd":39,"data":0,"echo":0}',
                                  gateway_id);
                              toast_timer =
                                  Timer(Duration(seconds: 2), toastfunc);
                              qry_wait = true;
                              query_button_controller.add(1);
                            }
                          }
                        }
                      });
                    }
                    return true;
                  },
                  child: FutureBuilder<String>(
                      future: test2(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          // selected_lamp = lampList[0]['lid'];
                          // gateway_id = lampList[0]['gateway_id'];
                          return ListWheelScrollView(
                            physics: FixedExtentScrollPhysics(),
                            diameterRatio: 3,
                            perspective: 0.008,
                            offAxisFraction: 0,
                            onSelectedItemChanged: (x) async {
                              setState(() {
                                selected = x;
                                selected_lamp_id = x;
                                selected_lamp = lampList[x]['lid'];
                                gateway_id = lampList[x]['gateway_id'];
                              });
                            },
                            controller: _scrollController,
                            children: List.generate(
                                lampList.length,
                                (x) => Padding(
                                      padding:
                                          EdgeInsets.only(top: 20, bottom: 20),
                                      child: RotatedBox(
                                          quarterTurns: 1,
                                          child: AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 0),
                                              width: x == selected ? 50 : 50,
                                              height: x == selected ? 65 : 65,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: x == selected
                                                    ? Colors.teal[300]
                                                    : Colors.grey,
                                                shape: x == selected
                                                    ? BoxShape.rectangle
                                                    : BoxShape.rectangle,
                                                borderRadius: x == selected
                                                    ? BorderRadius.circular(400)
                                                    : BorderRadius.circular(
                                                        400),
                                              ),
                                              child: Text(
                                                lampList[x]['name'],
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                ),
                                              ))),
                                    )),
                            itemExtent: 200,
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      }),
                );
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}

Stream<int> countStream(int to) async* {
  for (int i = 1; i <= to; i++) {
    yield i;
  }
}

List<dynamic> lampList;
List<dynamic> lampList1;
List<dynamic> lampList2;
Future<String> test2() async {
  data = await getFileData(
      '/storage/emulated/0/Android/data/com.ligero.lihome/files/conh.json');

  var tagsJson = await jsonDecode(data)['data'];
  ourList = tagsJson != null ? List.from(tagsJson) : null;

  lampList = ourList[HomeScreen.roomIndex]['lamps'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['lamps'])
      : null;

  lampList1 = ourList[HomeScreen.roomIndex]['curtains'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['curtains'])
      : null;
  lampList2 = ourList[HomeScreen.roomIndex]['others'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['others'])
      : null;
  return data;
}

Future<String> test3() async {
  data = await getFileData(
      '/storage/emulated/0/Android/data/com.ligero.lihome/files/conh.json');

  var tagsJson = await jsonDecode(data)['data'];
  ourList = tagsJson != null ? List.from(tagsJson) : null;

  lampList = ourList[HomeScreen.roomIndex]['lamps'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['lamps'])
      : null;
  selected_lamp = lampList[0]['lid'];
  gateway_id = lampList[0]['gateway_id'];

  return data;
}
