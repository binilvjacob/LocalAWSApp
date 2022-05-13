import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:smart_home/screens/curtainscreen.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'package:smart_home/models/rooms_model.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:smart_home/screens/sprinkler.dart';
import 'package:smart_home/main.dart';
import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

String server_http_ip = 'http://192.168.0.109/echo';

/// test ip for esp http calls
var power_button_cmd = 208;
var power_button_zone = 210;
var scene_button_cmd = 234;
var scene_button_zone = 210;
var selected_lamp_id = 0;
var slider_cmd = 208;
var slider_data = 0;
var qry_cmd = 24;
var qry_add = 0;
double resp_test = 0;
double slider_value = 0;
Future<String> _fetchData;
Future<String> _fetchsliderData;
Future<String> _fetchqueryData;
List<Future<String>> _fetchsceneData = [
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData(),
  getsceneData()
];

/// selected lamp address

var scene_no;
Color button_color = Colors.white;
Color primaryColor = Color(0XFF26282B);

/// bg color of lamp page
Color activeColor1 = Color(0XFFED560D);

/// color for gradient
Color activeColor2 = Color(0XFFCD2A12);

/// color for gradient
Color powerbuttoncolor = Colors.white60;

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
];
List<Color> gradientColors = [activeColor1, activeColor2];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  final String title;
  HomePage({@required this.title});
  @override
  _HomePageState createState() => _HomePageState();

  /// main app start
}

class _HomePageState extends State<HomePage> {
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
      /// main widget start (home page)
      backgroundColor: Color(0XFF26282B), //primaryColor,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01, // Athul
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  child: ClayContainer(
                    ////////////////////////////////////////////////////////////////////
                    height: MediaQuery.of(context).size.height * 0.06, //1
                    ////////////////////////////////////////////////////////////////////
                    width: MediaQuery.of(context).size.width * 0.11,
                    borderRadius: 10,
                    color: Color(0XFF26282B),
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ));
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
            query(),

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
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
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
  final http.Response response = await http.post(
    server_http_ip,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'data': 5,
      'cmd': power_button_cmd,
      'lid': power_button_zone,
      //'sid': '87',
    }),
  );
  var response_json = jsonDecode(response.body);
  if (response.statusCode == 200) {
    //print(response.body);
    /// changing power button ui from response data
    if (response_json['cmd'] == 208 &&
        response_json['lid'] == power_button_zone) {
      power_button_cmd = 212;
      powerbuttoncolor = Colors.red;
    } else if (response_json['cmd'] == 212 &&
        response_json['lid'] == power_button_zone) {
      power_button_cmd = 208;
      powerbuttoncolor = Colors.white;
    }
    // print(response_json['lid']);
    return 'gj';
  } else {
    throw Exception('Failed Response');
  }
}

/// function that handles query button operation
Future<String> getqueryData() async {
  qry_add = _lamps[selected_lamp_id].lid;
  qry_icon_color = Colors.white;
  final http.Response response = await http.post(
    server_http_ip,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'data': 5,
      'cmd': qry_cmd,
      'lid': qry_add,
      'sid': 87,
    }),
  );
  var response_json = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print(response_json);
    if (response_json['cmd'] == qry_cmd) {
      qry_icon_color = Colors.green;
    } else {
      qry_icon_color = Colors.white;
    }
    return 'gj';
  } else {
    qry_icon_color = Colors.white;
    throw Exception('Failed Response');
  }
}

bool temp = false;
bool temp2 = false;

