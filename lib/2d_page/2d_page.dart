import 'package:flutter/material.dart';
import 'package:pipemap/geo_location.dart';
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
  int _selectedIndex = 0;

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
              icon: Icon(Icons.map),
              label: '2D',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.remove_red_eye),
              label: '3D',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        body: futureWidget(),
        floatingActionButton: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    heroTag: "btn2",
                    onPressed: () async {
                      // center.latitude = 55.78195485276012; // DTU Skylab
                      // center.longitude = 12.512840572766047; // DTU Skylab
                      // center.latitude = 55.687054966630846; // Skyttegade
                      // center.longitude = 12.548926815486908; // Skyttegade
                      var pos = await determinePosition();
                      center.latitude = pos.latitude;
                      center.longitude = pos.longitude;
                      mapController.move(center, 15);
                    },
                    child: const Icon(
                      Icons.location_on,
                      color: Color(0xff00adb4),
                    ),
                    backgroundColor: Colors.white,
                  )),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    heroTag: "btn3",
                    onPressed: () async {
                      // center.latitude = 55.78195485276012; // DTU Skylab
                      // center.longitude = 12.512840572766047; // DTU Skylab
                      // center.latitude = 55.687054966630846; // Skyttegade
                      // center.longitude = 12.548926815486908; // Skyttegade
                      center.latitude = 5.659764442286405; // Acra
                      center.longitude = -0.01485431751483095; // Acra
                      mapController.move(center, 15);
                    },
                    child: const Icon(
                      Icons.local_airport,
                      color: Color(0xff00adb4),
                    ),
                    backgroundColor: Colors.white,
                  )),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    heroTag: "Zoom in",
                    onPressed: () async {
                      mapController.move(center, mapController.zoom + 0.5);
                    },
                    child: const Icon(
                      Icons.zoom_in,
                      color: Color(0xff00adb4),
                    ),
                    backgroundColor: Colors.white,
                  )),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Align(
                  alignment: Alignment.centerRight,
                  child: FloatingActionButton(
                    heroTag: "Zoom out",
                    onPressed: () async {
                      mapController.move(center, mapController.zoom - 0.5);
                    },
                    child: const Icon(
                      Icons.zoom_out,
                      color: Color(0xff00adb4),
                    ),
                    backgroundColor: Colors.white,
                  )),
              SizedBox(height: MediaQuery.of(context).size.height / 40),
              Align(alignment: Alignment.bottomRight, child: infoWindow)
            ],
          ),
          // SizedBox(height: MediaQuery.of(context).size.height / 40),
        ]));
  }
}
