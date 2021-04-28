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
        position: vector.Vector3(0, -2, -10),
        rotation: vector.Vector4(0.5, 0.5, 0.5, 0.5),
        children: [node_2, node_3]);

    _arCoreController.addArCoreNode(mainNode);
  }

  @override
  void dispose() {
    arCoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("3D"),
          backgroundColor: idColor,
        ),
        body: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new TwoDPage()),
                  );
                },
                child: new Text('2D'),
                backgroundColor: idColor,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: "btn2",
                onPressed: () async {
                  var tmp = await FlutterCompass.events.first;
                  var tmpPosition = await determinePosition();
                  setState(() {
                    compassDirection = tmp;
                    gpsPosition = tmpPosition;
                  });
                },
                child: new Text('Compass'),
                backgroundColor: idColor,
              ),
            ),
            Align(
                alignment: Alignment.bottomLeft,
                child: Opacity(
                    opacity: 0.7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                      height: MediaQuery.of(context).size.height / 4,
                      width: MediaQuery.of(context).size.width / 4,
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          color: Colors.grey),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                            '''compassDirection $compassDirection\nGPS position: $gpsPosition
                                    ''',
                            style: TextStyle(color: Colors.black)),
                      ),
                    )))
          ],
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
