import 'package:flutter/material.dart';
import '../3d_page.dart';
import '../generic_styles.dart';
import './map_functions.dart';
import '../geo_location.dart' as geo;
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart' as latLng;

latLng.LatLng center = latLng.LatLng(55.676098, 12.568337);
MapController mapController = MapController();

class TwoDPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("2D page"),
          backgroundColor: idColor,
        ),
        body: getMap(mapController, 15, center),
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment(
                  Alignment.topCenter.x + 0.03, Alignment.topCenter.y + 0.2),
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
                    Position position = await geo.determinePosition();
                    center.latitude = position.latitude;
                    center.longitude = position.longitude;
                    mapController.move(center, 18.45);
                  },
                  child: const Icon(Icons.account_tree_rounded),
                  backgroundColor: idColor,
                )),
          ],
        ));
  }
}
