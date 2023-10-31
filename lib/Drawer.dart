import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_aware/HomePage.dart';
import 'package:hazard_aware/ReportHazard.dart';
import 'package:hazard_aware/ViewReports.dart';
import 'package:hazard_aware/main.dart';

class DrawerWidget extends StatefulWidget {
  final User? user;
  const DrawerWidget({super.key, required this.user});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.user!.isAnonymous == true) {
      return Drawer(
        backgroundColor: Color.fromRGBO(173, 216, 230, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 55),
            Container(
              margin: EdgeInsets.fromLTRB(
                18,
                0,
                0,
                0,
              ),
              child: Text(
                "Navigate",
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 15),
            Divider(
              color: Colors.black,
            ),
            SizedBox(height: 25),
            ListTile(
              leading: Icon(
                Icons.map,
                color: Colors.red,
              ),
              title: const Text(
                'Map',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(user: widget.user)));
              },
            ),
            SizedBox(height: 55.0),
            ListTile(
              leading: Icon(
                Icons.warning,
                color: Colors.amber,
              ),
              title: const Text(
                'Report Hazard',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ReportHazard()));
              },
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        backgroundColor: Color.fromRGBO(173, 216, 230, 1),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: 55),
            Container(
              margin: EdgeInsets.fromLTRB(
                18,
                0,
                0,
                0,
              ),
              child: Text(
                "Navigate",
                style: TextStyle(fontSize: 25),
              ),
            ),
            SizedBox(height: 15),
            Divider(
              color: Colors.black,
            ),
            SizedBox(height: 25),
            ListTile(
              leading: Icon(
                Icons.map,
                color: Colors.red,
              ),
              title: const Text(
                'Map',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onTap: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => HomePage(user: widget.user)));
              },
            ),
            SizedBox(height: 55.0),
            ListTile(
              leading: Icon(
                Icons.pin_drop,
                color: Colors.green,
              ),
              title: const Text(
                'New Reports',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ViewReports()));
              },
            ),
          ],
        ),
      );
    }
  }
}
