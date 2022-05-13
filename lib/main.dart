import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_home/amplifyconfiguration.dart';
import 'package:smart_home/screens/add_edit.dart';
import 'package:smart_home/screens/password_reset.dart';
import 'package:smart_home/screens/schedulepicker.dart';
import 'package:smart_home/screens/screens.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:typed_data/typed_data.dart' as typed;
import 'package:smart_home/screens/lamppage.dart';
import 'package:smart_home/screens/curtainscreen.dart';
import 'package:smart_home/screens/sprinkler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:smart_home/models/SecureStorage.dart';
import 'package:http/http.dart' as http;
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:connectivity/connectivity.dart';

import 'models/employee.dart';
import 'amplifyconfiguration.dart';
import 'package:smart_home/screens/signup.dart';

int fetch_flag = 0;
int selected = 0;

/// flag for demo
int dynamo_flag = 0;


///flag for lamp master initialiser
int refresh_flag = 1;

///settings page variables
bool isChecked1 = false;
bool isChecked2 = false;
bool isChecked3 = false;
bool isChecked4 = false;
bool isChecked5 = false;
bool isChecked6 = false;
bool isChecked7 = false;
bool isChecked8 = false;

/// settings page ui variables
ValueNotifier<bool> stat1 = ValueNotifier(false);
ValueNotifier<bool> stat2 = ValueNotifier(false);
ValueNotifier<bool> stat3 = ValueNotifier(false);
ValueNotifier<bool> stat4 = ValueNotifier(false);
ValueNotifier<bool> stat5 = ValueNotifier(false);
ValueNotifier<bool> stat6 = ValueNotifier(false);
ValueNotifier<bool> stat7 = ValueNotifier(false);
ValueNotifier<bool> stat8 = ValueNotifier(false);

var response_js;
var toast_flag;

bool toggle;

///array for fetching sc id
List<int> initial_id = [];

var list = Iterable<int>.generate(150).toList();

Future<String> fetchAlbum() async {
  if (fetch_flag == 0) {
    final response = await http.get(Uri.parse(
        'https://20h1ogfvnj.execute-api.us-east-1.amazonaws.com/default/ScheduleFunction'));

    if (response.statusCode == 200) {
      var js = jsonDecode(response.body);

      ///////////////////////////// Code to update scheduler ui ///////
      for (int k = 0; k < js['homeData'].length; k++) {
        Employee addEmployee = new Employee(
            empName: '${js['homeData'][k]['sc_name']}',
            empSalary: '${js['homeData'][k]['dev_status']}',
            empAge:
                "${js['homeData'][k]['sc_hour']}:${js['homeData'][k]['sc_min']}",
            //empId: empId_generator()
            empId: '${js['homeData'][k]['sc_id']}',
            dalidata: '${js['homeData'][k]['dali_data']}',
            scstat: '${js['homeData'][k]['sc_status']}',
            scdestaddr: '${js['homeData'][k]['sc_destination_addr']}',
            screpeat: '${js['homeData'][k]['sc_repeat']}',
            daliaddr: '${js['homeData'][k]['dali_addr']}');
        if (dynamo_flag == 0 &&
            addEmployee.empSalary != '0' &&
            addEmployee.daliaddr != '0') {
          print('${addEmployee.daliaddr}');
          listEmployees.add(addEmployee);
        }
        //listEmployees.add(addEmployee);
      }
      fetch_flag = 1;

      for (int h = 0; h < listEmployees.length; h++) {
        if (listEmployees[h].empSalary == '0') {
          deletedId.insert(h, listEmployees[h].empId);
          print('${listEmployees[h].empName}');
        }
        try {
          initial_id.add(int.parse(listEmployees[h].empId));

          list.remove(int.parse(listEmployees[h].empId));
        } catch (e) {}
      }

      sc_ui_update.value = !sc_ui_update.value;

      ///////////////////////////////////////////////////////

      return "dummy";
    } else {
      throw Exception('Failed to load album');
    }
  } else {
    return "dummy";
  }
}

/// Variables for scheduelr ui updation
var device_name;
var sc_stat1;
var light_name;

