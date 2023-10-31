import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hazard_aware/FirebaseOperations.dart';
import 'package:hazard_aware/HomePage.dart';
import 'package:hazard_aware/SignInAdmin.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

// image from <a href="https://www.freepik.com/free-vector/blue-gradient-blur-phone-wallpaper-vector_26987163.htm#page=3&query=app%20background&position=12&from_view=keyword&track=ais">Image by rawpixel.com</a> on Freepik

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage("assets/images/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Column(
            children: [
              SizedBox(height: 95),
              Image.asset(
                "assets/images/signin.png",
                width: 200,
                height: 200,
              ),
              Text(
                "Rejuvenate",
                style: TextStyle(
                    letterSpacing: 5,
                    fontSize: 37,
                    fontWeight: FontWeight.bold),
              ),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(82, 113, 255, 1),
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(100, 40), //////// HERE
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignInAdmin()));
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
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  minimumSize: Size(100, 40), //////// HERE
                ),
                onPressed: () async {
                  try {
                    User? currentUser = await SignInAnon();
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
                    'Continue as User',
                    style: TextStyle(
                      color: Color.fromRGBO(82, 113, 255, 1),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 55,
              ),
            ],
          ),
        )
      ],
    ));
  }
}
