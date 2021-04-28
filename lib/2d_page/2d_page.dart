import 'package:flutter/material.dart';
import '../3d_page/3d_page.dart';
import '../generic_styles.dart';
import './map_functions.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import './info_window.dart';

// LatLng center = LatLng(55.78193411330404, 12.512833196691487); // DTU Skylab
LatLng center = LatLng(55.687054966630846, 12.548926815486908); // Skyttegade
MapController mapController = MapController();
InfoWindowController infoWindowController = InfoWindowController();

class TwoDPage extends StatefulWidget {
  @override
  _TwoDPage createState() => _TwoDPage();
}

class _TwoDPage extends State<TwoDPage> {
  var infoWindow = InfoWindow(controller: infoWindowController);
  Widget futureWidget() {
    return new FutureBuilder(
      future: getPipes(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return getMap(
              mapController, 10, center, snapshot.data, infoWindowController);
        } else if (snapshot.hasError) {
          return new Text("${snapshot.error}");
        }
        return new CircularProgressIndicator();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("2D page"),
          backgroundColor: idColor,
        ),
        body: futureWidget(),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new ARCore()),
                  );
                },
                child: new Text('3D'),
                backgroundColor: idColor,
              ),
            ),
            Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () async {
                    // center.latitude = 55.78195485276012; // DTU Skylab
                    // center.longitude = 12.512840572766047; // DTU Skylab
                    center.latitude = 55.687054966630846; // Skyttegade
                    center.longitude = 12.548926815486908; // Skyttegade
                    mapController.move(center, 15);
                  },
                  child: const Icon(Icons.account_tree_rounded),
                  backgroundColor: idColor,
                )),
            Align(alignment: Alignment.bottomLeft, child: infoWindow),
          ],
        ));
  }
}
