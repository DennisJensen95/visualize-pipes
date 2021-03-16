import 'package:flutter/material.dart';
import '2d_page.dart';
import '3d_page.dart';
import 'generic_styles.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var title = 'PipeMap';
    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Center(
            child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            new ElevatedButton(
              style: genericButtonStyle,
              child: new Text('2D'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new TwoDPage()),
                );
              },
            ),
            new ElevatedButton(
              style: genericButtonStyle,
              child: new Text('3D'),
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new ARCore()),
                );
              },
            )
          ],
        )),
      ),
    );
  }
}
