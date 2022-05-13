// /// Flutter code sample for StreamBuilder
//
// // This sample shows a [StreamBuilder] that listens to a Stream that emits bids
// // for an auction. Every time the StreamBuilder receives a bid from the Stream,
// // it will display the price of the bid below an icon. If the Stream emits an
// // error, the error is displayed below an error icon. When the Stream finishes
// // emitting bids, the final price is displayed.
//
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// /// This is the main application widget.
// class MyApp extends StatelessWidget {
// //  const MyApp({Key? key}) : super(key: key);
//
//   static const String _title = 'Flutter Code Sample';
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: _title,
//       home: MyStatefulWidget(),
//     );
//   }
// }
//
// /// This is the stateful widget that the main application instantiates.
// class MyStatefulWidget extends StatefulWidget {
// //  const MyStatefulWidget({Key? key}) : super(key: key);
//
//   @override
//   State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
// }
//
// /// This is the private State class that goes with MyStatefulWidget.
// class _MyStatefulWidgetState extends State<MyStatefulWidget> {
//   Stream<String> _bids = (() async* {
//     await Future<void>.delayed(const Duration(seconds: 3));
//     yield '5';
//     await Future<void>.delayed(const Duration(seconds: 3));
//     yield '7';
//     await Future<void>.delayed(const Duration(seconds: 3));
//   })();
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTextStyle(
//       style: Theme.of(context).textTheme.headline2,
//       textAlign: TextAlign.center,
//       child: Container(
//         alignment: FractionalOffset.center,
//         color: Colors.white,
//         child: Column(children: [
//           StreamBuilder<String>(
//             stream: _bids,
//             builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//               if (snapshot.hasError) {
//                 /// our widget
//
//               } else {
//                 switch (snapshot.connectionState) {
//                   case ConnectionState.none:
//
//                     /// our widget
//                     break;
//                   case ConnectionState.waiting:
//
//                     /// our widget
//                     break;
//                   case ConnectionState.active:
//
//                     /// our widget
//                     break;
//                   case ConnectionState.done:
//
//                     /// our widget
//                     break;
//                 }
//               }
//
//               return Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: children,
//               );
//             },
//           ),
//           ElevatedButton(
//               onPressed: () {
//                 //_bids=30;
//               },
//               child: Text('athul')),
//         ]),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:smart_home/screens/screens.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

import 'dart:async';
import 'package:typed_data/typed_data.dart' as typed;
import 'package:smart_home/screens/lamppage.dart';

Color qry_btn_color = Colors.white;
bool slider_animation = false;
int zone_add = 0;
int page_no = 0;
var selected_lamp = 0;
double resp_test = 0;
bool mqtt_connection_status = false;
bool mqtt_sub_status = false;

String server_http_ip = 'https://ptsv2.com/t/Guj/post';
var server_http_response;
Map response_dummy = {"lid1": zone_add, "lid2": 3, "lid3": 20, "lid4": 44};
Map response_dummy_curtain = {
  "curid1": 5,
  "curid2": 3,
  "curid3": 2,
  "curid4": 14
};

Map page_zone = {"page1": 214, "page2": 211, "page3": 209, "page4": 213};

//List<dynamic> responsed_dummy_json = jsonDecode(response_dummy);
var responsed_dummy_json = jsonEncode(response_dummy);
var lamp_count;
//var responsed_dummy_json = jsonEncode(response_dummy);
var cur_count;
var connect_flag = 1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("main");
  connect_flag = 0;
  await connect();

  /// function to connect to mqtt broker

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    print("building main app");
    if (connect_flag == 0) {
      connect();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    if (connect_flag == 0) {
      connect();
    }
    return MaterialApp(
      title: 'Smart Home',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        buttonColor: Color(0xff5E9F7B),
        backgroundColor: Color(0xff8EA096),
      ),
      home: HomeScreen(),
    );
  }
}

void widget_init() async {}

/// MQTT code below

MqttServerClient client;
var _onDisconnected;
var _onConnected;
var _onSubscribed;
var _iotEndpoint = "mb0b2100.us-east-1.emqx.cloud";
var _clientId = "test_esp";
var connectionState;
var connectivity_duration = Duration(seconds: 20);

void onConnected() {
  connect_flag = 1;
  mqtt_connection_status = true;
  connectivity_duration = Duration(seconds: 2);
  connectivity_color = Colors.green;
  slider_controller.add(1);
  connectivity_controller.add(1);
  print('Connected to broker');
}

void onDisconnected() {
  mqtt_connection_status = false;

  print('Disconnected');
}

// subscribe to topic succeeded
void onSubscribed(String topic) {
  mqtt_sub_status = true;
  print('Subscribed topic: $topic');
}

// subscribe to topic failed
void onSubscribeFail(String topic) {
  mqtt_sub_status = false;
  print('Failed to subscribe $topic');
}

// unsubscribe succeeded
void onUnsubscribed(String topic) {
  mqtt_sub_status = false;
  print('Unsubscribed topic: $topic');
}

// PING response received
void pong() {
  print('Ping response client callback invoked');
}

