import 'package:flutter/material.dart';
import 'package:pipemap/generic_styles.dart';

TextStyle objectStyle = TextStyle(color: idColor, fontWeight: FontWeight.bold);
TextStyle objectData = TextStyle(color: Colors.black);

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
          margin: const EdgeInsets.only(left: 5, right: 5.0),
          height: MediaQuery.of(context).size.height / 3,
          width: MediaQuery.of(context).size.width / 4,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white), color: Colors.white),
          child: FittedBox(
            fit: BoxFit.fill,
            child: Text.rich(TextSpan(children: <InlineSpan>[
              TextSpan(text: 'Pipe object id', style: objectStyle),
              TextSpan(text: '\n$objectId\n', style: objectData),
              TextSpan(text: 'Pipe Material', style: objectStyle),
              TextSpan(text: '\n$pipeMaterial\n', style: objectData),
              TextSpan(text: 'District', style: objectStyle),
              TextSpan(text: '\n$district\n', style: objectData),
              TextSpan(text: 'Installation date', style: objectStyle),
              TextSpan(text: '\n$pipeRegistered\n', style: objectData),
              TextSpan(text: 'Diameter', style: objectStyle),
              TextSpan(text: '\n$diameter\n', style: objectData),
              TextSpan(text: 'Region', style: objectStyle),
              TextSpan(text: '\n$region\n', style: objectData),
              TextSpan(text: 'SVC State', style: objectStyle),
              TextSpan(text: '\n$svcState\n', style: objectData),
              TextSpan(text: 'Pressure class', style: objectStyle),
              TextSpan(text: '\n$pressure\n', style: objectData),
            ])),
          ),
        ));
  }
}
