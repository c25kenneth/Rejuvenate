import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hazard_aware/Drawer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hazard_aware/BarIndicator.dart';
import 'package:hazard_aware/MapScreen.dart';
import 'package:hazard_aware/ReportHazard.dart';
import 'package:hazard_aware/auth.dart';
import 'package:latlong2/latlong.dart';
import 'firebase_options.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  final User? user;
  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List docs = [];
  late MapController _mapController;

  final TextEditingController _searchController = TextEditingController();
  final PanelController _panelController = PanelController();
  var scrollController = ScrollController();

  int loadCount = 15;
  String searchText = '';
  int _index = 0;

  @override
  void initState() {
    super.initState();
    print(widget.user!.uid);
    _mapController = MapController();
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels == 0)
          print('ListView scrolled to top');
        else {
          setState(() {
            loadCount = loadCount + 10;
          });
          print('ListView scrolled to bottom');
        }
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cleanup_sites')
            .limit(loadCount)
            .orderBy("siteName")
            .startAt([searchText.toLowerCase()]).endAt(
                [searchText.toLowerCase() + "\uf8ff"]).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var items = snapshot.data!.docs as List<DocumentSnapshot>;
            return Scaffold(
              drawer: DrawerWidget(
                user: widget.user,
              ),
              appBar: AppBar(
                title: Center(
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/Logo.png',
                        fit: BoxFit.contain,
                        height: 70,
                      ),
                      Text('Rejuvenate')
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      },
                      child: Text("Sign Out"))
                ],
              ),
              extendBody: true,
              body: SlidingUpPanel(
                controller: _panelController,
                defaultPanelState: PanelState.CLOSED,
                minHeight: 50,
                backdropEnabled: true,
                color: Colors.transparent,
                panel: Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(173, 216, 230, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BarIndicator(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 36, vertical: 10),
                        child: SizedBox(
                          height: 50,
                          width: 525,
                          child: Material(
                            elevation: 8,
                            shadowColor: Colors.black87,
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                            child: TextField(
                              controller: _searchController,
                              onChanged: (value) {
                                setState(() {
                                  searchText = value;
                                });
                              },
                              textAlignVertical: TextAlignVertical.bottom,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: "Search by site name",
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: items.length,
                          itemBuilder: (BuildContext context, index) {
                            return GestureDetector(
                              onTap: () {
                                _mapController.move(
                                    LatLng(items[index]["latitude"],
                                        items[index]["longitude"]),
                                    15.0);
                                print("Moved!");
                              },
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      side: const BorderSide(
                                          width: 2, color: Colors.grey),
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  child: ListTile(
                                    title: Text(
                                      items[index]["siteName"],
                                      style: TextStyle(
                                          fontSize: 23.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "📍" +
                                              items[index]["address"] +
                                              " " +
                                              items[index]["city"] +
                                              ", " +
                                              items[index]["zipCode"]
                                                  .toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        Text(
                                          "⚠️ Contaminant: " +
                                              items[index]["contaminantName"],
                                          style: TextStyle(
                                            fontSize: 18,
                                          ),
                                        ),
                                        Chip(
                                          label: Text(
                                            items[index]["siteStatus"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          backgroundColor: (items[index]
                                                      ["siteStatus"] ==
                                                  "No Further Action")
                                              ? Colors.red
                                              : (items[index]["siteStatus"] ==
                                                      "Cleanup Started")
                                                  ? Colors.greenAccent
                                                  : (items[index]
                                                              ["siteStatus"] ==
                                                          "Cleanup Started")
                                                      ? Colors.lightGreen
                                                      : Colors.yellow,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                collapsed: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      BarIndicator(),
                    ],
                  ),
                ),
                body: Stack(
                  children: [
                    MapWidget(
                      panelController: _panelController,
                      mapController: _mapController,
                      documents: items,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
