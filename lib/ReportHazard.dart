import 'package:flutter/material.dart';
import 'package:hazard_aware/FirebaseOperations.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportHazard extends StatefulWidget {
  const ReportHazard({super.key});

  @override
  State<ReportHazard> createState() => _ReportHazardState();
}

class _ReportHazardState extends State<ReportHazard> {
  String siteName = "";
  String siteLocation = "";
  String cityName = "";
  late int zipCode;
  String contaminants = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[200],
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Report a contamination site"),
        elevation: 2,
        backgroundColor: Colors.purpleAccent,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Image.asset(
            "assets/images/CleaningUp.png",
            height: 275,
            width: 275,
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: SizedBox(
              height: 50,
              width: 525,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black87,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      siteName = val;
                    });
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: "Site Name*",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ex. Pike Place Market",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: SizedBox(
              height: 50,
              width: 525,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black87,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      siteLocation = val;
                    });
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: "Site location or street address *",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ex. 1428 Post Alley",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: SizedBox(
              height: 50,
              width: 525,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black87,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      cityName = val;
                    });
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: "City Name*",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ex. Seattle",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: SizedBox(
              height: 50,
              width: 525,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black87,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      zipCode = int.parse(val);
                    });
                  },
                  keyboardType: TextInputType.number,
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: "Zip Code*",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ex. 98101",
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 8),
            child: SizedBox(
              height: 50,
              width: 525,
              child: Material(
                elevation: 8,
                shadowColor: Colors.black87,
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      contaminants = val;
                    });
                  },
                  textAlignVertical: TextAlignVertical.bottom,
                  decoration: InputDecoration(
                    labelText: "Known contaminants",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: "Ex. Petroleum-gasoline",
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: OutlinedButton(
                onPressed: () async {
                  if (siteName != "" &&
                      siteLocation != "" &&
                      cityName != "" &&
                      zipCode != "" &&
                      contaminants != "") {
                    await reportHazard(siteName, siteLocation, cityName,
                        zipCode, contaminants);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 4),
                      backgroundColor: Colors.red,
                      content: Text('One or more fields are empty!'),
                    ));
                  }
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(
                    width: 2.0,
                    color: Colors.green,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.green),
                )),
          ),
        ]),
      ),
    );
  }
}
