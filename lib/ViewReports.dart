import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hazard_aware/FirebaseOperations.dart';

class ViewReports extends StatefulWidget {
  const ViewReports({super.key});

  @override
  State<ViewReports> createState() => _ViewReportsState();
}

class _ViewReportsState extends State<ViewReports> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection("reportedSites").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("View Reported Sites"),
                ),
                body: (snapshot.data!.docs.length != 0)
                    ? ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, index) {
                          List items = snapshot.data!.docs;
                          return GestureDetector(
                            onTap: () {},
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        width: 2, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(15.0)),
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
                                            items[index]["zipCode"].toString(),
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
                                    ],
                                  ),
                                  trailing: IconButton(
                                      onPressed: () async {
                                        await deleteSite(snapshot
                                            .data!.docs[index].reference.id);
                                      },
                                      icon: Icon(Icons.delete)),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/celebration.png",
                              width: 400,
                              height: 250,
                            ),
                            Text(
                              "Hooray! No sites reported!",
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ));
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
