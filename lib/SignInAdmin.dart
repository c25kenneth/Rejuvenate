import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_aware/FirebaseOperations.dart';
import 'package:hazard_aware/HomePage.dart';

class SignInAdmin extends StatefulWidget {
  const SignInAdmin({super.key});

  @override
  State<SignInAdmin> createState() => _SignInAdminState();
}

class _SignInAdminState extends State<SignInAdmin> {
  String email = "";
  String password = "";

  Widget inputField(bool isPassword) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: SizedBox(
        height: 50,
        child: Material(
          elevation: 8,
          shadowColor: Colors.black87,
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(30),
          child: TextField(
            obscureText: (isPassword == true) ? true : false,
            onChanged: (val) {
              if (isPassword == true) {
                setState(() {
                  password = val;
                });
              } else if (isPassword == false) {
                setState(() {
                  email = val;
                });
              }
            },
            textAlignVertical: TextAlignVertical.bottom,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: (isPassword == false) ? "Email" : "Password",
              prefixIcon: (isPassword == false)
                  ? Icon(Icons.email)
                  : Icon(Icons.password),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sign In as Admin",
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color.fromRGBO(82, 125, 255, 1),
                  letterSpacing: 2.5),
            ),
            SizedBox(height: 12.0),
            Text("Make sure your account exists with the State of WA",
                style: TextStyle(fontSize: 17.5, fontWeight: FontWeight.w600)),
            SizedBox(height: 25),
            inputField(false),
            inputField(true),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(90, 158, 242, 1),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(100, 40), //////// HERE
                ),
                onPressed: () async {
                  try {
                    User? currentUser =
                        await SignInEmailAndPassword(email, password);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomePage(
                                  user: currentUser,
                                )));
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 4),
                      backgroundColor: Colors.red,
                      content: Text('Sign in unsuccessful! Try again later'),
                    ));
                  }
                },
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      MediaQuery.of(context).size.width * 0.2,
                      5,
                      MediaQuery.of(context).size.width * 0.2,
                      5),
                  child: Text(
                    'Sign In As Admin',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 75,
            )
          ],
        ),
      ),
    );
  }
}
