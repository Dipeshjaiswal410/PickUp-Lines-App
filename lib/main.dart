import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pickup_lines/Internet_Connectivity_Bloc/internet_bloc.dart';
import 'package:pickup_lines/homePage.dart';

void main() {
  runApp(BlocProvider(
    create: (context) => InternetBloc(),
    child: const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  ));
}

// Splash Screen Code
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              child: Container(
                  height: size.width / 3.7,
                  width: size.width / 3.7,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      "assets/images/logo.png",
                      fit: BoxFit.fill,
                    ),
                  )),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const Padding(
        padding: EdgeInsets.only(bottom: 7),
        child: Text(
          "PickUp Lines",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
    );
  }
}
