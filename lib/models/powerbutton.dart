// import 'package:clay_containers/clay_containers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:smart_home/screens/curtainscreen.dart';
// import 'package:smart_home/screens/home_screen.dart';
// import 'package:smart_home/models/rooms_model.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:smart_home/screens/sprinkler.dart';
// import 'package:smart_home/main.dart';
// import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// String server_http_ip = 'https://ptsv2.com/t/der/post';
// List<Icon> scene_Icons = [
//   Icon(Icons.lightbulb),
//   Icon(Icons.brightness_high),
//   Icon(Icons.brightness_6),
//   Icon(Icons.nights_stay),
//   Icon(Icons.nightlife),
//   Icon(Icons.invert_colors_sharp),
//   Icon(Icons.local_dining_rounded),
//   Icon(Icons.sports_esports_outlined),
//   Icon(Icons.book_outlined),
//   Icon(Icons.border_all),
//   Icon(Icons.ac_unit),
//   Icon(Icons.settings_input_antenna_outlined),
// ];
//
// var scene_no;
// Color button_color = Colors.white;
//
// List<Color> scene_color = [
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
// ];
//
// List<Color> activecolor1 = [
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
// ];
//
// List<Color> activecolor2 = [
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
// ];
//
// List<LampModel> _lamps = [
//   LampModel(name: '9W', lid: 2),
//   LampModel(name: '12W', lid: 12),
//   LampModel(name: '7W', lid: 4),
//   LampModel(name: '9W', lid: 10),
//   LampModel(name: '7W', lid: 10),
// ];
//
// Color primaryColor = Color(0XFF26282B);
// Color activeColor1 = Color(0XFFED560D);
// Color activeColor2 = Color(0XFFCD2A12);
// Color powerbuttoncolor = Colors.white60;
//
// List<Color> gradientColors = [activeColor1, activeColor2];
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // SystemChrome.setEnabledSystemUIOverlays([]);
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or simply save your changes to "hot reload" in a Flutter IDE).
//           // Notice that the counter didn't reset back to zero; the application
//           // is not restarted.
//           primarySwatch: Colors.blue),
//       home: HomePage(),
//     );
//   }
// }
//
// // class DetailScreen extends StatefulWidget {
// //   final String title;
// //   DetailScreen({@required this.title});
// //
// //   @override
// //   _DetailScreenState createState() => _DetailScreenState();
// // }
// class HomePage extends StatefulWidget {
//   final String title;
//   HomePage({@required this.title});
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   var _value = 0.0;
//   var tempp = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     for (int i = 0; i < response_dummy.length; i++) {
//       tempp = i + 1;
//       _lamps[i].lid = response_dummy['lid$tempp'];
//     }
//     lamp_count = response_dummy.length;
//     // print(responsed_dummy_json);
//     // print(server_http_response);
//     return Scaffold(
//       backgroundColor: Color(0XFF26282B), //primaryColor,
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               //// A
//               height: MediaQuery.of(context).size.height * 0.01, // Athul
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 GestureDetector(
//                   child: ClayContainer(
//                     ////////////////////////////////////////////////////////////////////
//                     height: MediaQuery.of(context).size.height * 0.06, //1
//                     ////////////////////////////////////////////////////////////////////
//                     width: MediaQuery.of(context).size.width * 0.11,
//                     borderRadius: 10,
//                     color: Color(0XFF26282B),
//
//                     /// A
//                     child: Padding(
//                       padding: EdgeInsets.all(4),
//                       child: Center(
//                         child: Icon(
//                           Icons.arrow_back,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HomeScreen(),
//                         ));
//                   },
//                 ),
//                 Text(
//                   widget.title,
//                   //'Living Room',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//
//                 //   /// Athul
//                 // ),
//                 testWidget(),
//               ],
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02), ////A
//             Container(
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.14, //1
//               ////////////////////////////////////////////////////////////////////
//               color: primaryColor,
//
//               /// A
//               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
//               child: lamp(),
//             ),
//             Padding(
//               padding:
//                   EdgeInsets.only(left: MediaQuery.of(context).size.width * .7),
//               child: ArgonTimerButton(
//                 elevation: 0,
//                 color: primaryColor,
//
//                 /// A
//                 width: MediaQuery.of(context).size.width * .1,
//
//                 ////////////////////////////////////////////////////////////////////
//                 height: MediaQuery.of(context).size.height * 0.05, //1
//                 ////////////////////////////////////////////////////////////////////
//
//                 child: Icon(
//                   Icons.info_outline,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 onTap: (startTimer, btnState) {
//                   if (btnState == ButtonState.Idle) {
//                     startTimer(1);
//                   }
//                 },
//                 loader: (timeLeft) {
//                   return Icon(
//                     Icons.check_circle_outline,
//                     color: Colors.green,
//                   );
//                 },
//               ),
//             ),
//             SizedBox(
//               //// A
//               height: MediaQuery.of(context).size.height * 0.05, // Athul
//             ),
//             ClayContainer(
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.25, //1
//               ////////////////////////////////////////////////////////////////////
//
//               width: MediaQuery.of(context).size.height * 0.25,
//               color: Color(0XFF26282B), //// A
//               borderRadius: 200,
//               child: Padding(
//                 padding: EdgeInsets.all(12),
//                 child: SleekCircularSlider(
//                     innerWidget: (value) {
//                       return Container(
//                         decoration: BoxDecoration(
//                             // color: Colors.transparent, //Colors.orange,
//
//                             /// A
//                             shape: BoxShape.circle),
//                         width: MediaQuery.of(context).size.width * .14, //200,
//                         height: MediaQuery.of(context).size.width * .14, //200,
//                         child: Padding(
//                           padding: EdgeInsets.all(
//                             MediaQuery.of(context).size.width * .1,
//                           ),
//                           child: Column(children: [
//                             ArgonTimerButton(
//                               // height: MediaQuery.of(context).size.width * 0.1,
//                               // width: MediaQuery.of(context).size.width * 0.1,
//
//                               height: MediaQuery.of(context).size.height * .08,
//                               width: MediaQuery.of(context).size.width * .2,
//                               onTap: (startTimer, btnState) {
//                                 if (btnState == ButtonState.Idle) {
//                                   startTimer(1);
//                                 }
//                               },
//                               child: Icon(
//                                 Icons.wb_incandescent,
//                                 color: Colors.white,
//                                 size: MediaQuery.of(context).size.height * .07,
//                               ),
//                               loader: (timeLeft) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.black,
//                                       borderRadius: BorderRadius.circular(200)),
//                                   // margin: EdgeInsets.all(
//                                   //   MediaQuery.of(context).size.width * .03,
//                                   // ),
//                                   alignment: Alignment.center,
//                                   width:
//                                       MediaQuery.of(context).size.width * .25,
//                                   height:
//                                       MediaQuery.of(context).size.width * .25,
//                                   child: Icon(
//                                     Icons.wb_incandescent,
//                                     color: Colors.yellowAccent,
//                                   ),
//                                 );
//                               },
//                               borderRadius: 5.0,
//                               color: primaryColor, //Colors.black54,
//
//                               elevation: 0,
//                             ),
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.01,
//                             ),
//                             Expanded(
//                               child: AutoSizeText(
//                                 '${value.ceil().toInt().toString()}',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize:
//                                         MediaQuery.of(context).size.height *
//                                             0.03,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ]),
//                         ),
//                       );
//                     },
//                     appearance: CircularSliderAppearance(
//                       customColors: CustomSliderColors(
//                         progressBarColors: gradientColors,
//                         hideShadow: true,
//                         shadowColor: Colors.transparent,
//                       ),
//                     ),
//                     onChange: (double value) {
//                       print(MediaQuery.of(context).size.height);
//                       print(value);
//                     }),
//               ),
//             ),
//             SizedBox(
//                 height: MediaQuery.of(context).size.height * .06), ///// Athul
//
//             /// A
//             Container(
//               // height: MediaQuery.of(context).size.height * .20,
//
//               decoration: BoxDecoration(
//                   color: primaryColor,
//
//                   ///A
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: primaryColor, //Colors.black12,
//                     )
//                   ]),
//
//               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.16, //1
//               ////////////////////////////////////////////////////////////////////
//
//               child: FutureBuilder(
//                 initialData: moodWidget,
//                 builder: (ctx, snapshot) {
//                   // Checking if future is resolved or not
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     // If we got an error
//                     if (snapshot.hasError) {
//                       //print('entered Tap 3');
//                       return moodWidget(
//                           // scene_index: index,
//                           );
//
//                       // if we got our data
//                     } else if (snapshot.hasData) {
//                       //  print('entered Tap 2');
//                       // Extracting data from snapshot object
//                       final data = snapshot.data as String;
//                       return moodWidget(
//                           // scene_index: index
//                           );
//                     }
//                   }
//
//                   // Displaying LoadingSpinner to indicate waiting state
//                   return moodWidget();
//                   //CircularProgressIndicator();
//                 },
//
//                 // Future that needs to be resolved
//                 // inorder to display something on the Canvas
//                 // future: getsceneData(),
//               ),
//             ),
//             SizedBox(
//               /// A
//               height: MediaQuery.of(context).size.height * .02, // Athul
//             ),
//
//             SizedBox(
//               /// A
//               height: MediaQuery.of(context).size.height * 0.09, // Athul
//             ),
//             Container(
//               //parent container for bottom bar
//
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.08, //1
//               ////////////////////////////////////////////////////////////////////
//               color: primaryColor, //// A
//               child: Row(
//                 // mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(children: [
//                     Expanded(
//                       child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               // padding: EdgeInsets.fromLTRB(
//                               //     MediaQuery.of(context).size.width * .01,
//                               //     MediaQuery.of(context).size.width * .05,
//                               //     0,
//                               //     0),
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.lightbulb_outline,
//                                     color: activeColor1,
//                                   ),
//                                   onPressed: () {
//                                     print("You Pressed the icon!");
//                                   }),
//                             ),
//                           ]),
//                     ),
//                     Row(children: [
//                       Text(
//                         'Lamp',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ])
//                   ]),
//                   Column(children: [
//                     Expanded(
//                       child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.border_all,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => CurtainPage(
//                                                   title: widget.title,
//                                                 )));
//                                     print("You Pressed the icon!");
//                                   }),
//                             ),
//                           ]),
//                     ),
//                     Row(children: [
//                       Container(),
//                       Text(
//                         'Curtain',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ])
//                   ]),
//                   Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Row(children: [
//                             Container(
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.filter_tilt_shift_outlined,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => SprinklerPage(
//                                                   title: widget.title,
//                                                 )));
//                                     print("You Pressed the icon!");
//                                   }),
//                             ),
//                           ]),
//                         ),
//                         Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Sprinkler',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ])
//                       ]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String percentageModifier(double value) {
//     final roundedValue = value.ceil().toInt().toString();
//     return '$roundedValue 0x00B0 C';
//   }
// }
//
// class MenuItem extends StatefulWidget {
//   final IconData iconName;
//   final Text name;
//   final int scene_no;
//   final Color scene_color;
//
//   const MenuItem(
//       {Key key,
//       this.iconName,
//       this.name,
//       @required this.scene_no,
//       this.scene_color})
//       : super(key: key);
//   @override
//   _MenuItemState createState() => _MenuItemState();
// }
//
// class _MenuItemState extends State<MenuItem> {
//   // bool isSelected = false;
//   List<bool> test = [
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     print('hh ${test[0]}');
//
//     return GestureDetector(
//       onTap: () {
//         // code to send scene number to AWS broker
//
//         setState(() {
//           for (int i = 0; i < 12; i++) {
//             test[i] = false;
//           }
//           test[widget.scene_no - 1] = true;
//           print('bb${test[2]}');
//           //  isSelected = true;
//         });
//       },
//       child: ClayContainer(
//         height: MediaQuery.of(context).size.width * 1 / 7,
//         width: MediaQuery.of(context).size.width * 1 / 7,
//         borderRadius: 10,
//         color: primaryColor,
//         surfaceColor: test[widget.scene_no - 1] ? activeColor2 : primaryColor,
//         child: Icon(widget.iconName, color: Colors.white, size: 20),
//       ),
//     );
//   }
// }
//
// //////////////////////////////
//
// Future<String> getData() async {
//   //print("enters power button");
//   final http.Response response = await http.post(
//     server_http_ip,
//     headers: <String, String>{
//       'Conten-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'data': '5',
//       'cmd': '9',
//       'lid': '6',
//       'sid': '87',
//     }),
//   );
//   if (response.statusCode == 200) {
//     // Map<String, dynamic> map =
//     //     jsonDecode(response_dummy) as Map<String, dynamic>;
//     // server_http_response = jsonDecode(map["lid1"]);
//
//     // print('power ok');
//
//     if (powerbuttoncolor == Colors.red) {
//       powerbuttoncolor = Colors.white;
//     } else {
//       powerbuttoncolor = Colors.red;
//     }
//     return 'gj';
//     print(server_http_response);
//   } else {
//     throw Exception('Failed Response');
//   }
// }
//
// bool temp = false;
// bool temp2 = false;
// Future<String> getsceneData() async {
//   //temp = true;
//   for (int i = 0; i < 12; i++) {
//     scene_color[i] = Colors.black54;
//   }
//
//   print('entered scene');
//   // print('scene no $scene_no');
//
//   final http.Response response = await http.post(
//     server_http_ip,
//     headers: <String, String>{
//       'Conten-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'data': '5',
//       'cmd': '9',
//       'lid': '6',
//       'sid': '87',
//     }),
//   );
//
//   //temp = false;
//   if (response.statusCode == 200) {
//     print("ok");
//
//     temp = true;
//     // temp2 = false; else {
//
//   } else {
//     temp = false;
//     throw Exception('Failed Response');
//   }
//   // scene_color[scene_no] = Colors.blue;
//   return 'gj';
// }
//
// Future<String> _fetchData;
//
// class testWidget extends StatefulWidget {
//   @override
//   _testWidgetState createState() => _testWidgetState();
// }
//
// class _testWidgetState extends State<testWidget> {
//   @override
//   void initState() {
//     super.initState();
//     _fetchData = getData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('building power button');
//     return FutureBuilder<String>(
//       future: _fetchData,
//       builder: (ctx, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError) {
//             return Center(
//               child: ArgonTimerButton(
//                 height: MediaQuery.of(context).size.height * 0.06,
//                 width: MediaQuery.of(context).size.width * 0.11,
//                 onTap: (startTimer, btnState) {
//                   //print('Tap 1');
//
//                   //print("scee $scene_no");
//
//                   setState(() {
//                     //scene_no = index;
//                     _fetchData = getData();
//                   });
//
//                   if (btnState == ButtonState.Idle) {
//                     startTimer(1);
//                   }
//                 },
//                 child: Icon(
//                   Icons.power_settings_new,
//                   color: powerbuttoncolor,
//                   size: 32,
//                 ),
//                 loader: (timeLeft) {
//                   return Container(
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(50)),
//                     margin: EdgeInsets.all(5),
//                     alignment: Alignment.center,
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.power_settings_new,
//                       color: Colors.black,
//                     ),
//                   );
//                 },
//                 borderRadius: 5.0,
//                 color: primaryColor,
//               ),
//             );
//             // return ElevatedButton(
//             //   style:
//             //       ElevatedButton.styleFrom(primary: button_color),
//             //   onPressed: () {
//             //     setState(() {
//             //       if (button_color == Colors.green) {
//             //         button_color = Colors.yellow;
//             //       } else {
//             //         button_color = Colors.green;
//             //       }
//             //       _fetchData = getData();
//             //     });
//             //   },
//             //   child: Text(
//             //     'nooo',
//             //     style: TextStyle(color: Colors.black54),
//             //   ),
//             // );
//
//             //testWidget();
//
//           } else if (snapshot.hasData) {
//             return Center(
//               child: ArgonTimerButton(
//                 height: MediaQuery.of(context).size.height * 0.06,
//                 width: MediaQuery.of(context).size.width * 0.11,
//                 onTap: (startTimer, btnState) {
//                   //print('Tap 1');
//
//                   //print("scee $scene_no");
//
//                   setState(() {
//                     //scene_no = index;
//                     _fetchData = getData();
//                   });
//
//                   if (btnState == ButtonState.Idle) {
//                     startTimer(1);
//                   }
//                 },
//                 child: Icon(
//                   Icons.power_settings_new,
//                   color: powerbuttoncolor,
//                   size: 32,
//                 ),
//                 loader: (timeLeft) {
//                   return Container(
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(50)),
//                     margin: EdgeInsets.all(5),
//                     alignment: Alignment.center,
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.power_settings_new,
//                       color: Colors.black,
//                     ),
//                   );
//                 },
//                 borderRadius: 5.0,
//                 color: primaryColor,
//               ),
//             );
//             // return ElevatedButton(
//             //   style:
//             //       ElevatedButton.styleFrom(primary: button_color),
//             //   onPressed: () {
//             //     setState(() {
//             //       if (button_color == Colors.green) {
//             //         button_color = Colors.yellow;
//             //       } else {
//             //         button_color = Colors.green;
//             //       }
//             //       _fetchData = getsceneData();
//             //     });
//             //   },
//             //   child: Text(
//             //     'yes',
//             //     style: TextStyle(color: Colors.black54),
//             //   ),
//             // );
//           }
//         }
//
//         return CircularProgressIndicator();
//       },
//     );
//   }
// }
//
// class moodWidget extends StatefulWidget {
//   int scene_index;
//
//   moodWidget({
//     @required this.scene_index,
//   });
//   @override
//   _moodWidgetState createState() => _moodWidgetState();
// }
//
// class _moodWidgetState extends State<moodWidget> {
//   @override
//   Widget build(BuildContext context) {
//     //temp = false;
//     print('building mood');
//     return GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 3,
//             childAspectRatio: .7),
//         scrollDirection: Axis.horizontal,
//         itemCount: 12,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: ArgonTimerButton(
//               height: MediaQuery.of(context).size.width * 0.18,
//               width: MediaQuery.of(context).size.width * 0.18,
//               onTap: (startTimer, btnState) {
//                 //print('Tap 1');
//
//                 //print("scee $scene_no");
//                 //    temp = false;
//                 print("temp value $temp");
//                 setState(() {
//                   getsceneData();
//                   scene_no = index;
//                   if (temp == true) {
//                     scene_color[scene_no] = Colors.deepOrange;
//                     temp = false;
//                   }
//                   print("temp value $temp");
//                   print("scene number $scene_no");
//                 });
//
//                 if (btnState == ButtonState.Idle) {
//                   startTimer(1);
//                 }
//               },
//               child: Icon(
//                 scene_Icons[index].icon,
//                 color: Colors.white,
//               ),
//               loader: (timeLeft) {
//                 return Container(
//                   decoration: BoxDecoration(
//                       color: Colors.deepOrange,
//                       borderRadius: BorderRadius.circular(50)),
//                   margin: EdgeInsets.all(5),
//                   alignment: Alignment.center,
//                   width: 40,
//                   height: 40,
//                   child: Icon(
//                     scene_Icons[index].icon,
//                     color: Colors.white,
//                   ),
//                 );
//               },
//               borderRadius: 5.0,
//               color: scene_color[index],
//             ),
//           );
//         });
//   }
// }
//
// class lamp extends StatefulWidget {
//   //int scene_index;
//
//   // lamp({
//   //   @required this.scene_index,
//   // });
//   @override
//   _lampState createState() => _lampState();
// }
//
// class _lampState extends State<lamp> {
//   @override
//   Widget build(BuildContext context) {
//     print('building row 2 mood');
//     return ListView.builder(
//       semanticChildCount: 1,
//       scrollDirection: Axis.horizontal,
//       itemCount: lamp_count,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           child: SafeArea(
//             child: Container(
//               width: MediaQuery.of(context).size.width * .9,
//               height: MediaQuery.of(context).size.width * .3,
//               margin: EdgeInsets.only(left: 16, right: 16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [
//                   activecolor1[index],
//                   activecolor2[index],
//                 ]),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(6),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.lightbulb,
//                     color: Colors.white,
//                     size: 34,
//                   ),
//                   title: Text(
//                     'lamp ${index + 1}   ${_lamps[index].lid}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: 22,
//                     ),
//                   ),
//                   subtitle: Text(
//                     _lamps[index].name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           onTap: () {
//             setState(() {
//               for (int i = 0; i < 12; i++) {
//                 // isSelected_tag[i] = false;
//                 activecolor1[i] = Colors.black54;
//                 activecolor2[i] = Colors.black54;
//               }
//               activecolor1[index] = Color(0XFFED560D);
//               activecolor2[index] = Color(0XFFCD2A12);
//             });
//           },
//         );
//       },
//     );
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
// /////////////////////////////////////////////////////////////////////////
//
//
//
//
//
// import 'package:clay_containers/clay_containers.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:smart_home/screens/curtainscreen.dart';
// import 'package:smart_home/screens/home_screen.dart';
// import 'package:smart_home/models/rooms_model.dart';
// import 'package:sleek_circular_slider/sleek_circular_slider.dart';
// import 'package:smart_home/screens/sprinkler.dart';
// import 'package:smart_home/main.dart';
// import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// String server_http_ip = 'https://ptsv2.com/t/der/post';
// List<Icon> scene_Icons = [
//   Icon(Icons.lightbulb),
//   Icon(Icons.brightness_high),
//   Icon(Icons.brightness_6),
//   Icon(Icons.nights_stay),
//   Icon(Icons.nightlife),
//   Icon(Icons.invert_colors_sharp),
//   Icon(Icons.local_dining_rounded),
//   Icon(Icons.sports_esports_outlined),
//   Icon(Icons.book_outlined),
//   Icon(Icons.border_all),
//   Icon(Icons.ac_unit),
//   Icon(Icons.settings_input_antenna_outlined),
// ];
//
// var scene_no;
// Color button_color = Colors.white;
//
// List<Color> scene_color = [
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
// ];
//
// List<Color> activecolor1 = [
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
// ];
//
// List<Color> activecolor2 = [
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
//   Colors.black54,
// ];
//
// List<LampModel> _lamps = [
//   LampModel(name: '9W', lid: 2),
//   LampModel(name: '12W', lid: 12),
//   LampModel(name: '7W', lid: 4),
//   LampModel(name: '9W', lid: 10),
//   LampModel(name: '7W', lid: 10),
// ];
//
// Color primaryColor = Color(0XFF26282B);
// Color activeColor1 = Color(0XFFED560D);
// Color activeColor2 = Color(0XFFCD2A12);
// Color powerbuttoncolor = Colors.white60;
//
// List<Color> gradientColors = [activeColor1, activeColor2];
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // SystemChrome.setEnabledSystemUIOverlays([]);
//     return MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//           primarySwatch: Colors.blue),
//       home: HomePage(),
//     );
//   }
// }
//
// // class DetailScreen extends StatefulWidget {
// //   final String title;
// //   DetailScreen({@required this.title});
// //
// //   @override
// //   _DetailScreenState createState() => _DetailScreenState();
// // }
// class HomePage extends StatefulWidget {
//   final String title;
//   HomePage({@required this.title});
//   @override
//   _HomePageState createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> {
//   var _value = 0.0;
//   var tempp = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     for (int i = 0; i < response_dummy.length; i++) {
//       tempp = i + 1;
//       _lamps[i].lid = response_dummy['lid$tempp'];
//     }
//     lamp_count = response_dummy.length;
//     // print(responsed_dummy_json);
//     // print(server_http_response);
//     return Scaffold(
//       backgroundColor: Color(0XFF26282B), //primaryColor,
//       body: SingleChildScrollView(
//         scrollDirection: Axis.vertical,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             SizedBox(
//               //// A
//               height: MediaQuery.of(context).size.height * 0.01, // Athul
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 GestureDetector(
//                   child: ClayContainer(
//                     ////////////////////////////////////////////////////////////////////
//                     height: MediaQuery.of(context).size.height * 0.06, //1
//                     ////////////////////////////////////////////////////////////////////
//                     width: MediaQuery.of(context).size.width * 0.11,
//                     borderRadius: 10,
//                     color: Color(0XFF26282B),
//
//                     /// A
//                     child: Padding(
//                       padding: EdgeInsets.all(4),
//                       child: Center(
//                         child: Icon(
//                           Icons.arrow_back,
//                           color: Colors.white,
//                           size: 32,
//                         ),
//                       ),
//                     ),
//                   ),
//                   onTap: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => HomeScreen(),
//                         ));
//                   },
//                 ),
//                 Text(
//                   widget.title,
//                   //'Living Room',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 26,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//
//                 //   /// Athul
//                 // ),
//                 testWidget(),
//               ],
//             ),
//             SizedBox(height: MediaQuery.of(context).size.height * 0.02), ////A
//             Container(
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.14, //1
//               ////////////////////////////////////////////////////////////////////
//               color: primaryColor,
//
//               /// A
//               padding: EdgeInsets.symmetric(vertical: 12, horizontal: 4),
//               child: lamp(),
//             ),
//             Padding(
//               padding:
//               EdgeInsets.only(left: MediaQuery.of(context).size.width * .7),
//               child: ArgonTimerButton(
//                 elevation: 0,
//                 color: primaryColor,
//
//                 /// A
//                 width: MediaQuery.of(context).size.width * .1,
//
//                 ////////////////////////////////////////////////////////////////////
//                 height: MediaQuery.of(context).size.height * 0.05, //1
//                 ////////////////////////////////////////////////////////////////////
//
//                 child: Icon(
//                   Icons.info_outline,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 onTap: (startTimer, btnState) {
//                   if (btnState == ButtonState.Idle) {
//                     startTimer(1);
//                   }
//                 },
//                 loader: (timeLeft) {
//                   return Icon(
//                     Icons.check_circle_outline,
//                     color: Colors.green,
//                   );
//                 },
//               ),
//             ),
//             SizedBox(
//               //// A
//               height: MediaQuery.of(context).size.height * 0.05, // Athul
//             ),
//             ClayContainer(
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.25, //1
//               ////////////////////////////////////////////////////////////////////
//
//               width: MediaQuery.of(context).size.height * 0.25,
//               color: Color(0XFF26282B), //// A
//               borderRadius: 200,
//               child: Padding(
//                 padding: EdgeInsets.all(12),
//                 child: SleekCircularSlider(
//                     innerWidget: (value) {
//                       return Container(
//                         decoration: BoxDecoration(
//                           // color: Colors.transparent, //Colors.orange,
//
//                           /// A
//                             shape: BoxShape.circle),
//                         width: MediaQuery.of(context).size.width * .14, //200,
//                         height: MediaQuery.of(context).size.width * .14, //200,
//                         child: Padding(
//                           padding: EdgeInsets.all(
//                             MediaQuery.of(context).size.width * .1,
//                           ),
//                           child: Column(children: [
//                             ArgonTimerButton(
//                               // height: MediaQuery.of(context).size.width * 0.1,
//                               // width: MediaQuery.of(context).size.width * 0.1,
//
//                               height: MediaQuery.of(context).size.height * .08,
//                               width: MediaQuery.of(context).size.width * .2,
//                               onTap: (startTimer, btnState) {
//                                 if (btnState == ButtonState.Idle) {
//                                   startTimer(1);
//                                 }
//                               },
//                               child: Icon(
//                                 Icons.wb_incandescent,
//                                 color: Colors.white,
//                                 size: MediaQuery.of(context).size.height * .07,
//                               ),
//                               loader: (timeLeft) {
//                                 return Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.black,
//                                       borderRadius: BorderRadius.circular(200)),
//                                   // margin: EdgeInsets.all(
//                                   //   MediaQuery.of(context).size.width * .03,
//                                   // ),
//                                   alignment: Alignment.center,
//                                   width:
//                                   MediaQuery.of(context).size.width * .25,
//                                   height:
//                                   MediaQuery.of(context).size.width * .25,
//                                   child: Icon(
//                                     Icons.wb_incandescent,
//                                     color: Colors.yellowAccent,
//                                   ),
//                                 );
//                               },
//                               borderRadius: 5.0,
//                               color: primaryColor, //Colors.black54,
//
//                               elevation: 0,
//                             ),
//                             SizedBox(
//                               height: MediaQuery.of(context).size.height * 0.01,
//                             ),
//                             Expanded(
//                               child: AutoSizeText(
//                                 '${value.ceil().toInt().toString()}',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontSize:
//                                     MediaQuery.of(context).size.height *
//                                         0.03,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           ]),
//                         ),
//                       );
//                     },
//                     appearance: CircularSliderAppearance(
//                       customColors: CustomSliderColors(
//                         progressBarColors: gradientColors,
//                         hideShadow: true,
//                         shadowColor: Colors.transparent,
//                       ),
//                     ),
//                     onChange: (double value) {
//                       print(MediaQuery.of(context).size.height);
//                       print(value);
//                     }),
//               ),
//             ),
//             SizedBox(
//                 height: MediaQuery.of(context).size.height * .06), ///// Athul
//
//             /// A
//             Container(
//               // height: MediaQuery.of(context).size.height * .20,
//
//               decoration: BoxDecoration(
//                   color: primaryColor,
//
//                   ///A
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: primaryColor, //Colors.black12,
//                     )
//                   ]),
//
//               padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
//
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.16, //1
//               ////////////////////////////////////////////////////////////////////
//
//               child: moodWidget(),
//             ),
//             SizedBox(
//               /// A
//               height: MediaQuery.of(context).size.height * .02, // Athul
//             ),
//
//             SizedBox(
//               /// A
//               height: MediaQuery.of(context).size.height * 0.09, // Athul
//             ),
//             Container(
//               //parent container for bottom bar
//
//               ////////////////////////////////////////////////////////////////////
//               height: MediaQuery.of(context).size.height * 0.08, //1
//               ////////////////////////////////////////////////////////////////////
//               color: primaryColor, //// A
//               child: Row(
//                 // mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.spaceAround,
//                 children: [
//                   Column(children: [
//                     Expanded(
//                       child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               // padding: EdgeInsets.fromLTRB(
//                               //     MediaQuery.of(context).size.width * .01,
//                               //     MediaQuery.of(context).size.width * .05,
//                               //     0,
//                               //     0),
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.lightbulb_outline,
//                                     color: activeColor1,
//                                   ),
//                                   onPressed: () {
//                                     print("You Pressed the icon!");
//                                   }),
//                             ),
//                           ]),
//                     ),
//                     Row(children: [
//                       Text(
//                         'Lamp',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ])
//                   ]),
//                   Column(children: [
//                     Expanded(
//                       child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Container(
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.border_all,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => CurtainPage(
//                                               title: widget.title,
//                                             )));
//                                     print("You Pressed the icon!");
//                                   }),
//                             ),
//                           ]),
//                     ),
//                     Row(children: [
//                       Container(),
//                       Text(
//                         'Curtain',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ])
//                   ]),
//                   Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Expanded(
//                           child: Row(children: [
//                             Container(
//                               child: IconButton(
//                                   icon: Icon(
//                                     Icons.filter_tilt_shift_outlined,
//                                     color: Colors.white,
//                                   ),
//                                   onPressed: () {
//                                     Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) => SprinklerPage(
//                                               title: widget.title,
//                                             )));
//                                     print("You Pressed the icon!");
//                                   }),
//                             ),
//                           ]),
//                         ),
//                         Row(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Sprinkler',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                             ])
//                       ]),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String percentageModifier(double value) {
//     final roundedValue = value.ceil().toInt().toString();
//     return '$roundedValue 0x00B0 C';
//   }
// }
//
// class MenuItem extends StatefulWidget {
//   final IconData iconName;
//   final Text name;
//   final int scene_no;
//   final Color scene_color;
//
//   const MenuItem(
//       {Key key,
//         this.iconName,
//         this.name,
//         @required this.scene_no,
//         this.scene_color})
//       : super(key: key);
//   @override
//   _MenuItemState createState() => _MenuItemState();
// }
//
// class _MenuItemState extends State<MenuItem> {
//   // bool isSelected = false;
//   List<bool> test = [
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false,
//     false
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     print('hh ${test[0]}');
//
//     return GestureDetector(
//       onTap: () {
//         // code to send scene number to AWS broker
//
//         setState(() {
//           for (int i = 0; i < 12; i++) {
//             test[i] = false;
//           }
//           test[widget.scene_no - 1] = true;
//           print('bb${test[2]}');
//           //  isSelected = true;
//         });
//       },
//       child: ClayContainer(
//         height: MediaQuery.of(context).size.width * 1 / 7,
//         width: MediaQuery.of(context).size.width * 1 / 7,
//         borderRadius: 10,
//         color: primaryColor,
//         surfaceColor: test[widget.scene_no - 1] ? activeColor2 : primaryColor,
//         child: Icon(widget.iconName, color: Colors.white, size: 20),
//       ),
//     );
//   }
// }
//
// //////////////////////////////
//
// Future<String> getData() async {
//   //print("enters power button");
//   final http.Response response = await http.post(
//     server_http_ip,
//     headers: <String, String>{
//       'Conten-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'data': '5',
//       'cmd': '9',
//       'lid': '6',
//       'sid': '87',
//     }),
//   );
//   if (response.statusCode == 200) {
//     // Map<String, dynamic> map =
//     //     jsonDecode(response_dummy) as Map<String, dynamic>;
//     // server_http_response = jsonDecode(map["lid1"]);
//
//     // print('power ok');
//
//     if (powerbuttoncolor == Colors.red) {
//       powerbuttoncolor = Colors.white;
//     } else {
//       powerbuttoncolor = Colors.red;
//     }
//     return 'gj';
//     print(server_http_response);
//   } else {
//     throw Exception('Failed Response');
//   }
// }
//
// bool temp = false;
// bool temp2 = false;
// Future<String> getsceneData() async {
//   //temp = true;
//   for (int i = 0; i < 12; i++) {
//     scene_color[i] = Colors.black54;
//   }
//
//   print('entered scene');
//   // print('scene no $scene_no');
//
//   final http.Response response = await http.post(
//     server_http_ip,
//     headers: <String, String>{
//       'Conten-Type': 'application/json; charset=UTF-8',
//     },
//     body: jsonEncode(<String, String>{
//       'data': '5',
//       'cmd': '9',
//       'lid': '6',
//       'sid': '87',
//     }),
//   );
//
//   //temp = false;
//   if (response.statusCode == 200) {
//     print("ok");
//
//     temp = true;
//     scene_color[scene_no] = Colors.deepOrange;
//     return 'gj';
//     // temp2 = false; else {
//
//   } else {
//     temp = false;
//     throw Exception('Failed Response');
//   }
//   // scene_color[scene_no] = Colors.blue;
// }
//
// Future<String> _fetchData;
// Future<String> _fetchsceneData;
//
// class testWidget extends StatefulWidget {
//   @override
//   _testWidgetState createState() => _testWidgetState();
// }
//
// class _testWidgetState extends State<testWidget> {
//   @override
//   void initState() {
//     super.initState();
//     _fetchData = getData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('building power button');
//     return FutureBuilder<String>(
//       future: _fetchData,
//       builder: (ctx, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError) {
//             return Center(
//               child: ArgonTimerButton(
//                 height: MediaQuery.of(context).size.height * 0.06,
//                 width: MediaQuery.of(context).size.width * 0.11,
//                 onTap: (startTimer, btnState) {
//                   //print('Tap 1');
//
//                   //print("scee $scene_no");
//
//                   setState(() {
//                     //scene_no = index;
//                     _fetchData = getData();
//                   });
//
//                   if (btnState == ButtonState.Idle) {
//                     startTimer(1);
//                   }
//                 },
//                 child: Icon(
//                   Icons.power_settings_new,
//                   color: powerbuttoncolor,
//                   size: 32,
//                 ),
//                 loader: (timeLeft) {
//                   return Container(
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(50)),
//                     margin: EdgeInsets.all(5),
//                     alignment: Alignment.center,
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.power_settings_new,
//                       color: Colors.black,
//                     ),
//                   );
//                 },
//                 borderRadius: 5.0,
//                 color: primaryColor,
//               ),
//             );
//             // return ElevatedButton(
//             //   style:
//             //       ElevatedButton.styleFrom(primary: button_color),
//             //   onPressed: () {
//             //     setState(() {
//             //       if (button_color == Colors.green) {
//             //         button_color = Colors.yellow;
//             //       } else {
//             //         button_color = Colors.green;
//             //       }
//             //       _fetchData = getData();
//             //     });
//             //   },
//             //   child: Text(
//             //     'nooo',
//             //     style: TextStyle(color: Colors.black54),
//             //   ),
//             // );
//
//             //testWidget();
//
//           } else if (snapshot.hasData) {
//             return Center(
//               child: ArgonTimerButton(
//                 height: MediaQuery.of(context).size.height * 0.06,
//                 width: MediaQuery.of(context).size.width * 0.11,
//                 onTap: (startTimer, btnState) {
//                   //print('Tap 1');
//
//                   //print("scee $scene_no");
//
//                   setState(() {
//                     //scene_no = index;
//                     _fetchData = getData();
//                   });
//
//                   if (btnState == ButtonState.Idle) {
//                     startTimer(1);
//                   }
//                 },
//                 child: Icon(
//                   Icons.power_settings_new,
//                   color: powerbuttoncolor,
//                   size: 32,
//                 ),
//                 loader: (timeLeft) {
//                   return Container(
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(50)),
//                     margin: EdgeInsets.all(5),
//                     alignment: Alignment.center,
//                     width: 40,
//                     height: 40,
//                     child: Icon(
//                       Icons.power_settings_new,
//                       color: Colors.black,
//                     ),
//                   );
//                 },
//                 borderRadius: 5.0,
//                 color: primaryColor,
//               ),
//             );
//             // return ElevatedButton(
//             //   style:
//             //       ElevatedButton.styleFrom(primary: button_color),
//             //   onPressed: () {
//             //     setState(() {
//             //       if (button_color == Colors.green) {
//             //         button_color = Colors.yellow;
//             //       } else {
//             //         button_color = Colors.green;
//             //       }
//             //       _fetchData = getsceneData();
//             //     });
//             //   },
//             //   child: Text(
//             //     'yes',
//             //     style: TextStyle(color: Colors.black54),
//             //   ),
//             // );
//           }
//         }
//
//         return CircularProgressIndicator();
//       },
//     );
//   }
// }
//
// class moodWidget extends StatefulWidget {
//   int scene_index;
//
//   moodWidget({
//     @required this.scene_index,
//   });
//   @override
//   _moodWidgetState createState() => _moodWidgetState();
// }
//
// class _moodWidgetState extends State<moodWidget> {
//   @override
//   void initState() {
//     super.initState();
//     _fetchsceneData = getsceneData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     //temp = false;
//     print('building mood');
//
//     return FutureBuilder(
//       future: _fetchsceneData,
//       //initialData: moodWidget,
//       builder: (ctx, snapshot) {
//         if (snapshot.connectionState == ConnectionState.done) {
//           if (snapshot.hasError) {
//             return GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 3,
//                     childAspectRatio: .7),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 12,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Padding(
//                     padding: EdgeInsets.only(left: 10),
//                     child: ArgonTimerButton(
//                       height: MediaQuery.of(context).size.width * 0.18,
//                       width: MediaQuery.of(context).size.width * 0.18,
//                       onTap: (startTimer, btnState) {
//                         //print('Tap 1');
//
//                         //print("scee $scene_no");
//                         //    temp = false;
//                         print("temp value $temp");
//                         setState(() {
//                           scene_no = index;
//                           if (temp == true) {
//                             scene_color[scene_no] = Colors.deepOrange;
//                             temp = false;
//                           }
//                           print("temp value $temp");
//                           print("scene number $scene_no");
//                           _fetchsceneData = getsceneData();
//                         });
//
//                         if (btnState == ButtonState.Idle) {
//                           startTimer(1);
//                         }
//                       },
//                       child: Icon(
//                         scene_Icons[index].icon,
//                         color: Colors.white,
//                       ),
//                       loader: (timeLeft) {
//                         return Container(
//                           decoration: BoxDecoration(
//                               color: Colors.deepOrange,
//                               borderRadius: BorderRadius.circular(50)),
//                           margin: EdgeInsets.all(5),
//                           alignment: Alignment.center,
//                           width: 40,
//                           height: 40,
//                           child: Icon(
//                             scene_Icons[index].icon,
//                             color: Colors.white,
//                           ),
//                         );
//                       },
//                       borderRadius: 5.0,
//                       color: scene_color[index],
//                     ),
//                   );
//                 });
//           } else if (snapshot.hasData) {
//             final data = snapshot.data as String;
//             return GridView.builder(
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 3,
//                     childAspectRatio: .7),
//                 scrollDirection: Axis.horizontal,
//                 itemCount: 12,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Padding(
//                     padding: EdgeInsets.only(left: 10),
//                     child: ArgonTimerButton(
//                       height: MediaQuery.of(context).size.width * 0.18,
//                       width: MediaQuery.of(context).size.width * 0.18,
//                       onTap: (startTimer, btnState) {
//                         //print('Tap 1');
//
//                         //print("scee $scene_no");
//                         //    temp = false;
//                         print("temp value $temp");
//                         setState(() {
//                           scene_no = index;
//                           if (temp == true) {
//                             scene_color[scene_no] = Colors.deepOrange;
//                             temp = false;
//                           }
//                           print("temp value $temp");
//                           print("scene number $scene_no");
//                           _fetchsceneData = getsceneData();
//                         });
//
//                         if (btnState == ButtonState.Idle) {
//                           startTimer(1);
//                         }
//                       },
//                       child: Icon(
//                         scene_Icons[index].icon,
//                         color: Colors.white,
//                       ),
//                       loader: (timeLeft) {
//                         return Container(
//                           decoration: BoxDecoration(
//                               color: Colors.deepOrange,
//                               borderRadius: BorderRadius.circular(50)),
//                           margin: EdgeInsets.all(5),
//                           alignment: Alignment.center,
//                           width: 40,
//                           height: 40,
//                           child: Icon(
//                             scene_Icons[index].icon,
//                             color: Colors.white,
//                           ),
//                         );
//                       },
//                       borderRadius: 5.0,
//                       color: scene_color[index],
//                     ),
//                   );
//                 });
//           }
//         }
//
//         return CircularProgressIndicator();
//       },
//     );
//
//     return GridView.builder(
//         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             crossAxisSpacing: 10,
//             mainAxisSpacing: 3,
//             childAspectRatio: .7),
//         scrollDirection: Axis.horizontal,
//         itemCount: 12,
//         itemBuilder: (BuildContext context, int index) {
//           return Padding(
//             padding: EdgeInsets.only(left: 10),
//             child: ArgonTimerButton(
//               height: MediaQuery.of(context).size.width * 0.18,
//               width: MediaQuery.of(context).size.width * 0.18,
//               onTap: (startTimer, btnState) {
//                 //print('Tap 1');
//
//                 //print("scee $scene_no");
//                 //    temp = false;
//                 print("temp value $temp");
//                 setState(() {
//                   getsceneData();
//                   scene_no = index;
//                   if (temp == true) {
//                     scene_color[scene_no] = Colors.deepOrange;
//                     temp = false;
//                   }
//                   print("temp value $temp");
//                   print("scene number $scene_no");
//                 });
//
//                 if (btnState == ButtonState.Idle) {
//                   startTimer(1);
//                 }
//               },
//               child: Icon(
//                 scene_Icons[index].icon,
//                 color: Colors.white,
//               ),
//               loader: (timeLeft) {
//                 return Container(
//                   decoration: BoxDecoration(
//                       color: Colors.deepOrange,
//                       borderRadius: BorderRadius.circular(50)),
//                   margin: EdgeInsets.all(5),
//                   alignment: Alignment.center,
//                   width: 40,
//                   height: 40,
//                   child: Icon(
//                     scene_Icons[index].icon,
//                     color: Colors.white,
//                   ),
//                 );
//               },
//               borderRadius: 5.0,
//               color: scene_color[index],
//             ),
//           );
//         });
//   }
// }
//
// class lamp extends StatefulWidget {
//   //int scene_index;
//
//   // lamp({
//   //   @required this.scene_index,
//   // });
//   @override
//   _lampState createState() => _lampState();
// }
//
// class _lampState extends State<lamp> {
//   @override
//   Widget build(BuildContext context) {
//     print('building row 2 mood');
//     return ListView.builder(
//       semanticChildCount: 1,
//       scrollDirection: Axis.horizontal,
//       itemCount: lamp_count,
//       itemBuilder: (context, index) {
//         return GestureDetector(
//           child: SafeArea(
//             child: Container(
//               width: MediaQuery.of(context).size.width * .9,
//               height: MediaQuery.of(context).size.width * .3,
//               margin: EdgeInsets.only(left: 16, right: 16),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: [
//                   activecolor1[index],
//                   activecolor2[index],
//                 ]),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Padding(
//                 padding: EdgeInsets.all(6),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.lightbulb,
//                     color: Colors.white,
//                     size: 34,
//                   ),
//                   title: Text(
//                     'lamp ${index + 1}   ${_lamps[index].lid}',
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                       fontSize: 22,
//                     ),
//                   ),
//                   subtitle: Text(
//                     _lamps[index].name,
//                     style: TextStyle(
//                       fontWeight: FontWeight.w500,
//                       color: Colors.white,
//                       fontSize: 15,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           onTap: () {
//             setState(() {
//               for (int i = 0; i < 12; i++) {
//                 // isSelected_tag[i] = false;
//                 activecolor1[i] = Colors.black54;
//                 activecolor2[i] = Colors.black54;
//               }
//               activecolor1[index] = Color(0XFFED560D);
//               activecolor2[index] = Color(0XFFCD2A12);
//             });
//           },
//         );
//       },
//     );
//   }
// }
//
