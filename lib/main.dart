import 'package:cloudy/ui/home.dart';
import 'package:cloudy/ui/splash_view.dart';
import 'package:flutter/material.dart';



void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Cloudy App',
      home: SplashView(),
      debugShowCheckedModeBanner: false,
    );
  }
}