Color light_master_color = Colors.white;
Future<String> getsceneData() async {
  for (int i = 0; i < 12; i++) {
    scene_color[i] = Colors.black54;
  }
  print('entered scene');
  print('selected lamp ${_lamps[selected_lamp_id].lid}');
  final http.Response response = await http.post(
    server_http_ip,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'data': scene_no,
      'cmd': scene_button_cmd,
      'lid': scene_button_zone,
      //'sid': '87',
    }),
  );
  var response_json = jsonDecode(response.body);
  print(response_json);
  if (response.statusCode == 200) {
    if (response_json['cmd'] == 234 &&
        response_json['lid'] == scene_button_zone) {
      //  temp = true;
      print("ok");
      scene_color[scene_no] = Colors.deepOrange;
      // scene_button_cmd = 208;
    } else {
      scene_color[response_json['data']] = Colors.black;
    }

    // temp = true;
    // scene_color[scene_no] = Colors.deepOrange;
    return 'gj';
  } else {
    //  temp = false;
    throw Exception('Failed Response');
  }
}

Future<String> getsliderData() async {
  for (int i = 0; i < 12; i++) {
    scene_color[i] = Colors.black54;
  }
  print('entered slider ');
  final http.Response response = await http.post(
    server_http_ip,
    headers: <String, String>{
      'Conten-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, int>{
      'data': slider_value.toInt(),
      'cmd': slider_cmd,
      'lid': _lamps[selected_lamp_id].lid,
      'sid': 87,
    }),
  );
  if (response.statusCode == 200) {
    var response_json = jsonDecode(response.body);
    print(response_json);

    if (response_json['cmd'] == 201 &&
        response_json['lid'] == _lamps[selected_lamp_id].lid) {
      resp_test = slider_value;
      slider_cmd = 212;
      light_master_color = Colors.yellowAccent;
      //  temp = true;
      print("ok");
    } else if (response_json['cmd'] == 208 &&
        response_json['lid'] == _lamps[selected_lamp_id].lid) {
      resp_test = 100;
      slider_value = 100;
      slider_cmd = 212;
      light_master_color = Colors.yellowAccent;
    } else if (response_json['cmd'] == 212 &&
        response_json['lid'] == _lamps[selected_lamp_id].lid) {
      resp_test = 0;
      slider_value = 0;
      slider_cmd = 208;
      light_master_color = Colors.white;
    }

    print("ok");

    // if (light_master_color == Colors.white) {
    //   slider_value = 0;
    //   light_master_color = Colors.yellowAccent;
    // } else {
    //   slider_value = 100;
    //   light_master_color = Colors.white;
    // }
    return 'gj';
  } else {
    //temp = false;
    throw Exception('Failed Response');
  }
}

class testWidget extends StatefulWidget {
  @override
  _testWidgetState createState() => _testWidgetState();
}

class _testWidgetState extends State<testWidget> {
  @override
  void initState() {
    super.initState();
    _fetchData = getData();
  }

