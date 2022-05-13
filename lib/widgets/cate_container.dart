import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CateContainer extends StatelessWidget {
  final String image;
  final String name;
  final String temp;
  final Function onTap;

  CateContainer({
    @required this.image,
    @required this.name,
    @required this.temp,
    @required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: _height * 0.45,
        width: _width * 0.55,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: _width * .005),
          borderRadius: BorderRadius.circular(15),
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
