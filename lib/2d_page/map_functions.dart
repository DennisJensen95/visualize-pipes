import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

FlutterMap getMap(
    MapController mapController, double zoom, LatLng center, pipes) {
  return FlutterMap(
    mapController: mapController,
    options: MapOptions(
      minZoom: 10,
      maxZoom: 20,
      zoom: zoom,
      center: center,
    ),
    layers: [
      TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
      PolylineLayerOptions(polylines: pipes
          // polylines: [
          //   Polyline(points: points, strokeWidth: 4.0, color: Colors.blue),
          // ],
          ),
    ],
  );
}

Future<List<Polyline>> getPipes() async {
  final String response =
      await rootBundle.loadString('lib/assets/data/test.json');
  final data = await json.decode(response);
  List<Polyline> pipesData = [];
  for (int i = 0; i < data["features"].length - 1; i++) {
    List<LatLng> onePipeData = [];
    var add = false;
    for (int j = 0;
        j < data["features"][i]["geometry"]["coordinates"].length;
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
      Polyline line =
          Polyline(points: onePipeData, strokeWidth: 4.0, color: Colors.blue);
      pipesData.add(line);
    }
  }
  return pipesData;
}