  @override
  Widget build(BuildContext context) {
    print('building power button');
    return FutureBuilder<String>(
      future: _fetchData,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: ArgonTimerButton(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.11,
                onTap: (startTimer, btnState) {
                  setState(() {
                    _fetchData = getData();
                  });

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
          } else if (snapshot.hasData) {
            return Center(
              child: ArgonTimerButton(
                height: MediaQuery.of(context).size.height * 0.06,
                width: MediaQuery.of(context).size.width * 0.11,
                onTap: (startTimer, btnState) {
                  setState(() {
                    _fetchData = getData();
                  });

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
        }

        return CircularProgressIndicator();
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
    for (int i = 0; i < 12; i++) {
      _fetchsceneData[i] = getsceneData();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          return FutureBuilder(
              future: _fetchsceneData[index],
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: ArgonTimerButton(
                        height: MediaQuery.of(context).size.width * 0.18,
                        width: MediaQuery.of(context).size.width * 0.18,
                        onTap: (startTimer, btnState) {
                          print("temp value $temp");
                          setState(() {
                            scene_no = index;

                            print("temp value $temp");
                            print("scene number $scene_no");

                            _fetchsceneData[index] = getsceneData();
                          });

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
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: ArgonTimerButton(
                        height: MediaQuery.of(context).size.width * 0.18,
                        width: MediaQuery.of(context).size.width * 0.18,
                        onTap: (startTimer, btnState) {
                          print("temp value $temp");
                          setState(() {
                            scene_no = index;
                            _fetchsceneData[index] = getsceneData();
                          });
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
                }
                return CircularProgressIndicator();
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
  void initState() {
    _fetchqueryData = getqueryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _fetchqueryData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .7),
                child: ArgonTimerButton(
                  elevation: 0,
                  color: primaryColor,

                  /// A
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
                    setState(() {
                      _fetchqueryData = getqueryData();
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
            } else if (snapshot.hasData) {
              return Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * .7),
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
                    setState(() {
                      _fetchqueryData = getqueryData();
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
          }
          return CircularProgressIndicator();
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
    _fetchsliderData = getsliderData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
        future: _fetchsliderData,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return ClayContainer(
                ////////////////////////////////////////////////////////////////////
                height: MediaQuery.of(context).size.height * 0.25, //1
                ////////////////////////////////////////////////////////////////////
                width: MediaQuery.of(context).size.height * 0.25,
                color: Color(0XFF26282B), //// A
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
                                setState(() {
                                  _fetchsliderData = getsliderData();
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
                              color: primaryColor, //Colors.black54,
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
                      setState(() {
                        _fetchsliderData = getsliderData();
                      });
                    },
                    initialValue: resp_test,
                  ),
                ),
              );
            } else if (snapshot.hasData) {
              return ClayContainer(
                ////////////////////////////////////////////////////////////////////
                height: MediaQuery.of(context).size.height * 0.25, //1
                ////////////////////////////////////////////////////////////////////
                width: MediaQuery.of(context).size.height * 0.25,
                color: Color(0XFF26282B), //// A
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
                                setState(() {
                                  _fetchsliderData = getsliderData();
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
                    initialValue: resp_test,
                    onChangeEnd: (value) {
                      slider_value = value;
                      slider_cmd = 201;
                      setState(() {
                        _fetchsliderData = getsliderData();
                      });
                    },
                  ),
                ),
              );
            }
          }
          return ClayContainer(
            ////////////////////////////////////////////////////////////////////
            height: MediaQuery.of(context).size.height * 0.25, //1
            ////////////////////////////////////////////////////////////////////

            width: MediaQuery.of(context).size.height * 0.25,
            color: Color(0XFF26282B), //// A
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
                          onTap: (startTimer, btnState) {},
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
                  animationEnabled: false,
                  spinnerMode: false,
                  spinnerDuration: 100,
                  //animDurationMultiplier: 0.1,
                  customColors: CustomSliderColors(
                    trackColor: Colors.white,
                    progressBarColors: gradientColors,
                    hideShadow: true,
                    shadowColor: Colors.transparent,
                  ),
                ),
                onChange: (double value) {},
                initialValue: slider_value,
              ),
            ),
          );
        });
  }
}

class lamp extends StatefulWidget {
  @override
  _lampState createState() => _lampState();
}

class _lampState extends State<lamp> {
  @override
  Widget build(BuildContext context) {
    print('building row 2 mood');
    return ListView.builder(
      semanticChildCount: 1,
      scrollDirection: Axis.horizontal,
      itemCount: lamp_count,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: SafeArea(
            child: Container(
              width: MediaQuery.of(context).size.width * .9,
              height: MediaQuery.of(context).size.width * .3,
              margin: EdgeInsets.only(left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  activecolor1[index],
                  activecolor2[index],
                ]),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(6),
                child: ListTile(
                  leading: Icon(
                    Icons.lightbulb,
                    color: Colors.white,
                    size: 34,
                  ),
                  title: Text(
                    'lamp ${index + 1}   ${_lamps[index].lid}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 22,
                    ),
                  ),
                  subtitle: Text(
                    _lamps[index].name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ),
          onTap: () {
            selected_lamp_id = index;
            setState(() {
              for (int i = 0; i < 12; i++) {
                activecolor1[i] = Colors.black54;
                activecolor2[i] = Colors.black54;
              }
              activecolor1[index] = Color(0XFFED560D);
              activecolor2[index] = Color(0XFFCD2A12);
            });
          },
        );
      },
    );
  }
}