var device_status;
var device_hour;
var device_min;
var resp_dali_data;
var resp_dali_addr;
var resp_sc_repeat;
var resp_sc_dest_sddr;
ValueNotifier<bool> sc_ui_update = ValueNotifier(false);
List<Employee> listEmployees = [];

///////////////////////////////////

int login_flag;

Color qry_btn_color = Colors.white;
Color qry_btn_color2 = Colors.white;
bool slider_animation = false;
int zone_add = 0;
int page_no = 0;

double resp_test = 0;
double resp_test1 = 0;
double resp_test2 = 0;

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

var responsed_dummy_json = jsonEncode(response_dummy);

var lamp_count;

var cur_count;
var connect_flag = 1;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("hai");
  connect_flag = 0;
  await connect();
  mains();

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
    if (connect_flag == 0) {
      connect();
    }
    super.initState();

    _configureAmplify();
    StreamSubscription hubSubscription =
        Amplify.Hub.listen([HubChannel.Auth], (hubEvent) {
      switch (hubEvent.eventName) {
        case "SIGNED_IN":
          {
            print("USER IS SIGNED IN");
          }
          break;
        case "SIGNED_OUT":
          {
            print("USER IS SIGNED OUT");
          }
          break;
        case "SESSION_EXPIRED":
          {
            print("USER IS SIGNED IN");
          }
          break;
      }
    });
  }

  bool _amplifyConfigured = false;
  Future<void> _configureAmplify() async {
    try {
      AmplifyAuthCognito auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);
      setState(() => _amplifyConfigured = true);
    } catch (e) {
      setState(() => _amplifyConfigured = false);
    }
    setState(() => _amplifyConfigured = true);
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
      home: FutureBuilder<int>(
          future: getIntValuesSF(),
          initialData: 3,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return check();
            } else {
              return CircularProgressIndicator();
            }
          }),
    );
  }
}

void widget_init() async {}

/// MQTT code below

MqttServerClient client;

var connectionState;
var connectivity_duration = Duration(seconds: 20);

void onConnected() {
  connect_flag = 1;
  mqtt_connection_status = true;
  connectivity_duration = Duration(seconds: 2);
  connectivity_color = Colors.green;
  slider_controller.add(1);
  slider_controller1.add(1);
  connectivity_controller.add(1);
}

void onDisconnected() {
  mqtt_connection_status = false;
}

/// subscribe to topic succeeded
void onSubscribed(String topic) {
  mqtt_sub_status = true;
}

/// subscribe to topic failed
void onSubscribeFail(String topic) {
  mqtt_sub_status = false;
}

// unsubscribe succeeded
void onUnsubscribed(String topic) {
  mqtt_sub_status = false;
}

/// PING response received
void pong() {}

void recon() {
  mqtt_connection_status = false;
  connectivity_duration = Duration(seconds: 20);
  connectivity_color = Colors.red;
  slider_controller.add(1);
  slider_controller1.add(1);
  connectivity_controller.add(1);
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
StreamController<int> query_button_controller2 =
    StreamController<int>.broadcast();

StreamController<int> slider_controller = StreamController<int>.broadcast();

StreamController<int> slider_controller1 = StreamController<int>.broadcast();

StreamController<int> scene_button_controller =
    StreamController<int>.broadcast();
StreamController<int> scene_button_controller1 =
    StreamController<int>.broadcast();

///Future<String> _fetchData;
Future connect() async {
  try {
    caData = await rootBundle.load('assets/CA.pem');
    certData = await rootBundle.load('assets/client_certificate.pem.crt');
    privateKeyData = await rootBundle.load('assets/private_key.pem.key');
  } catch (e) {}
  const _iotEndpoint = 'a2g51829pn9fac-ats.iot.us-east-1.amazonaws.com';
  const _clientId = '683587000001';
  client = MqttServerClient.withPort(_iotEndpoint, _clientId, 8883,
      maxConnectionAttempts: 5);

  client.logging(on: true);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;
  client.autoReconnect = true;
  client.secure = true;
  client.onAutoReconnect = recon;
  client.keepAlivePeriod = 30;
  final connMessage = MqttConnectMessage()
      .withClientIdentifier(_clientId)
      .authenticateAs('esp', 'pass')
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  final securityContext = SecurityContext.defaultContext;

  securityContext.useCertificateChainBytes(certData.buffer.asUint8List());
  securityContext.usePrivateKeyBytes(privateKeyData.buffer.asUint8List());
  securityContext.setClientAuthoritiesBytes(caData.buffer.asUint8List());

  client.setProtocolV311();

  client.connectionMessage = connMessage;
  try {
    await client.connect();
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
    }
  } catch (e) {}
  if (client.connectionStatus.state == MqttConnectionState.connected) {
  } else {}
  try {
    print("subscripton area");

    ///schecho_test
    Subscribe('683587000/echo', '683587000/schecho_test');
    // Subscribe('683587000/echo', '683587000/schecho_test');
  } catch (e) {}

  return client;
}

