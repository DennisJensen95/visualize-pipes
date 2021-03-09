import 'package:flutter/material.dart';
import '3d_page.dart';
import 'generic_styles.dart';

class TwoDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("2D page"),
        backgroundColor: idColor,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(top: 15),
        child: ElevatedButton(
          style: GenericButtonStyle,
          onPressed: () {
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new ThreeDPage()),
            );
          },
          child: Text('Go 3D!'),
        ),
      ),
    );
  }
}
