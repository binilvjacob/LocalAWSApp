import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';
import 'package:smart_home/screens/curtainscreen.dart';
import 'package:smart_home/models/rooms_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/screens/lamppage.dart';
import 'package:smart_home/main.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'package:smart_home/screens/home_screen.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

String server_http_ip = 'http://192.168.0.109/echo';

var selected_lamp2 = lampList[0]['lid'];
var gateway_id2 = lampList[0]['gateway_id'];

/// test ip for esp http calls
var _newval = 3.0;
var _newval1 = 0;
var sendval = 0;

var power_button_cmd2 = 308;
var power_button_zone2 = 0;
var scene_button_cmd2 = 110;
var scene_button_zone2 = zone_add;
var selected_device_id2 = 320;
var slider_cmd2 = 100;
var slider_data2 = 0;
var qry_cmd2 = 34;
var qry_add2 = zone_add;

var qry_wait2 = false;
var device_id2 = 0;

double slider_value2 = 0;

/// selected lamp address

var scene_no;
Color button_color = Colors.white;
Color primaryColor = Color(0XFF26282B);

/// bg color of lamp page
Color activeColor1 = Colors.lightGreenAccent[200];

/// color for gradient
Color activeColor2 = Colors.teal[300];
//Color(0XFFCD2A12);

/// color for gradient
Color powerbuttoncolor2 = Colors.white;

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
List<Color> scene_color2 = [
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
  LampModel(name: 'Fan 1', lid: 2),
  LampModel(name: 'Fan 2', lid: 12),
  LampModel(name: 'Fan 3', lid: 4),
  LampModel(name: 'Fan 4', lid: 10),
  LampModel(name: 'Sprinkler 1', lid: 10),
  LampModel(name: 'Sprinkler 2', lid: 2),
  LampModel(name: 'Sprinkler 3', lid: 12),
  LampModel(name: 'Sprinkler 4', lid: 4),
  LampModel(name: 'Sprinkler 5', lid: 10),
  LampModel(name: 'Sprinkler 6', lid: 10),
  LampModel(name: 'Sprinkler 7', lid: 2),
  LampModel(name: 'Sprinkler 8', lid: 12),
  LampModel(name: 'Sprinkler 9', lid: 4),
  LampModel(name: 'Sprinkler 10', lid: 10),
  LampModel(name: 'AC 1', lid: 10),
  LampModel(name: 'AC 2', lid: 2),
  LampModel(name: 'Device', lid: 12),
  LampModel(name: 'Device', lid: 4),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 2),
  LampModel(name: 'Device', lid: 12),
  LampModel(name: 'Device', lid: 4),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 2),
  LampModel(name: 'Device', lid: 12),
  LampModel(name: 'Device', lid: 4),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 2),
  LampModel(name: 'Device', lid: 12),
  LampModel(name: 'Device', lid: 4),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 2),
  LampModel(name: 'Device', lid: 12),
  LampModel(name: 'Device', lid: 4),
  LampModel(name: 'Device', lid: 10),
  LampModel(name: 'Device', lid: 10),
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
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        body: SprinklerPage(),
      ),
    );
  }
}

class SprinklerPage extends StatefulWidget {
  final String title;

  SprinklerPage({@required this.title});
  @override
  _SprinklerPageState createState() => _SprinklerPageState();

  /// main app start
}

