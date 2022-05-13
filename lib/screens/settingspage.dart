import 'package:flutter/material.dart';
import 'package:smart_home/main.dart';

import 'home_screen.dart';

void main() => runApp(Settingspage());

/// This Widget is the main application widget.
class Settingspage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Flutter Card Example')),
        backgroundColor: Colors.yellow,
        body: SettingsWidget(),
      ),
    );
  }
}

/// This is the stateful widget that the main application instantiates.
class SettingsWidget extends StatefulWidget {
  SettingsWidget({Key key}) : super(key: key);

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          /// gateway 1
          ValueListenableBuilder<bool>(
            valueListenable: stat1,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked1,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 1', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          /// gateway 2
          ValueListenableBuilder<bool>(
            valueListenable: stat2,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                //color: Colors.white,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked2,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 2', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          /// gateway 3
          ValueListenableBuilder<bool>(
            valueListenable: stat3,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked3,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 3', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          /// gateway4
          ValueListenableBuilder<bool>(
            valueListenable: stat4,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked4,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 4', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          ///gateway 5
          ValueListenableBuilder<bool>(
            valueListenable: stat5,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked5,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 5', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          ///gateway 6
          ValueListenableBuilder<bool>(
            valueListenable: stat6,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked6,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 6', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          ///gateway 7
          ValueListenableBuilder<bool>(
            valueListenable: stat7,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked7,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 7', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          ///gateway 8
          ValueListenableBuilder<bool>(
            valueListenable: stat8,
            builder: (BuildContext context, value, Widget child) {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.18,
                padding: new EdgeInsets.all(10.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: Colors.white,
                  elevation: 10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        trailing: Checkbox(
                          checkColor: Colors.green,
                          activeColor: Colors.green,
                          shape: CircleBorder(),
                          value: isChecked8,
                          onChanged: (bool value) {
                            setState(() {});
                          },
                        ),
                        title:
                            Text('LiGate 8', style: TextStyle(fontSize: 20.0)),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                color: Colors.blue,
                child: const Text('Check Status'),
                onPressed: () {
                  setState(() {
                    publish('{"username":"ligero","pass":"pass","echo":1}',
                        "679303000");
                    isChecked1 = false;

                    isChecked2 = false;

                    isChecked3 = false;

                    isChecked4 = false;

                    isChecked5 = false;

                    isChecked6 = false;

                    isChecked7 = false;

                    isChecked8 = false;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
