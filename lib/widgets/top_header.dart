import 'package:amplify_flutter/amplify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/screens/home_screen.dart';
import 'package:smart_home/screens/scheduler.dart';
import 'package:smart_home/screens/settingspage.dart';

class TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: 24, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.menu,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    isInternet1();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => NavDrawer()));
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: Text(
                  'Welcome Home',
                  style: TextStyle(
                      color: Colors.white,
                      //fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ],
          ),
          Column(
            children: [
              Container(
                child: IconButton(
                  icon: Icon(
                    Icons.offline_bolt_outlined,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    isInternet1();
                    showAlertDialog(context);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 80),
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                      fit: BoxFit.scaleDown,
                      image: AssetImage('assets/images/ligero.jpg'))),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.timer),
              title: Text('Scheduler'),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FutureBuilder(
                              initialData: "ddd",
                              future: fetchAlbum(),
                              builder: (context, snapshot) {
                                print("enterd future");
                                print(fetch_flag);
                                if (fetch_flag == 1) {
                                  print('inside flag 1');
                                  return EmployeesListScreen();
                                } else {
                                  return Container(
                                      width: 200,
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 150,
                                            right: 150,
                                            top: 350,
                                            bottom: 350),
                                        child: CircularProgressIndicator(),
                                      ));
                                }
                              },
                            )
                        // EmployeesListScreen()
                        ))
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsWidget()))
              },
            ),
            ListTile(
              leading: Icon(Icons.border_color),
              title: Text('Feedback'),
              onTap: () => {Navigator.of(context).pop()},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Logout'),
              onTap: () => {
                addIntToSF(0),
                Amplify.Auth.signOut(),
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MyApp())),
              },
            ),
          ],
        ),
      ),
    );
  }
}

///Kill switch alert dialog
showAlertDialog(BuildContext context) {
  // Create button
  Widget okButton = FlatButton(
    child: Text("Turn On"),
    //onPressed: () {
    //publish('{"lid":255,"cmd":208,"echo":1,"000":1, "001":1, "002":1}',
    //"679303000");
    // Navigator.of(context).pop();
    //},
  );
  Widget noButton = FlatButton(
    child: Text("Turn Off"),
    // onPressed: () {
    //   publish('{"lid":255,"cmd":212,"echo":1,"000":1, "001":1, "002":1}',
    //       "679303000");
    //   Navigator.of(context).pop();
    // },
  );

  // Create AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Main Switch"),
    content: Text("Turn On/Off all devices"),
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
