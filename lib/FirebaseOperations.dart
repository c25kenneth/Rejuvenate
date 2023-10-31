import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future getInitialDocs() async {
  final result = await FirebaseFirestore.instance
      .collection("cleanup_sites")
      .limit(15)
      .get();

  final List documents = result.docs;
  return documents;
}

Future<User?> SignInAnon() async {
  try {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    print("Signed in with temporary account.");
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Anonymous auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
}

Future<User?> SignInEmailAndPassword(String email, String password) async {
  try {
    final userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    print("Signed in with email and password.");
    return userCredential.user;
  } on FirebaseAuthException catch (e) {
    switch (e.code) {
      case "operation-not-allowed":
        print("Auth hasn't been enabled for this project.");
        break;
      default:
        print("Unknown error.");
    }
  }
}

Future<void> reportHazard(String siteName, String location, String cityName,
    int zipCode, String contaminants) async {
  var db = FirebaseFirestore.instance;
  await db.collection("reportedSites").add({
    "siteName": siteName,
    "address": location,
    "city": cityName,
    "zipCode": zipCode,
    "contaminantName": contaminants,
  });
}

Future deleteSite(String siteID) async {
  var db = FirebaseFirestore.instance;
  await db.collection("reportedSites").doc(siteID).delete().then(
        (doc) => print("Document deleted"),
        onError: (e) => print("Error updating document $e"),
      );
}
