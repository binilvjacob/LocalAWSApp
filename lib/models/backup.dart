import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_home/amplifyconfiguration.dart';
import 'package:smart_home/screens/screens.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:convert';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

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

import 'models/employee.dart';
import 'amplifyconfiguration.dart';

Color qry_btn_color = Colors.white;
Color qry_btn_color2 = Colors.white;
bool slider_animation = false;
int zone_add = 0;
int page_no = 0;
var selected_lamp = 0;

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

  print("in");
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
        home: AnimatedSplashScreen(
            duration: 1000,
            splash: 'assets/images/ligero.jpg',
            nextScreen: LoginDemo(),
            splashTransition: SplashTransition.scaleTransition,
            //pageTransitionType: PageTransitionType.scale,
            backgroundColor: Colors.white));
  }
}
// home: LoginDemo(),
//HomeScreen(),

void widget_init() async {}

/// MQTT code below

MqttServerClient client;
var _onDisconnected;
var _onConnected;
var _onSubscribed;
var _iotEndpoint = "a241ufymd7jocg-ats.iot.ap-south-1.amazonaws.com";
var _clientId = "kaladyApp5";
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
  print('Connected to broker');
}

void onDisconnected() {
  mqtt_connection_status = false;

  print('Disconnected');
}

/// subscribe to topic succeeded
void onSubscribed(String topic) {
  mqtt_sub_status = true;
  print('Subscribed topic: $topic');
}

/// subscribe to topic failed
void onSubscribeFail(String topic) {
  mqtt_sub_status = false;
  print('Failed to subscribe $topic');
}

// unsubscribe succeeded
void onUnsubscribed(String topic) {
  mqtt_sub_status = false;
  print('Unsubscribed topic: $topic');
}

/// PING response received
void pong() {
  print('Ping response client callback invoked');
}

void recon() {
  mqtt_connection_status = false;
  connectivity_duration = Duration(seconds: 20);
  connectivity_color = Colors.red;
  slider_controller.add(1);
  slider_controller1.add(1);
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
  print('ggg');
  try {
    caData = await rootBundle.load('assets/CA.pem');
    certData = await rootBundle.load('assets/client_certificate.pem.crt');
    privateKeyData = await rootBundle.load('assets/private_key.pem.key');
  } catch (e) {
    print(e);
  }
  const _iotEndpoint = 'a241ufymd7jocg-ats.iot.ap-south-1.amazonaws.com';
  const _clientId = 'kaladyApp6';
  client = MqttServerClient.withPort(_iotEndpoint, _clientId, 8883,
      maxConnectionAttempts: 5);

  client.logging(on: false);
  client.onConnected = onConnected;
  client.onDisconnected = onDisconnected;
  client.onUnsubscribed = onUnsubscribed;
  client.onSubscribed = onSubscribed;
  client.onSubscribeFail = onSubscribeFail;
  client.pongCallback = pong;
  client.autoReconnect = true;
  client.secure = true;
  client.onAutoReconnect = recon;
  client.keepAlivePeriod = 60;
  final connMessage = MqttConnectMessage()
      .withClientIdentifier("client-3")
      .authenticateAs('esp', 'pass')
      .withWillTopic('willtopic')
      .withWillMessage('Will message')
      .startClean()
      .withWillQos(MqttQos.atLeastOnce);

  final securityContext = SecurityContext.defaultContext;

  securityContext.useCertificateChainBytes(certData.buffer.asUint8List());
  securityContext.usePrivateKeyBytes(privateKeyData.buffer.asUint8List());
  securityContext.setClientAuthoritiesBytes(caData.buffer.asUint8List());

  //client.securityContext = securityContext;

  // V3.1.1 for iot-core
  client.setProtocolV311();

  client.connectionMessage = connMessage;
  try {
    await client.connect();
    if (client != null &&
        client.connectionStatus.state == MqttConnectionState.connected) {
      print("Connected to AWS Successfully!");
      print(client);
      // isConnected = true;
    }
  } catch (e) {
    print('Exception: $e');
    //client.disconnect();
  }
  if (client.connectionStatus.state == MqttConnectionState.connected) {
    print('iotcore client connected');
  } else {
    print(
        'ERROR iotcore client connection failed - disconnecting, state is ${client.connectionStatus.state}');
    //client.disconnect();
  }
  try {
    subscribe('echo');
    // subscribe('gatewayB');
    // subscribe('gatewayC');
    // subscribe('gatewayD');
  } catch (e) {
    print(e);
  }

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
  } catch (e) {
    print(e);
  }
  return (client);
}

