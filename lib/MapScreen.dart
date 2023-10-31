import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapWidget extends StatefulWidget {
  final List documents;
  final MapController mapController;
  final PanelController panelController;
  MapWidget(
      {super.key,
      required this.documents,
      required this.mapController,
      required this.panelController});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  @override
  Widget build(BuildContext context) {
    List<Marker> getListOfMarkers() {
      List<Marker> markers = [];
      widget.documents.map((element) {
        markers.add(Marker(
            builder: (context) => GestureDetector(
                  onTap: () async {
                    print("Clicked!");
                    await showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        insetPadding: EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0)),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Text(
                                element["siteName"],
                                style: TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "📍" +
                                        element["address"] +
                                        " " +
                                        element["city"] +
                                        ", " +
                                        element["zipCode"].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                  Text(
                                    "⚠️ Contaminant: " +
                                        element["contaminantName"],
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Chip(
                                    label: Text(element["siteStatus"]),
                                    backgroundColor: (element["siteStatus"] ==
                                            "No Further Action")
                                        ? Colors.red
                                        : (element["siteStatus"] ==
                                                "Cleanup Started")
                                            ? Colors.greenAccent
                                            : (element["siteStatus"] ==
                                                    "Cleanup Started")
                                                ? Colors.lightGreen
                                                : Colors.yellow,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
            point: LatLng(element["latitude"], element["longitude"]),
            width: 80,
            height: 80));
      }).toList();

      return markers;
    }

    return FlutterMap(
      mapController: widget.mapController,
      options: MapOptions(center: LatLng(47.6101, -122.200676), zoom: 15.0),
      children: [
        TileLayer(
          urlTemplate:
              'https://api.mapbox.com/styles/v1/15kc25/clni69zw6000a01oi50l3cn48/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiMTVrYzI1IiwiYSI6ImNsbmd6czRnbDBidXUybW1qcjJiYXJuNGQifQ.Q8r7YIZjYlp2ujJ29T8c6g',
          userAgentPackageName: 'com.example.hazard_aware',
        ),
        MarkerLayer(
          markers: getListOfMarkers(),
        ),
      ],
    );
  }
}
