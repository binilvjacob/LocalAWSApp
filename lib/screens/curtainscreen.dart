import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';
import 'package:smart_home/screens/lamppage.dart';
import 'package:smart_home/models/rooms_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/screens/sprinkler.dart';
import 'package:smart_home/main.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'dart:async';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'dart:convert';

String server_http_ip = 'http://192.168.0.109/echo';

var selected_lamp1 = lampList[0]['lid'];
var gateway_id1 = lampList[0]['gateway_id'];

/// test ip for esp http calls
var power_button_cmd1 = 208;
var power_button_zone1 = 0;
var scene_button_cmd1 = 234;
var scene_button_zone1 = zone_add;
var selected_curtain_id = 220;
var slider_cmd1 = 202;
var slider1_cmd1 = 221;
var slider_data1 = 0;
var qry_cmd1 = 26;
var qry_add1 = zone_add;
var qry_wait1 = false;

double slider_value1 = 0;

/// selected lamp address

var scene1_no;
Color button_color = Colors.white;
Color primaryColor = Color(0XFF26282B);

/// bg color of lamp page
Color activeColor1 = Colors.lightGreenAccent[200];

/// color for gradient
Color activeColor2 = Colors.teal[300];

/// color for gradient
Color powerbuttoncolor1 = Colors.white;

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
List<Color> scene_color1 = [
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
List<CurtainModel> _lamps = [
  /// lamp models initial value hard coded...
  /// to be updated from json config file
  CurtainModel(name: '9W', curid: 3),
  CurtainModel(name: '12W', curid: 12),
  CurtainModel(name: '7W', curid: 4),
  CurtainModel(name: '9W', curid: 10),
  CurtainModel(name: '7W', curid: 10),
  CurtainModel(name: '9W', curid: 2),
  CurtainModel(name: '12W', curid: 12),
  CurtainModel(name: '7W', curid: 45),
  CurtainModel(name: '9W', curid: 10),
  CurtainModel(name: '7W', curid: 10),
  CurtainModel(name: '9W', curid: 26),
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
        body: CurtainPage(),
      ),
    );
  }
}

class CurtainPage extends StatefulWidget {
  final String title;
  CurtainPage({@required this.title});
  @override
  _CurtainPageState createState() => _CurtainPageState();

  /// main app start
}

class _CurtainPageState extends State<CurtainPage> {
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
      _lamps[i].curid = response_dummy['lid${i + 1}'];
    }
    lamp_count = response_dummy.length;

    /// total number of lamps in a room

    return new WillPopScope(
      onWillPop: () async {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
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
                      selected_lamp1 = lampList[0]['lid'];
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.04),

              Container(
                ////////////////////////////////////////////////////////////////////
                height: MediaQuery.of(context).size.height * 0.14, //1
                ////////////////////////////////////////////////////////////////////
                color: primaryColor,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: lamp(),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),

              ///slider for
              //slider(),

              /// middle circular slider widget
              SizedBox(height: MediaQuery.of(context).size.height * .02),
              Container(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     FutureBuilder(
                    //         future: test2(),
                    //         builder: (context, snapshot) {
                    //           if (snapshot.hasData) {
                    //             return ArgonTimerButton(
                    //               roundLoadingShape: false,
                    //               height:
                    //                   MediaQuery.of(context).size.width * 0.12,
                    //               width:
                    //                   MediaQuery.of(context).size.width * 0.2,
                    //               borderRadius: 10,
                    //               color: Colors.teal,
                    //               child: Text(
                    //                 'Open',
                    //                 style: TextStyle(
                    //                   color: Colors.white,
                    //                   fontSize:
                    //                       MediaQuery.of(context).size.height *
                    //                           0.02,
                    //                 ),
                    //               ),
                    //               loader: (timeLeft) {
                    //                 return Container(
                    //                   decoration: BoxDecoration(
                    //                       color: Colors.teal,
                    //                       borderRadius:
                    //                           BorderRadius.circular(50)),
                    //                   margin: EdgeInsets.all(5),
                    //                   alignment: Alignment.center,
                    //                   child: SpinKitWave(
                    //                     color: Colors.white,
                    //                     size: 15,
                    //                   ),
                    //                 );
                    //               },
                    //               onTap: (startTimer, btnState) {
                    //                 try {
                    //                   if (mqtt_connection_status == true &&
                    //                       mqtt_sub_status == true) {
                    //                     qry_add1 = selected_lamp1;
                    //                     toast_flag = 0;
                    //                     publish(
                    //                         '{"lid":$selected_lamp1,"cmd":203,"echo":1}',
                    //                         gateway_id1);
                    //                     toast_timer = Timer(
                    //                         Duration(seconds: 2), toastfunc);
                    //                   }
                    //                 } catch (e) {}
                    //                 if (btnState == ButtonState.Idle) {
                    //                   startTimer(2);
                    //                 }
                    //               },
                    //             );
                    //           } else {
                    //             return CircularProgressIndicator();
                    //           }
                    //         })
                    //   ],
                    // ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder(
                            future: test2(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return ArgonTimerButton(
                                  roundLoadingShape: false,
                                  height:
                                      MediaQuery.of(context).size.width * 0.15,
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  onTap: (startTimer, btnState) {
                                    try {
                                      if (mqtt_connection_status == true &&
                                          mqtt_sub_status == true) {
                                        qry_add1 = selected_lamp1;
                                        toast_flag = 0;
                                        publish(
                                            '{"lid":$selected_lamp1,"cmd":204,"echo":1}',
                                            gateway_id1);
                                        toast_timer = Timer(
                                            Duration(seconds: 2), toastfunc);
                                      }
                                    } catch (e) {}

                                    if (btnState == ButtonState.Idle) {
                                      startTimer(2);
                                    }
                                  },
                                  borderRadius: 10,
                                  // Colors.deepOrange,
                                  color: Colors.teal,
                                  child: Text(
                                    'Toggle',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize:
                                          MediaQuery.of(context).size.height *
                                              0.02,
                                    ),
                                  ),
                                  loader: (timeLeft) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.teal,
                                          borderRadius:
                                              BorderRadius.circular(50)),
                                      //margin: EdgeInsets.all(5),
                                      alignment: Alignment.centerRight,
                                      width: MediaQuery.of(context).size.width *
                                          0.12,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.2,
                                      child: SpinKitWave(
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                    );
                                  },
                                );
                              } else {
                                return CircularProgressIndicator();
                              }
                            })
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.08,
              ),
              Container(
                decoration: BoxDecoration(
                    color: primaryColor,
                    //
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
                child: moodWidget1(),

                /// scenes widget
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
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
                                      selected_lamp = lampList4[0]['lid'];
                                      gateway_id = lampList4[0]['gateway_id'];
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
                                      color: activeColor2,
                                    ),
                                    onPressed: () {}),
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
                                      selected_lamp2 = lampList3[0]['lid'];
                                      gateway_id2 = lampList3[0]['gateway_id'];
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
  if (powerbuttoncolor1 == Colors.white) {
    powerbuttoncolor1 = Colors.blue;
  } else {
    powerbuttoncolor1 = Colors.white;
  }
  return 'jj';
}

