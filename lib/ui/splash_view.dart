
import 'package:cloudy/ui/home.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    navigateHome();
  }

  @override
  Future<void> navigateHome() async {
    await Future.delayed(Duration(seconds: 3));

    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        color: Color(0xff615EFC),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cloud_sharp,
                color: Color(0xffEEEEEE),
                size: 90,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Cloudy",
                style: TextStyle(
                    color: Color(0xffEEEEEE),
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Dont't worry about",
                style: TextStyle(color: Color(0xffEEEEEE), fontSize: 16),
              ),
              Text(
                "the weather we all here",
                style: TextStyle(color: Color(0xffEEEEEE), fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
