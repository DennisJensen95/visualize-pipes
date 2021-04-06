import 'package:flutter/material.dart';

typedef PipeData(dynamic jsonInformation);

class InfoWindowController {
  PipeData setPipeData;
}

class InfoWindow extends StatefulWidget {
  const InfoWindow({this.controller});
  final InfoWindowController controller;

  @override
  _InfoWindowState createState() => _InfoWindowState();
}

class _InfoWindowState extends State<InfoWindow> {
  var objectId = "Unknown";
  var pipeMaterial = "Unknown";
  var district = "Unknown";
  var pipeRegistered = "Unknown";
  var diameter = "Unknown";
  var pressure = "Unknown";
  var svcState = "Unknown";
  var region = "Unknown";

  @override
  void initState() {
    super.initState();
    InfoWindowController _controller = widget.controller;
    if (_controller != null) {
      _controller.setPipeData = setPipeData;
    }
  }

  void setPipeData(dynamic jsonInformation) {
    setState(() => {
          objectId = jsonInformation["OBJECTID"].toString(),
          pipeMaterial = jsonInformation["MATERIAL"],
          district = jsonInformation["DISTRICT"],
          pipeRegistered = jsonInformation["DATE_REG"].substring(0, 10),
          diameter = jsonInformation["DN"].toString(),
          pressure = jsonInformation["PRESS_CLAS"].toString(),
          svcState = jsonInformation["SVC_STATE"],
          region = jsonInformation["REGION"],
        });
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
        opacity: 0.7,
        child: Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
          height: MediaQuery.of(context).size.height / 4,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey), color: Colors.grey),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
                '''Pipe object id: ${objectId}\nPipe Material: ${pipeMaterial}\nDistrict: ${district}\nInstallation date: ${pipeRegistered}\nDiameter: ${diameter}\nRegion: ${region}\nSVC State: ${svcState}\nPressure class: ${pressure}
                                    ''',
                style: TextStyle(color: Colors.black)),
          ),
        ));
  }
}