class _SprinklerPageState extends State<SprinklerPage> {
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
    print('hello');

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
                      print('cnnctd');
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
                      selected_lamp2 = lampList[0]['lid'];
                      gateway_id = lampList[0]['gateway_id'];
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),

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
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: SfRadialGauge(
                    enableLoadingAnimation: true,
                    axes: <RadialAxis>[
                      RadialAxis(
                        axisLabelStyle: GaugeTextStyle(color: Colors.white),
                        minimum: 0,
                        maximum: 6,
                        interval: 1,
                        pointers: <GaugePointer>[
                          RangePointer(
                            onValueChanged: (value) {
                              setState(() {
                                _newval = value;
                                print("Newval:$_newval");
                              });
                            },
                            onValueChangeEnd: (vaal) {
                              if (vaal > 0 && vaal < 0.2) {
                                setState(() {
                                  sendval = 0;
                                  _newval1 = 0;
                                  vaal = 0;
                                });
                              } else if (vaal > 0.2 && vaal < 1) {
                                setState(() {
                                  sendval = 8;
                                  _newval1 = 1;
                                  vaal = 1;
                                });
                              } else if (vaal > 1 && vaal < 2) {
                                setState(() {
                                  sendval = 25;
                                  _newval1 = 2;
                                  vaal = 2;
                                });
                              } else if (vaal > 2 && vaal < 3) {
                                setState(() {
                                  sendval = 50;
                                  _newval1 = 3;
                                  vaal = 3;
                                });
                              } else if (vaal > 3 && vaal < 4) {
                                setState(() {
                                  sendval = 65;
                                  _newval1 = 4;
                                  vaal = 4;
                                });
                              } else if (vaal > 4 && vaal < 5) {
                                setState(() {
                                  sendval = 75;
                                  _newval1 = 5;
                                  vaal = 5;
                                });
                              } else if (vaal > 5 && vaal < 6) {
                                setState(() {
                                  sendval = 95;
                                  _newval1 = 6;
                                  vaal = 6;
                                });
                              }
                              try {
                                toast_flag = 0;
                                publish(
                                    '{"lid":$selected_lamp2,"cmd":$slider_cmd2,"data":$sendval,"echo":1}',
                                    gateway_id2);
                                toast_timer =
                                    Timer(Duration(seconds: 2), toastfunc);
                              } catch (e) {}
                            },
                            value: _newval,
                            cornerStyle: CornerStyle.bothFlat,
                            enableDragging: true,
                            gradient: SweepGradient(
                                colors: <Color>[activeColor2, activeColor1],
                                stops: <double>[0.25, 0.75]),
                          )
                        ],
                        annotations: <GaugeAnnotation>[
                          GaugeAnnotation(
                              widget: Container(
                                  child: Text('$_newval1',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold))),
                              angle: 90,
                              positionFactor: .5)
                        ],
                      )
                    ]),
              ),
              //slider(),

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
                child: moodWidget2(),

                /// scenes widget
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
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
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      selected_lamp = lampList6[0]['lid'];
                                      gateway_id = lampList6[0]['gateway_id'];
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => HomePage(
                                                    title: widget.title,
                                                  )));
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
                                      selected_lamp1 = lampList5[0]['lid'];
                                      gateway_id1 = lampList5[0]['gateway_id'];
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
                                      color: activeColor2,
                                    ),
                                    onPressed: () {}),
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
  if (powerbuttoncolor2 == Colors.white) {
    powerbuttoncolor2 = Colors.blue;
  } else {
    powerbuttoncolor2 = Colors.white;
  }
  return 'jj';
}

/// function that handles query button operation
Future<String> getqueryData() async {
  qry_add2 = _lamps[selected_device_id2].lid;
  qry_icon_color2 = Colors.white;
}

bool temp = false;
bool temp2 = false;

Color light_master_color2 = Colors.white;

class testWidget extends StatefulWidget {
  @override
  _testWidgetState createState() => _testWidgetState();
}

class _testWidgetState extends State<testWidget> {
  //FToast fToast;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
                future: test2(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ArgonTimerButton(
                      elevation: 0,
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.11,
                      onTap: (startTimer, btnState) {
                        try {
                          toast_flag = 0;
                          publish(
                              '{"lid":$power_button_zone2,"cmd":$power_button_cmd2,"devid":$device_id2,"echo":1,"${ourList[HomeScreen.roomIndex]['gatename']}":1}',
                              gateway_id2);
                          toast_timer = Timer(Duration(seconds: 2), toastfunc);
                        } catch (e) {}
                        setState(() {});

                        if (btnState == ButtonState.Idle) {
                          startTimer(1);
                        }
                      },
                      child: Icon(
                        Icons.power_settings_new,
                        color: powerbuttoncolor2,
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
                  } else {
                    return CircularProgressIndicator();
                  }
                }),
          );
        }
      },
    );
  }
}