Future<MqttServerClient> subscribe(String sub_top) async {
  /// subscribe to topic

  try {
    print('trying subscribe');
    print("inaaaa $client");
    client.subscribe(sub_top, MqttQos.atLeastOnce);
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
    print("scene_button_zone $scene_button_zone");

    /// Step 1 : update the widget parameter
    ///lamp_page power
    if (response_js['cmd'] == 208 &&
        response_js['lid'] == power_button_zone &&
        response_js['devid'] == 0) {
      powerbuttoncolor = Colors.deepOrange;
      power_button_cmd = 212;
      power_button_controller.add(1);
    } else if (response_js['cmd'] == 212 &&
        response_js['lid'] == power_button_zone &&
        response_js['devid'] == 0) {
      powerbuttoncolor = Colors.white;
      power_button_cmd = 208;
      power_button_controller.add(1);
    }

    ///device
    if (response_js['cmd'] == 308 && response_js['lid'] == power_button_zone2) {
      powerbuttoncolor2 = Colors.deepOrange;
      power_button_cmd2 = 312;
      power_button_controller.add(1);
    } else if (response_js['cmd'] == 312 &&
        response_js['lid'] == power_button_zone) {
      powerbuttoncolor2 = Colors.white;
      power_button_cmd2 = 308;
      power_button_controller.add(1);
    } else if (response_js['cmd'] == qry_cmd) {
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
    } else if (response_js['cmd'] == qry_cmd2) {
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
    }

    /// slider control lamp page
    else if (response_js['cmd'] == 208 && response_js['lid'] == selected_lamp) {
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
    }

    ///devices page center button
    else if (response_js['cmd'] == 308 && response_js['lid'] == selected_lamp) {
      slider_animation = true;
      resp_test2 = 100;
      slider_value2 = 100;
      slider_cmd2 = 312;
      light_master_color2 = Colors.yellow;
      slider_controller.add(1);
    } else if (response_js['cmd'] == 312 &&
        response_js['lid'] == selected_lamp) {
      slider_animation = true;
      resp_test2 = 0;
      slider_value2 = 0;
      slider_cmd2 = 308;
      light_master_color2 = Colors.white;
      slider_controller.add(1);
    }

    ///query updation
    else if (response_js['cmd'] == 39 &&
        response_js['lid'] == selected_lamp &&
        response_js['gate'] == ourList[HomeScreen.roomIndex]['gatesub']) {
      print("working???");
      print("selected lamp $selected_lamp");
      slider_animation = true;
      if (response_js['data'].toDouble() <= 100) {
        resp_test = response_js['data'].toDouble();
        slider_value = response_js['data'].toDouble();
        print(response_js);
        qry_wait = false;
        slider_controller.add(1);
      }
      qry_wait = false;
    }

    ///curtain open/close
    else if (response_js['cmd'] == 202 && response_js['lid'] == selected_lamp) {
      slider_animation = true;
      resp_test1 = 100;
      slider_value1 = 100;
      print(slider_value1);
      //slider_cmd = 221;
      slider_controller.add(1);
    } else if (response_js['cmd'] == 221 &&
        response_js['lid'] == selected_lamp) {
      slider_animation = true;
      resp_test1 = 0;
      slider_value1 = 0;
      print(slider_value);
      slider_controller.add(1);
    } else if (response_js['cmd'] == 200 &&
        response_js['lid'] == selected_lamp &&
        response_js['data'] > 0) {
      slider_animation = false;
      resp_test = slider_value;
      slider_cmd = 212;
      slider_controller.add(1);
    } else if (response_js['cmd'] == 201 &&
        response_js['lid'] == selected_lamp &&
        response_js['data'] > 0) {
      slider_animation = false;
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
    }

    ///scene icons updation
    else if (response_js['cmd'] == scene_button_cmd &&
        response_js['lid'] == scene_button_zone) {
      for (int i = 0; i < 12; i++) {
        scene_color[i] = Colors.black;
      }

      scene_color[response_js['data']] = Colors.deepOrange;
      scene_button_controller.add(1);
    } else if (response_js['cmd'] == scene_button_cmd1 &&
        response_js['data'] == scene_button_zone) {
      for (int i = 0; i < 12; i++) {
        scene_color1[i] = Colors.black;
      }

      scene_color1[response_js['lid']] = Colors.deepOrange;
      scene_button_controller1.add(1);
    } else if (response_js['cmd'] == scene_button_cmd2 &&
        response_js['data'] == scene_button_zone) {
      for (int i = 0; i < 12; i++) {
        scene_color2[i] = Colors.black;
      }

      scene_color2[response_js['lid']] = Colors.deepOrange;
      scene_button_controller1.add(1);
    }

    /// Step 2 : add to the stream to rebuild

    query_button_controller.add(1);
    query_button_controller2.add(1);
    slider_controller.add(1);
    scene_button_controller.add(1);
    scene_button_controller1.add(1);

    slider_controller1.add(1);

    print('Received  message:$payload from topic: ${c[0].topic}>');
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
  final SecureStorage secureStorage = SecureStorage();

  bool _amplifyConfigured = false;
  // final _amplifyInstance = Amplify();

  Future<void> _configureAmplify() async {
    try {
      // AmplifyAuthCognito auth = AmplifyAuthCognito();
      // _amplifyInstance.addPlugin(
      //   authPlugins: [auth],
      // );
      // await _amplifyInstance.configure(amplifyconfig);

      AmplifyAuthCognito auth = AmplifyAuthCognito();
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);

      setState(() => _amplifyConfigured = true);
    } catch (e) {
      print(e);
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
    /*to store files temporary we use getTemporaryDirectory() but we need
    permanent storage so we use getApplicationDocumentsDirectory() */
    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + fileName);
      print('directory path is');
      print(dir.path);
      fileExists = jsonFile.existsSync();
      print('file indavo?');
      print(fileExists);
      print("Creating file!");
      File file = new File(dir.path + "/" + fileName);
      file.createSync();
      fileExists = jsonFile.existsSync();
      file.writeAsStringSync(jsonEncode(content));

      print(fileExists);
      // if (fileExists)
      //   this.setState(
      //       () => fileContent = jsonDecode(jsonFile.readAsStringSync()));
      String str = jsonFile.readAsStringSync();
      print(str);
      var str_js = jsonDecode(str);
      print(str_js['lid']);
      String asw = jsonEncode(str_js);
      print(asw);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Container(
              height: 40,
              width: 125,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: FlatButton(
                onPressed: () async {
                  var userEmail = userController.text;
                  var userPass = passwordController.text;
                  Map<String, String> userAttributes = {
                    "email": "aswinrajkailath@gmail.com",
                    "phone_number": "+918086535843"
                  };
                  try {
                    final signInResult = await Amplify.Auth.signIn(
                        username: userEmail, password: userPass);
                    print('login success');
                    if (signInResult.isSignedIn) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    }
                  } on AuthException catch (e) {
                    print(e);
                  }

                  //   final signUpResult = await Amplify.Auth.signUp(
                  //     username: userEmail,
                  //     password: userPass,
                  //     options:
                  //         CognitoSignUpOptions(userAttributes: userAttributes),
                  //   );
                  //   print('login success');
                  //   if (signUpResult.isSignUpComplete) {
                  //     Navigator.push(
                  //         context,
                  //         MaterialPageRoute(
                  //             builder: (context) => HomeScreen()));
                  //   }
                  // } on AuthException catch (e) {
                  //   print(e);
                  // }

                  // if (await secureStorage.readSecureData('username') ==
                  //         userController.text &&
                  //     await secureStorage.readSecureData('password') ==
                  //         passwordController.text) {
                  //   //loginFlag = 1;
                  //   print('ENTERED');
                  //   _getStoragePermission();
                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => HomeScreen()));
                  // } else if (await secureStorage.readSecureData('username') ==
                  //         null &&
                  //     await secureStorage.readSecureData('password') == null) {
                  //   await secureStorage.writeSecureData(
                  //       'username', userController.text);
                  //   await secureStorage.writeSecureData(
                  //       'password', passwordController.text);
                  //   //loginFlag = 1;
                  //
                  //   Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (context) => HomeScreen(),
                  //       ));
                  // } else {
                  //   showDialog(
                  //       context: context,
                  //       builder: (BuildContext context) {
                  //         return AlertDialog(
                  //           title: Text(
                  //             "Error",
                  //           ),
                  //           content: Text(
                  //             'Invalid Credentials!',
                  //             style: TextStyle(
                  //               color: Colors.red,
                  //             ),
                  //           ),
                  //           actions: [
                  //             FlatButton(
                  //               child: Text("Ok"),
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //               },
                  //             )
                  //           ],
                  //         );
                  //       });
                  // }
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
            Container(
              height: 40,
              width: 125,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                child: Text(
                  'Configure',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                onPressed: () {
                  var httpClient = new HttpClient();
                  Future<File> _downloadFile(String url) async {
                    bool fileExist = false;
                    final response = await http.get(Uri.parse(url));

                    String dir = (await getExternalStorageDirectory()).path;
                    File fileC = new File('$dir/conh.json');
                    fileExist = fileC.existsSync();
                    print(fileExist);
                    fileC.createSync();
                    fileC.writeAsStringSync(response.body);
                    print('kitti mwone');
                    print(fileC);

                    return fileC;
                  }

                  _downloadFile('https://ligerolight.in/dinu/getfile.php');
                },
              ),
            ),
            FlatButton(
              onPressed: () {
                try {
                  Amplify.Auth.signOut();
                } on AuthException catch (e) {
                  print(e.message);
                }
              },
              child: Text(
                'Forgot Password',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            SizedBox(
              height: 100,
            ),
            Text('New User? Create Account')
          ],
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
    // This is where you can initialize the resources needed by your app while
    // the splash screen is displayed.  Remove the following example because
    // delaying the user experience is a bad design practice!
    await Future.delayed(Duration(seconds: 3));
  }
}

Future<void> mains() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory directory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(EmployeeAdapter());
}
