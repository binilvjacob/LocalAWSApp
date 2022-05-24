
import 'dart:convert';
import 'package:dio/dio.dart';


int cmd = 212;
var respCmd;
var respSid;
var respData;
var respLid;
void masterOnControl(int actPage) async {
  // print("sds $actPage");
  String clientIp;
  // switch (actPage) {
  //
  // /// Change PAGE
  //   case 0:
  //     clientIp = cred2.slaveip;
  //     break;
  //   case 1:
  //     clientIp = cred2.slaveip2;
  //     break;
  //   case 2:
  //     clientIp = cred2.slaveip3;
  //     break;
  //   case 3:
  //     clientIp = cred2.slaveip4;
  //     break;
  //   case 4:
  //     clientIp = cred2.slaveip5;
  //     break;
  //   case 5:
  //     clientIp = cred2.slaveip6;
  //     break;
  //   case 6:
  //     clientIp = cred2.slaveip7;
  //     break;
  //   case 7:
  //     clientIp = cred2.slaveip8;
  //     break;
  //   default:
  //     break;
  // }
  String msgLid;
  String gateId;
  // switch (actPage) {
  //
  // /// Change PAGE
  //   case 0:
  //     msgLid = cred2.port1;
  //     gateId = cred2.gatewayid1;
  //     break;
  //   case 1:
  //     msgLid = cred2.port2;
  //     gateId = cred2.gatewayid2;
  //     break;
  //   case 2:
  //     msgLid = cred2.port3;
  //     gateId = cred2.gatewayid3;
  //     break;
  //   case 3:
  //     msgLid = cred2.port4;
  //     gateId = cred2.gatewayid4;
  //     break;
  //   case 4:
  //     msgLid = cred2.port5;
  //     gateId = cred2.gatewayid5;
  //     break;
  //   case 5:
  //     msgLid = cred2.port6;
  //     gateId = cred2.gatewayid6;
  //     break;
  //   case 6:
  //     msgLid = cred2.port7;
  //     gateId = cred2.gatewayid7;
  //     break;
  //   case 7:
  //     msgLid = cred2.port8;
  //     gateId = cred2.gatewayid8;
  //     break;
  //   default:
  //     break;
  // }
  var msgBody = jsonEncode({
    'lid': msgLid,
    'cmd': '208',
    'data': '100',
    'echo': '1',
    'gateid': gateId,
    'gatecmd': 0
  });
  try {
    var options = BaseOptions(
      baseUrl: 'http://$clientIp',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    );
    var dio = Dio(options);
    //  dio.interceptors.add(LogInterceptor(responseBody: true));
    // print("sending on ");

    var response = await dio.post('/post', data: msgBody);
    //print("finished sending");
    if (response.statusCode == 200) {
      respCmd = response.data["cmd"];
      respSid = response.data["sid"];
      respData = response.data["data"];
      respLid = response.data["lid"];
      // print("response : ${response.data}");
     // updateUi(respCmd, respData, respLid);
    } else {
      // print('Request failed with status: ${response.statusCode}.');
    }
  } catch (e) {
    // print(e);
  }
}