Future<MqttServerClient> publish(pub_mes, String pubtopic) async {
  ///Publish a known topic

  String pub_top = pubtopic;
  var buff = typed.Uint8Buffer(pub_mes.length);
  for (int i = 0; i < pub_mes.length; i++) {
    buff[i] = pub_mes.codeUnitAt(i);
  }
  try {
    client.publishMessage(pub_top, MqttQos.atLeastOnce, buff);
  } catch (e) {}
  return (client);
}

Future<MqttServerClient> Subscribe(String sub_top1, String sub_top2) async {
  /// subscribe to topic

  try {
    client.subscribe(sub_top1, MqttQos.atLeastOnce);
    client.subscribe(sub_top2, MqttQos.atLeastOnce);
  } catch (e) {}
  client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c) {
    final MqttPublishMessage message = c[0].payload;
    final payload =
        MqttPublishPayload.bytesToStringAsString(message.payload.message);
    response_js = jsonDecode(payload);

    if (c[0].topic == "683587000/schecho_test") {
      /// Code for scheduler UI updation
      device_name = response_js['sc_id'];
      light_name = response_js['sc_name'];
      device_status = response_js['dev_status'];
      device_hour = response_js['sc_hour'];
      device_min = response_js['sc_min'];
      resp_dali_data = response_js['dali_data'];
      resp_dali_addr = response_js['dali_addr'];
      sc_stat1 = response_js['sc_status'];
      resp_sc_repeat = response_js['sc_repeat'];
      resp_sc_dest_sddr = response_js['sc_destination_addr'];

      if (response_js['sc_cmd'] == "1") {
        update_sc_ui();
      } else if (response_js['sc_cmd'] == '0') {
        delete_sc_ui();
      } else if (response_js['sc_cmd'] == '2') {
        edit_sc_ui();
      } else if (response_js['sc_cmd'] == '3') {
        if (response_js['sc_status'] == '0') {
          edit_sc_ui_for_toggle();
        } else {
          edit_sc_ui_for_toggle();
        }
      }

      /// Code to update variable of valuelistenable

    } else if (c[0].topic == "683587000/echo") {
      toast_flag = 1;
      if (response_js['cmd'] == 208 &&
          response_js['lid'] == power_button_zone &&
          response_js['devid'] == 0) {
        powerbuttoncolor = Colors.deepOrange;
        power_button_cmd = 212;
        power_button_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 212 &&
          response_js['lid'] == power_button_zone &&
          response_js['devid'] == 0) {
        toast_flag = 1;
        powerbuttoncolor = Colors.white;
        power_button_cmd = 208;
        power_button_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      ///settings page ui updation
      if (response_js['gate'] == "000" && response_js['lid'] == 0) {
        isChecked1 = true;
        stat1.value = !stat1.value;
      }
      if (response_js['gate'] == "001" && response_js['lid'] == 0) {
        isChecked2 = true;
        stat2.value = !stat2.value;
      }
      if (response_js['gate'] == "002" && response_js['lid'] == 0) {
        isChecked3 = true;
        stat3.value = !stat3.value;
      }
      if (response_js['gate'] == "008" && response_js['lid'] == 0) {
        isChecked4 = true;
        stat4.value = !stat4.value;
      }
      if (response_js['gate'] == "011" && response_js['lid'] == 0) {
        isChecked5 = true;
        stat5.value = !stat5.value;
      }
      if (response_js['gate'] == "012" && response_js['lid'] == 0) {
        isChecked6 = true;
        stat6.value = !stat6.value;
      }
      if (response_js['gate'] == "013" && response_js['lid'] == 0) {
        isChecked7 = true;
        stat7.value = !stat7.value;
      }
      if (response_js['gate'] == "014" && response_js['lid'] == 0) {
        isChecked8 = true;
        stat8.value = !stat8.value;
      }

      ///for gates toast
      else if (response_js['cmd'] == 206) {
        toast_flag = 1;
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      ///device
      if (response_js['cmd'] == 308 &&
          response_js['lid'] == power_button_zone2) {
        toast_flag = 1;
        powerbuttoncolor2 = Colors.deepOrange;
        power_button_cmd2 = 312;
        power_button_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 312 &&
          response_js['lid'] == power_button_zone) {
        toast_flag = 1;
        powerbuttoncolor2 = Colors.white;
        power_button_cmd2 = 308;
        power_button_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == qry_cmd) {
        toast_flag = 1;
        String dumm = response_js['data'].toString();

        slider_animation = true;
        slider_cmd = 212;
        qry_icon_color = Colors.green;
        qry_wait = false;
        light_master_color = Colors.yellow;
        query_button_controller.add(1);
        slider_value = double.parse(dumm);
        resp_test = double.parse(dumm);
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == qry_cmd2) {
        toast_flag = 1;
        String dumm = response_js['data'].toString();
        slider_animation = true;
        slider_cmd2 = 312;
        qry_icon_color2 = Colors.green;
        qry_wait2 = false;
        light_master_color2 = Colors.yellow;
        query_button_controller2.add(1);
        slider_value2 = double.parse(dumm);
        resp_test2 = double.parse(dumm);
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      /// slider control lamp page
      else if (response_js['cmd'] == 208 &&
          response_js['lid'] == selected_lamp) {
        toast_flag = 1;
        slider_animation = true;
        resp_test = 100;
        slider_value = 100;
        slider_cmd = 212;
        light_master_color = Colors.yellow;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 212 &&
          response_js['lid'] == selected_lamp) {
        toast_flag = 1;
        slider_animation = true;
        resp_test = 0;
        slider_value = 0;
        slider_cmd = 208;
        light_master_color = Colors.white;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      ///devices page center button
      else if (response_js['cmd'] == 308 &&
          response_js['lid'] == selected_lamp) {
        toast_flag = 1;
        slider_animation = true;
        resp_test2 = 100;
        slider_value2 = 100;
        slider_cmd2 = 312;
        light_master_color2 = Colors.yellow;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 312 &&
          response_js['lid'] == selected_lamp) {
        toast_flag = 1;
        slider_animation = true;
        resp_test2 = 0;
        slider_value2 = 0;
        slider_cmd2 = 308;
        light_master_color2 = Colors.white;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      ///query updation
      else if (response_js['cmd'] == 39 &&
          response_js['lid'] == selected_lamp &&
          response_js['gate'] == ourList[HomeScreen.roomIndex]['gatename']) {
        toast_flag = 1;

        slider_animation = true;
        qry_btn_color = Colors.cyan[700];
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
        if (response_js['data'].toDouble() > 0) {
          toast_flag = 1;
          resp_test = response_js['data'].toDouble();
          slider_value = response_js['data'].toDouble();
          light_master_color = Colors.yellow;
          slider_cmd = 212;
          qry_wait = false;
          slider_controller.add(1);
        } else if (response_js['data'].toDouble() == 0) {
          toast_flag = 1;
          resp_test = response_js['data'].toDouble();
          slider_value = response_js['data'].toDouble();
          light_master_color = Colors.white;
          slider_cmd = 208;
          qry_wait = false;
          slider_controller.add(1);
        }
        qry_wait = false;
        //qry_btn_color = Colors.red;
      }

      ///curtain open/close
      else if (response_js['cmd'] == 203 &&
          response_js['lid'] == selected_lamp1) {
        toast_flag = 1;
        slider_animation = true;
        resp_test1 = 100;
        slider_value1 = 100;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 221 &&
          response_js['lid'] == selected_lamp) {
        toast_flag = 1;
        slider_animation = true;
        resp_test1 = 0;
        slider_value1 = 0;

        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 200 &&
          response_js['lid'] == selected_lamp &&
          response_js['data'] > 0) {
        toast_flag = 1;
        slider_animation = false;
        resp_test = slider_value;
        slider_cmd = 212;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 201 &&
          response_js['lid'] == selected_lamp &&
          response_js['data'] > 0) {
        toast_flag = 1;
        slider_animation = false;
        resp_test = slider_value;
        slider_cmd = 212;
        light_master_color = Colors.yellow;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      } else if (response_js['cmd'] == 201 &&
          response_js['lid'] == selected_lamp &&
          response_js['data'] == 0) {
        toast_flag = 1;
        slider_animation = false;
        resp_test = slider_value;
        slider_cmd = 208;
        light_master_color = Colors.white;
        slider_controller.add(1);
        Fluttertoast.showToast(
          textColor: Colors.green,
          backgroundColor: Colors.grey[800],
          msg: 'Success',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }

      ///scene icons updation
      else if (response_js['cmd'] == scene_button_cmd &&
          response_js['lid'] == scene_button_zone) {
        for (int i = 0; i < 12; i++) {
          toast_flag = 1;
          scene_color[i] = Colors.black;
        }

        scene_color[response_js['data']] = Colors.teal[300];
        scene_button_controller.add(1);
      } else if (response_js['cmd'] == scene_button_cmd1 &&
          response_js['data'] == scene_button_zone) {
        toast_flag = 1;
        for (int i = 0; i < 12; i++) {
          scene_color1[i] = Colors.black;
        }

        scene_color1[response_js['lid']] = Colors.teal[300];
        scene_button_controller1.add(1);
      } else if (response_js['cmd'] == scene_button_cmd2 &&
          response_js['data'] == scene_button_zone) {
        toast_flag = 1;
        for (int i = 0; i < 12; i++) {
          scene_color2[i] = Colors.black;
        }

        scene_color2[response_js['lid']] = Colors.teal[300];
        scene_button_controller1.add(1);
      }

      /// Step 2 : add to the stream to rebuild
      query_button_controller.add(1);
      query_button_controller2.add(1);
      slider_controller.add(1);
      scene_button_controller.add(1);
      scene_button_controller1.add(1);
      slider_controller1.add(1);
    }
  });
}

///login page class goes here
class LoginDemo extends StatefulWidget {
  @override
  _LoginDemoState createState() => _LoginDemoState();
}

class _LoginDemoState extends State<LoginDemo> {
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final configController = TextEditingController();
  final SecureStorage secureStorage = SecureStorage();

  bool _amplifyConfigured = false;
  // final _amplifyInstance = Amplify();

  Future<void> _configureAmplify() async {
    try {
      AmplifyAuthCognito auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);

      setState(() => _amplifyConfigured = true);
    } catch (e) {
      //print(e);
      setState(() => _amplifyConfigured = false);
    }
    setState(() => _amplifyConfigured = true);
  }

  File jsonFile;
  Directory dir;
  String fileName = "configFile.json";
  bool fileExists = false;
  Map<String, String> fileContent;
  Map<String, String> content = {
    "lid": "34",
    "type": "9w",
    "maxlevel": "100",
    "minlevel": "0"
  };

  @override
  void initState() {
    super.initState();
    _configureAmplify();

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);

      fileExists = jsonFile.existsSync();

      File file = new File(dir.path + "/" + fileName);
      file.createSync();
      fileExists = jsonFile.existsSync();
      file.writeAsStringSync(jsonEncode(content));

      ;
      String str = jsonFile.readAsStringSync();

      var str_js = jsonDecode(str);

      String asw = jsonEncode(str_js);
    });
  }

  final _formKey1 = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey1,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Center(child: Text("Ligero Home Automation")),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
                child: Center(
                  child: Container(
                      width: 200,
                      height: 150,
                      child: Image.asset('assets/images/ligero.jpg')),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextFormField(
                  //validator: validateEmail,
                  controller: userController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    hintText: 'Enter valid username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid username';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.security),
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter secure password'),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 7) {
                      return 'Invalid Password ';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15.0, top: 15, bottom: 0),
                child: TextFormField(
                  //validator: validateEmail,
                  controller: configController,
                  decoration: InputDecoration(
                    icon: Icon(Icons.vpn_key),
                    border: OutlineInputBorder(),
                    labelText: 'Housename',
                    hintText: 'Enter your housename',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Invalid housename';
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                height: 40,
                width: 125,
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20)),
                child: FlatButton(
                  onPressed: () async {
                    isInternet();
                    var httpClient = new HttpClient();
                    Future<File> _downloadFile(String url) async {
                      bool fileExist = false;
                      final response = await http.get(Uri.parse(url));

                      String dir = (await getExternalStorageDirectory()).path;
                      File fileC = new File('$dir/conh.json');
                      fileExist = fileC.existsSync();
                      fileC.createSync();
                      fileC.writeAsStringSync(response.body);

                      Fluttertoast.showToast(
                        textColor: Colors.green,
                        backgroundColor: Colors.grey[800],
                        msg: 'Configured Successfully!',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                      );
                      return fileC;
                    }

                    Future<File> _downloadSchFile(String url) async {
                      bool fileExist = false;
                      final response = await http.get(Uri.parse(url));

                      String dir = (await getExternalStorageDirectory()).path;

                      File fileC = new File('$dir/sch.json');
                      fileExist = fileC.existsSync();

                      fileC.createSync();
                      fileC.writeAsStringSync(response.body);

                      return fileC;
                    }

                    _downloadFile(
                        'https://ligeroautomation.com/lihome/${configController.text}.php');
                    _downloadSchFile(
                        'https://ligeroautomation.com/lihome/getfile_nmmi.php');
                    if (_formKey1.currentState.validate()) {
                      addIntToSF(int val) async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.setInt('intValue', val);
                      }

                      addIntToSF(1);
                      Amplify.Auth.signOut();

                      var userEmail = userController.text;
                      var userPass = passwordController.text;
                      Fluttertoast.showToast(
                        backgroundColor: Colors.grey[800],
                        msg: 'Logging in...',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.TOP,
                      );

                      try {
                        final signInResult = await Amplify.Auth.signIn(
                            username: userEmail, password: userPass);
                        print('login success');
                        if (signInResult.isSignedIn) {
                          Fluttertoast.showToast(
                            backgroundColor: Colors.grey[800],
                            msg: 'Log in success!',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.TOP,
                          );

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }
                      } on AuthException catch (e) {
                        Fluttertoast.showToast(
                          textColor: Colors.red[200],
                          backgroundColor: Colors.grey[800],
                          msg: 'Error Logging in! Check network status.. ',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.TOP,
                        );
                      }
                    }
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              // Container(
              //   height: 40,
              //   width: 125,
              //   decoration: BoxDecoration(
              //       color: Colors.blue,
              //       borderRadius: BorderRadius.circular(20)),
              //   child: TextButton(
              //     child: Text(
              //       'Configure',
              //       style: TextStyle(color: Colors.white, fontSize: 20),
              //     ),
              //     onPressed: () {
              //       var httpClient = new HttpClient();
              //       Future<File> _downloadFile(String url) async {
              //         bool fileExist = false;
              //         final response = await http.get(Uri.parse(url));
              //
              //         String dir = (await getExternalStorageDirectory()).path;
              //         File fileC = new File('$dir/conh.json');
              //         fileExist = fileC.existsSync();
              //         fileC.createSync();
              //         fileC.writeAsStringSync(response.body);
              //
              //         Fluttertoast.showToast(
              //           textColor: Colors.green,
              //           backgroundColor: Colors.grey[800],
              //           msg: 'Configured Successfully!',
              //           toastLength: Toast.LENGTH_LONG,
              //           gravity: ToastGravity.TOP,
              //         );
              //         return fileC;
              //       }
              //
              //       Future<File> _downloadSchFile(String url) async {
              //         bool fileExist = false;
              //         final response = await http.get(Uri.parse(url));
              //
              //         String dir = (await getExternalStorageDirectory()).path;
              //
              //         File fileC = new File('$dir/sch.json');
              //         fileExist = fileC.existsSync();
              //
              //         fileC.createSync();
              //         fileC.writeAsStringSync(response.body);
              //
              //         return fileC;
              //       }
              //
              //       _downloadFile(
              //           'https://ligeroautomation.com/lihome/getfile_nmmi.php');
              //       _downloadSchFile(
              //           'https://ligeroautomation.com/lihome/getfile_nmmi.php');
              //     },
              //   ),
              // ),
              SizedBox(
                height: 30,
              ),
              FlatButton(
                onPressed: () {
                  setState(() {
                    showAlertDialog_forgot(context);
                  });

                  // try {
                  //   Amplify.Auth.signOut();
                  // } on AuthException catch (e) {}
                },
                child: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.blue, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignupDemo()));
                  },
                  child: Text('New User? Create Account'))
            ],
          ),
        ),
      ),
    );
  }
}