/// function that handles query button operation
Future<String> getqueryData() async {
  qry_add1 = _lamps[selected_curtain_id].curid;
  qry_icon_color1 = Colors.white;
}

bool temp = false;
bool temp2 = false;

Color light_master_color1 = Colors.white;

class testWidget extends StatefulWidget {
  @override
  _testWidgetState createState() => _testWidgetState();
}

class _testWidgetState extends State<testWidget> {
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
                              '{"lid":$power_button_zone,"cmd":$power_button_cmd,"echo":1}',
                              gateway_id1);
                          toast_timer = Timer(Duration(seconds: 2), toastfunc);
                        } catch (e) {}
                        setState(() {});

                        if (btnState == ButtonState.Idle) {
                          startTimer(1);
                        }
                      },
                      child: Icon(
                        Icons.power_settings_new,
                        color: powerbuttoncolor1,
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

///scenes widget
class moodWidget1 extends StatefulWidget {
  int scene_index1;
  moodWidget1({
    @required this.scene_index1,
  });
  @override
  _moodWidget1State createState() => _moodWidget1State();
}

class _moodWidget1State extends State<moodWidget1> {
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
                                  scene1_no = index;
                                });
                                try {
                                  toast_flag = 0;
                                  publish(
                                      '{"data":$scene_button_zone1,"cmd":$scene_button_cmd1,"lid":$scene1_no,"echo":1}',
                                      ourList[HomeScreen.roomIndex]['gatesub']);
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
                              color: scene_color1[index],
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

Color qry_icon_color1 = Colors.white;

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
                  color: qry_icon_color1,
                  size: 30,
                ),
                onTap: (startTimer, btnState) {
                  if (mqtt_connection_status == true &&
                      mqtt_sub_status == true) {
                    qry_add1 = selected_lamp1;
                  } else {
                    qry_icon_color1 = Colors.white;
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

///slider widget
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

                  initialValue: slider_value1,
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
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.1,
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
                              slider_value1 = value;
                              slider_cmd = 222;
                              int int_slider_value1 = slider_value1.toInt();

                              qry_add1 = selected_lamp1;
                              try {
                                toast_flag = 0;
                                publish(
                                    '{"lid":$selected_lamp1,"cmd":202,"data":$int_slider_value1,"echo":1}',
                                    gateway_id1);
                                toast_timer =
                                    Timer(Duration(seconds: 2), toastfunc);
                              } catch (e) {}
                              resp_test1 = slider_value1;
                              setState(() {});
                            },
                            initialValue: resp_test1,
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

///lamp state
class lamp extends StatefulWidget {
  @override
  _lampState createState() => _lampState();
}

class _lampState extends State<lamp> {
  // double itemWidth = 200.0;
  int itemCount = 11;
  int selected = 0;
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
                return NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                    } else if (scrollNotification is ScrollUpdateNotification) {
                    } else if (scrollNotification is ScrollEndNotification) {
                      if (mqtt_connection_status == true &&
                          mqtt_sub_status == true) {
                        qry_add1 = selected_lamp1;

                        qry_wait1 = true;
                        query_button_controller.add(1);
                      }
                    }
                    return true;
                  },
                  child: FutureBuilder(
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
                                selected_curtain_id = x;
                                selected_lamp1 = lampList[x]['lid'];
                                gateway_id1 = lampList[x]['gateway_id'];
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
                                                ///Colors.red
                                                color: x == selected

                                                    ///red
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
List<dynamic> lampList3;
List<dynamic> lampList4;
Future<String> test2() async {
  data = await getFileData(
      '/storage/emulated/0/Android/data/com.ligero.lihome/files/conh.json');

  var tagsJson = await jsonDecode(data)['data'];
  ourList = tagsJson != null ? List.from(tagsJson) : null;

  lampList = ourList[HomeScreen.roomIndex]['curtains'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['curtains'])
      : null;

  lampList3 = ourList[HomeScreen.roomIndex]['others'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['others'])
      : null;

  lampList4 = ourList[HomeScreen.roomIndex]['lamps'] != null
      ? List.from(ourList[HomeScreen.roomIndex]['lamps'])
      : null;

  return data;
}