void recon() {
  mqtt_connection_status = false;
  connectivity_duration = Duration(seconds: 20);
  connectivity_color = Colors.red;
  slider_controller.add(1);
  connectivity_controller.add(1);
  print('reconn invoked');
}

ByteData caData;
ByteData certData;
ByteData privateKeyData;

StreamController<int> connectivity_controller =
    StreamController<int>.broadcast();
StreamController<int> power_button_controller =
    StreamController<int>.broadcast();
StreamController<int> query_button_controller =
    StreamController<int>.broadcast();
StreamController<int> slider_controller = StreamController<int>.broadcast();

StreamController<int> scene_button_controller =
    StreamController<int>.broadcast();

//Future<String> _fetchData;
Future connect() async {
  print('ggg');
  client = MqttServerClient.withPort(_iotEndpoint, 'esp', 15727);
  client.logging(on: false);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;
  client.autoReconnect = true;
  //client.secure = false;
  client.onAutoReconnect = recon;
  final connMessage = MqttConnectMessage()
      .withClientIdentifier("client-1")
      .authenticateAs('esp', 'pass')
      .keepAliveFor(60)
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.exactlyOnce);

  client.connectionMessage = connMessage;
  try {
    await client.connect();
    try {
      subscribe('testtopic');
    } catch (e) {
      print(e);
    }
  } catch (e) {
    print('Exception: $e');
    client.disconnect();
  }

  return client;
}

Future<MqttServerClient> publish(pub_mes) async {
  ///Publish a known topic

  String pub_top = 'testtopic';
  var buff = typed.Uint8Buffer(pub_mes.length);
  for (int i = 0; i < pub_mes.length; i++) {
    buff[i] = pub_mes.codeUnitAt(i);
  }
  try {
    client.publishMessage(pub_top, MqttQos.exactlyOnce, buff);
  } catch (e) {
    print(e);
  }
  return (client);
}

Future<MqttServerClient> subscribe(String sub_top) async {
  /// subscribe to topic

  try {
    print('trying subscruibe');
    client.subscribe(sub_top, MqttQos.exactlyOnce);
  } catch (e) {
    print(e);
  }
  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload;
    final payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);
    var response_js = jsonDecode(payload);

    /// converting data to json

    /// code to call streams of all widgets based on data received and topic

    print(response_js['cmd']);
    //
    // if (response_js['cmd'] == 24) {
    //   print("jil");
    // }

    /// Step 1 : update the widget parameter

    if (response_js['cmd'] == 208 && response_js['lid'] == power_button_zone) {
      powerbuttoncolor = Colors.deepOrange;
      power_button_cmd = 212;
      power_button_controller.add(1);
    } else if (response_js['cmd'] == 212 &&
        response_js['lid'] == power_button_zone) {
      powerbuttoncolor = Colors.white;
      power_button_cmd = 208;
      power_button_controller.add(1);
    } else if (response_js['cmd'] ==
        qry_cmd /*&& response_js['lid'] == qry_add*/) {
      String dumm = response_js['data'].toString();

      // print("k");
      slider_animation = true;
      slider_cmd = 212;
      qry_icon_color = Colors.green;
      qry_wait = false;
      light_master_color = Colors.yellow;
      query_button_controller.add(1);
      slider_value = double.parse(dumm);
      resp_test = double.parse(dumm);
      slider_controller.add(1);
    } else if (response_js['cmd'] == 208 &&

        /// slider control
        response_js['lid'] == selected_lamp) {
      //print("ser");
      slider_animation = true;
      resp_test = 100;
      slider_value = 100;
      slider_cmd = 212;
      light_master_color = Colors.yellow;
      slider_controller.add(1);
    } else if (response_js['cmd'] == 212 &&
        response_js['lid'] == selected_lamp) {
      slider_animation = true;
      resp_test = 0;
      slider_value = 0;
      slider_cmd = 208;
      light_master_color = Colors.white;
      slider_controller.add(1);
    } else if (response_js['cmd'] == 201 &&
        response_js['lid'] == selected_lamp &&
        response_js['data'] > 0) {
      slider_animation = false;
      //  double dummy = response_js['data'].toDouble();
      resp_test = slider_value;
      slider_cmd = 212;
      light_master_color = Colors.yellow;
      slider_controller.add(1);
    } else if (response_js['cmd'] == 201 &&
        response_js['lid'] == selected_lamp &&
        response_js['data'] == 0) {
      slider_animation = false;
      resp_test = slider_value;
      slider_cmd = 208;
      light_master_color = Colors.white;
      slider_controller.add(1);
    } else if (response_js['cmd'] == scene_button_cmd &&
        response_js['data'] == scene_button_zone) {
      for (int i = 0; i < 12; i++) {
        scene_color[i] = Colors.black;
      }
      scene_color[response_js['lid']] = Colors.deepOrange;
      scene_button_controller.add(1);
    }

    /// Step 2 : add to the stream to rebuild

    query_button_controller.add(1);
    slider_controller.add(1);
    scene_button_controller.add(1);

    print('Received  message:$payload from topic: ${c[0].topic}>');
  });
}

showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Simple Alert"),
    content: Text("This is an alert message."),
    actions: [
      okButton,
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
