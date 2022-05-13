import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ListWheelScrollView Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Wheel(),
    );
  }
}

class Wheel extends StatefulWidget {
  @override
  _WheelState createState() => _WheelState();
}

class _WheelState extends State<Wheel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Geeksforgeeks"),
        backgroundColor: Colors.green,
      ),
      body: ListWheelScrollView(
        itemExtent: 100,
        children: <Widget>[
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 1",
              textAlign: TextAlign.start,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 2",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 3",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 4",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 5",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 6",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 7",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
          RaisedButton(
            onPressed: null,
            child: Text(
              "Item 8",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 25),
            ),
          ),
        ],
      ),
    );
  }
}
