import 'package:flutter/material.dart';

class Brightnessselector extends StatefulWidget {
  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<Brightnessselector> {
  double value = 0;
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorColor: Colors.black,
            activeTrackColor: Colors.yellow[800], //Colors.black87,
            inactiveTrackColor: Colors.black, //Colors.grey[200],
            //showValueIndicator: ShowValueIndicator.onlyForDiscrete,
            valueIndicatorTextStyle: TextStyle(color: Colors.yellow[800]),
            trackShape: RectangularSliderTrackShape(),
            trackHeight: 4.0,
            thumbColor: Colors.white,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.0),
            overlayColor: Colors.white38,
            overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            label: '${value.toInt()}%',
            divisions: 100,
            //inactiveColor: Colors.grey[300],
            onChanged: (val) {
              value = val;
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
