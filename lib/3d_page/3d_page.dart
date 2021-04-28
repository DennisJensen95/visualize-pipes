import 'package:flutter/material.dart';
// import 'package:flutter_map/plugin_api.dart';
// import 'package:geolocator/geolocator.dart';
import '../generic_styles.dart';
import 'dart:math';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import '../geo_location.dart';
// import 'package:latlong/latlong.dart';
// import '../2d_page/map_functions.dart';
import '../2d_page/2d_page.dart';
import 'package:flutter_compass/flutter_compass.dart';

class ARCore extends StatefulWidget {
  ARCore({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _ARCoreState createState() => _ARCoreState();
}

class _ARCoreState extends State<ARCore> {
  var compassDirection;
  var gpsPosition;
  int _selectedIndex = 1;

  ArCoreController arCoreController;
  double angleFromCoordinate(
      double lat1, double long1, double lat2, double long2) {
    double dLon = (long2 - long1);

    double y = sin(dLon) * cos(lat2);
    double x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon);

    double brng = atan2(y, x);
    return brng;
  }

  _onArCoreViewCreated(ArCoreController _arCoreController) {
    arCoreController = _arCoreController;
    _addCylinder(arCoreController);
  }

  _addCylinder(ArCoreController _arCoreController) async {
    final double pipe1Length = 40;
    final double pipe2Length = 4;
    final double pipe3Length = 5;
    final material = ArCoreMaterial(color: Colors.blue, reflectance: 0.1);
    final cylinder = ArCoreCylinder(
      materials: [material],
      radius: pipe1Length,
      height: 0.1,
    );
    final cylinder_2 = ArCoreCylinder(
      materials: [material],
      radius: pipe2Length,
      height: 0.1,
    );
    final cylinder_3 = ArCoreCylinder(
      materials: [material],
      radius: pipe3Length,
      height: 0.1,
    );

    var node_2 = ArCoreNode(
        shape: cylinder_2,
        position: vector.Vector3(0, -3, -pipe2Length / 2),
        rotation: vector.Vector4(0.7071068, 0, 0, 0.7071068));
    var node_3 = ArCoreNode(
        shape: cylinder_3,
        position: vector.Vector3(0, -pipe1Length / 2, -pipe3Length / 2),
        rotation: vector.Vector4(0.7071068, 0, 0, 0.7071068));
    var mainNode = ArCoreNode(
        shape: cylinder,
        position: vector.Vector3(0, -5, -10),
        rotation: vector.Vector4(0.5, 0.5, 0.5, 0.5),
        children: [node_2, node_3]);

    _arCoreController.addArCoreNode(mainNode);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    if (_selectedIndex == index) {
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 0) {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new TwoDPage()),
      );
    } else {
      Navigator.push(
        context,
        new MaterialPageRoute(builder: (context) => new ARCore()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Image.asset(
              "lib/assets/images/small_pipe_logo.png",
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text("PipeData",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          backgroundColor: idColor,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: idColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: '2D',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.business),
              label: '3D',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
        ),
        floatingActionButton: Stack(
          children: <Widget>[],
        ));
  }
}

// Actually using compass and GPS to orient camera and show where pipes are.

// var position;
// var pipes = await getPipes();
// double compassOrientation;
// // Get the correct direction
// for (int i = 0; i < 20; i++) {
//   // position = await determinePosition();
//   position = LatLng(55.687087, 12.549062);
//   compassOrientation = await FlutterCompass.events.first;
//   while (compassOrientation <= -180) compassOrientation += 360;
//   while (compassOrientation > 180) compassOrientation -= 360;
//   compassOrientation = compassOrientation * pi / 180;
// }
//
// for (int i = pipePoints.length - 1; i >= 0; i--) {
//   var rotation;
//   var x, y;
//   if (i == 0) {
//     var angle = angleFromCoordinate(position.latitude, position.longitude,
//         pipePoints[i].latitude, pipePoints[i].longitude);
//     var distance = Geolocator.distanceBetween(
//         position.latitude,
//         position.longitude,
//         pipePoints[i].latitude,
//         pipePoints[i].longitude);
//     x = distance * cos((angle + compassOrientation) * pi / 180);
//     y = distance * sin((angle + compassOrientation) * pi / 180);
//     rotation = vector.Vector4(0, pi / 2, pi / 2, 1);
//   } else {
//     var angle = angleFromCoordinate(
//         pipePoints[i - 1].latitude,
//         pipePoints[i - 1].longitude,
//         pipePoints[i].latitude,
//         pipePoints[i].longitude);
//     rotation = vector.Vector4(0, angle, pi / 2, 1);
//     x = 0;
//     y = 0;
//   }

//   lastNode = ArCoreNode(
//     shape: cylinder,
//     position: vector.Vector3(y, -2, x),
//     rotation: rotation,
//     children: lastNode,
//   );
// }

// for (int j = 0; j < pipes.length; j++) {
// var pipePoints = pipes[0].points;
// var lastNode;