class moodWidget2 extends StatefulWidget {
  int scene_index;
  moodWidget2({
    @required this.scene_index,
  });
  @override
  _moodWidget2State createState() => _moodWidget2State();
}

class _moodWidget2State extends State<moodWidget2> {
  @override
  void initState() {
    super.initState();
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
                            return ArgonTimerButton(
                              height: MediaQuery.of(context).size.width * 0.18,
                              width: MediaQuery.of(context).size.width * 0.18,
                              onTap: (startTimer, btnState) {
                                setState(() {
                                  scene_no = index;
                                });
                                try {
                                  toast_flag = 0;
                                  publish(
                                      '{"data":$scene_button_zone2,"cmd":$scene_button_cmd2,"lid":$scene_no,"echo":1,"${ourList[HomeScreen.roomIndex]['gatename']}":1}',
                                      gateway_id2);
                                  toast_timer =
                                      Timer(Duration(seconds: 2), toastfunc);
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
                              color: scene_color2[index],
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

Color qry_icon_color2 = Colors.white;

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
              child: FutureBuilder(
                  future: test2(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ArgonTimerButton(
                        elevation: 0,
                        color: primaryColor,
                        width: MediaQuery.of(context).size.width * .1,
                        ////////////////////////////////////////////////////////////////////
                        height: MediaQuery.of(context).size.height * 0.05,
                        //1
                        ////////////////////////////////////////////////////////////////////
                        child: Icon(
                          Icons.info_outline,
                          color: qry_icon_color2,
                          size: 30,
                        ),
                        onTap: (startTimer, btnState) {
                          if (mqtt_connection_status == true &&
                              mqtt_sub_status == true) {
                            qry_add2 = selected_lamp2;
                            toast_flag = 0;
                            publish('{"lid":$qry_add2,"cmd":$qry_cmd2}',
                                ourList[HomeScreen.roomIndex]['gatesub']);
                            toast_timer =
                                Timer(Duration(seconds: 2), toastfunc);
                          } else {
                            qry_icon_color2 = Colors.white;
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
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
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
                          FutureBuilder(
                              future: test2(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  return ArgonTimerButton(
                                    height: MediaQuery.of(context).size.height *
                                        .08,
                                    width:
                                        MediaQuery.of(context).size.width * .2,
                                    onTap: (startTimer, btnState) {
                                      if (mqtt_connection_status == true &&
                                          mqtt_sub_status == true) {
                                        qry_add2 = selected_lamp2;
                                        toast_flag = 0;
                                        publish(
                                            '{"lid":$selected_lamp2,"cmd":$slider_cmd2,"echo":1}',
                                            gateway_id2);
                                        toast_timer = Timer(
                                            Duration(seconds: 2), toastfunc);
                                      } else {}

                                      setState(() {
                                        //    _fetchqueryData = getqueryData();
                                      });
                                      if (btnState == ButtonState.Idle) {
                                        startTimer(1);
                                      }
                                    },
                                    child: Icon(
                                      Icons.wb_incandescent,
                                      color: light_master_color2,
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
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                    //Colors.black54,
                                    elevation: 0,
                                  );
                                } else {
                                  return CircularProgressIndicator();
                                }
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

                  initialValue: slider_value2,
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
                    future: test2(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: EdgeInsets.all(12),
                          child: SleekCircularSlider(
                            innerWidget: (value) {
                              return Container(
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                width: MediaQuery.of(context).size.width *
                                    .14, //200,
                                height: MediaQuery.of(context).size.width *
                                    .14, //200,
                                child: Padding(
                                  padding: EdgeInsets.all(
                                    MediaQuery.of(context).size.width * .1,
                                  ),
                                  child: Column(children: [
                                    FutureBuilder(
                                        future: test2(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            return ArgonTimerButton(
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

                                                    publish(
                                                        '{"lid":$selected_lamp2,"cmd":$slider_cmd2,"echo":1}',
                                                        gateway_id2);
                                                    toast_timer = Timer(
                                                        Duration(seconds: 2),
                                                        toastfunc);
                                                  }
                                                } catch (e) {}

                                                setState(() {
                                                  //    _fetchqueryData = getqueryData();
                                                });
                                                if (btnState ==
                                                    ButtonState.Idle) {
                                                  startTimer(1);
                                                }
                                              },
                                              child: Icon(
                                                Icons.wb_incandescent,
                                                color: light_master_color2,
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
                                              //Colors.black54,
                                              elevation: 0,
                                            );
                                          } else {
                                            return CircularProgressIndicator();
                                          }
                                        }),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Expanded(
                                      child: AutoSizeText(
                                        '${value.ceil().toInt().toString()}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height *
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
                            onChange: (double value) {},
                            onChangeEnd: (value) {
                              slider_value2 = value;
                              slider_cmd2 = 201;
                              int int_slider_value2 = slider_value2.toInt();

                              qry_add2 = selected_lamp2;
                              try {
                                toast_flag = 0;
                                publish(
                                    '{"lid":$selected_lamp2,"cmd":$slider_cmd2,"data":$int_slider_value2,"echo":1}',
                                    gateway_id2);
                                toast_timer =
                                    Timer(Duration(seconds: 2), toastfunc);
                              } catch (e) {}
                              resp_test2 = slider_value2;
                              setState(() {});
                            },
                            initialValue: resp_test2,
                          ),
                        );
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
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
  List data;

  int itemCount = 40;

  FixedExtentScrollController _scrollController =
      FixedExtentScrollController(initialItem: 0);
  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: -1,
        child: FutureBuilder(
            future: test2(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var selectedindex;
                selectedindex = selected;
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                    } else if (scrollNotification is ScrollUpdateNotification) {
                    } else if (scrollNotification is ScrollEndNotification) {
                      selectedindex = selected;

                      Future.delayed(const Duration(milliseconds: 500), () {
                        if (selected == selectedindex) {
                          if (mqtt_connection_status == true &&
                              mqtt_sub_status == true) {
                            var tagsJson =
                                jsonDecode(snapshot.data.toString())['data'];
                            List<dynamic> ourList =
                                tagsJson != null ? List.from(tagsJson) : null;
                            qry_add = selected_lamp2;
                            if (selected_lamp2 <= 65) {
                              toast_flag = 0;
                              publish(
                                  '{"lid":$selected_lamp2,"cmd":205,"data":0,"echo":0}',
                                  gateway_id2);
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
                          return ListWheelScrollView(
                            physics: FixedExtentScrollPhysics(),
                            diameterRatio: 3,
                            perspective: 0.008,
                            offAxisFraction: 0,
                            onSelectedItemChanged: (x) async {
                              setState(() {
                                selected = x;
                                selected_lamp_id = x;
                                selected_lamp2 = lampList[selected]['lid'];
                                gateway_id2 = lampList[selected]['gateway_id'];
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
List<dynamic> lampList5;
List<dynamic> lampList6;
Future<String> test2() async {
  data = await getFileData(
      '/storage/emulated/0/Android/data/com.ligero.lihome/files/conh.json');

  var tagsJson = await jsonDecode(data)['data'];
  ourList = tagsJson != null ? List.from(tagsJson) : null;

  lampList = ourList[HomeScreen.roomIndex]['others'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['others'])
      : null;
  lampList5 = ourList[HomeScreen.roomIndex]['curtains'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['curtains'])
      : null;
  lampList6 = ourList[HomeScreen.roomIndex]['lamps'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['lamps'])
      : null;
  return data;
}
