import 'package:cloudy/widgets/constant.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  final String forecastTime;

  const MyDrawer({super.key, required this.forecastTime});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  final Constants constant = Constants();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: constant.primaryColor,
      child: Column(
        children: [
          DrawerHeader(
              child: Center(
                  child: ListTile(
            leading: Icon(Icons.date_range),
            title: Text(widget.forecastTime),
          )))
        ],
      ),
    );
  }
}
