import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart' as latLng;

FlutterMap getMap(
    MapController mapController, double zoom, latLng.LatLng center) {
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
          urlTemplate: "http://a.tile.stamen.com/toner/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c']),
      MarkerLayerOptions(
        markers: [
          Marker(
            width: 80.0,
            height: 80.0,
            point: latLng.LatLng(51.5, -0.09),
            builder: (ctx) => Container(
              child: FlutterLogo(),
            ),
          ),
        ],
      ),
    ],
  );
}