bool permissionGranted;
Future _getStoragePermission() async {
  if (await Permission.storage.request().isGranted) {
    {
      permissionGranted = true;
    }
    ;
  } else if (await Permission.storage.request().isPermanentlyDenied) {
    await openAppSettings();
  } else if (await Permission.storage.request().isDenied) {
    {
      permissionGranted = false;
    }
    ;
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xe1f5fe).withOpacity(1.0),
      body: Center(child: Image.asset('assets/splash.png')),
    );
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    await Future.delayed(Duration(seconds: 3));
  }
}

Future<void> mains() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(EmployeeAdapter());
}

class check extends StatefulWidget {
  @override
  State<check> createState() => _checkState();
}

class _checkState extends State<check> {
  @override
  Widget build(BuildContext context) {
    if (log_flag == 1) {
      return AnimatedSplashScreen(
          duration: 1000,
          splash: 'assets/images/ligero.jpg',
          nextScreen: HomeScreen(),
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: Colors.white);
    } else if (log_flag == 0) {
      return AnimatedSplashScreen(
          duration: 1000,
          splash: 'assets/images/ligero.jpg',
          nextScreen: LoginDemo(),
          splashTransition: SplashTransition.scaleTransition,
          backgroundColor: Colors.white);
    } else if (log_flag == 3) {
      return CircularProgressIndicator();
    } else {
      return Container();
    }
  }
}

var log_flag;
Future<int> getIntValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int intValue = prefs.getInt('intValue') ?? 0;
  print("Intvalue: $intValue");
  log_flag = intValue;
  return intValue;
}

addIntToSF(int val) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('intValue', val);
}

showAlertDialog_forgot(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Ok"),
    onPressed: () {
      // toast_flag = 0;

      // toast_timer = Timer(Duration(seconds: 2), toastfunc);

      Navigator.of(context).pop();
    },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(" Reset password"),
    content: Text(
        "Contact admin or email to admin@ligeroautomation.com to reset password!"),
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

Future<bool> isInternet() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    // I am connected to a mobile network, make sure there is actually a net connection.
    if (await DataConnectionChecker().hasConnection) {
      // Mobile data detected & internet connection confirmed.

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
    // I am connected to a WIFI network, make sure there is actually a net connection.
    if (await DataConnectionChecker().hasConnection) {
      // Wifi detected & internet connection confirmed.
      // Fluttertoast.showToast(
      //   backgroundColor: Colors.grey[800],
      //   msg: 'Wifi missing internet access',
      //   toastLength: Toast.LENGTH_LONG,
      //   gravity: ToastGravity.TOP,
      // );
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
