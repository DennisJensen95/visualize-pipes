import 'package:flutter/material.dart';
import '2d_page.dart';
import 'generic_styles.dart';

class ThreeDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("3D page"),
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 15),
        child: ElevatedButton(
          style: GenericButtonStyle,
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new TwoDPage()),
            );
          },
          child: Text('Go 2D!'),
        ),
      ),
    );
  }
}
