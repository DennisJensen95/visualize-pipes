import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_map_tappable_polyline/flutter_map_tappable_polyline.dart';
import './info_window.dart';

var dataGlobal;

FlutterMap getMap(MapController mapController, double zoom, LatLng center,
    pipes, InfoWindowController infoWindow) {
  return FlutterMap(
    mapController: mapController,
    options: MapOptions(
      minZoom: 10,
      maxZoom: 18.0,
      zoom: zoom,
      center: center,
      plugins: [
        TappablePolylineMapPlugin(),
      ],
    ),
    layers: [
      TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
      TappablePolylineLayerOptions(
          polylineCulling: true,
          polylines: pipes,
          onTap: (TaggedPolyline polyline) =>
              {infoWindow.setPipeData(getPipeData(polyline.tag))},
          onMiss: () {
            print('No polyline was tapped');
          }),
    ],
  );
}

dynamic getPipeData(String inputTag) {
  for (int i = 0; i < dataGlobal["features"].length - 1; i++) {
    var tag = dataGlobal["features"][i]["properties"]["OBJECTID"].toString();
    if (tag.contains(inputTag)) {
      return dataGlobal["features"][i]["properties"];
    }
  }

  // If information is not found
  return {
    "OBJECTID": -1,
    "PIPE_ID": "",
    "MATERIAL": "Dummy",
    "YEAR_INSTA": 0,
    "DN": -1,
    "THICKNESS": 0,
    "OPS_TYPE": "Distribution",
    "SVC_STATE": "In use",
    "PRESS_CLAS": 0,
    "DISTRICT": "None",
    "REGION": "Tema",
    "DATE_REG": "1899-11-30T00:00:00.000Z",
    "F_NODE": 0,
    "T_NODE": 0,
    "REMARKS": "",
    "SHAPE_Leng": 133.09156893
  };
}

Future<List<TaggedPolyline>> getPipes() async {
  final String response =
      await rootBundle.loadString('lib/assets/data/skyttegade.json');
  final data = await json.decode(response);
  dataGlobal = data;
  List<TaggedPolyline> pipesData = [];
  for (int i = 0; i < data["features"].length; i++) {
    List<LatLng> onePipeData = [];
    var add = false;
    var tag = data["features"][i]["properties"]["OBJECTID"].toString();
    for (int j = 0;
        j < data["features"][i]["geometry"]["coordinates"].length - 1;
        j++) {
      if (data["features"][i]["geometry"]["coordinates"][j].length == 2) {
        LatLng point = LatLng(
            data["features"][i]["geometry"]["coordinates"][j][1],
            data["features"][i]["geometry"]["coordinates"][j][0]);

        onePipeData.add(point);

        add = true;
      }
    }
    if (add) {
      TaggedPolyline line = TaggedPolyline(
          tag: tag, points: onePipeData, strokeWidth: 4.0, color: Colors.blue);
      pipesData.add(line);
    }
  }
  return pipesData;
}
