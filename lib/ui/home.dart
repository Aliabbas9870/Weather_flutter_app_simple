import 'dart:convert';
import 'package:cloudy/widgets/constant.dart';
import 'package:cloudy/widgets/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Constants constant = Constants();
  String _location = 'Unknown';
  int _temp = 0;
  @override
  void initState() {
    super.initState();
    _loadPreferences();
    fetchWeatherData(_location);
  }

  _loadPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _location = prefs.getString('location') ?? 'Unknown';
      _temp = prefs.getInt('temp_c') ?? 0;
    });
  }

  _savePreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('location', _location);
    prefs.setInt('temp_c', _temp);
  }

  var cityController = TextEditingController();
  static String apiKey = "012d4836b6c249ada56114741240108";
  String location = "Unknown";
  int temperature = 0;
  int humidity = 0;
  int windspeed = 0;
  int cloud = 0;
  String currentDate = "";
  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];
  String weatherIcon = "sunny";
  String currentWeatherStatus = "";

  String searchWeatherApi =
      "http://api.weatherapi.com/v1/forecast.json?key=$apiKey&days=7&q=";

  void fetchWeatherData(String searchtext) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherApi + searchtext));
      final weatherData = json.decode(searchResult.body);

      var locationData = weatherData["location"];
      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData['name']);
        var parseDate =
            DateTime.parse(locationData['localtime'].substring(0, 10));
        var newdate = DateFormat("MMMMEEEEd").format(parseDate);
        currentDate = newdate;
        currentWeatherStatus = currentWeather['condition']['text'];
        weatherIcon = currentWeatherStatus.replaceAll(" ", "").toLowerCase();
        temperature = currentWeather['temp_c'].toInt();
        humidity = currentWeather['humidity'].toInt();
        windspeed = currentWeather['wind_kph'].toInt();
        cloud = currentWeather['cloud'].toInt();

        dailyWeatherForecast = weatherData['forecast']['forecastday'];
        hourlyWeatherForecast = dailyWeatherForecast[0]['hour'];
        _savePreferences();
      });
    } catch (e) {
      print(e);
    }
  }

  static String getShortLocationName(String s) {
    List<String> locationName = s.split(' ');
    if (locationName.isNotEmpty) {
      if (locationName.length > 1) {
        return locationName[0] + " " + locationName[1];
      } else {
        return locationName[0];
      }
    } else {
      return "";
    }
  }

  Widget weatherItem(
      {required String text,
      required int value,
      required String unit,
      required String imageUrl}) {
    return Column(
      children: [
        Image.asset(imageUrl, width: 40),
        Text(
          "$value$unit",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDrawer(
        forecastTime: currentDate,
      ),
      appBar: AppBar(
        // automaticallyImplyLeading: false,.
        centerTitle: false,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Icon(
                    Icons.person,
                    color: constant.primaryColor,
                    weight: 35,
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/pin.png',
                    color: constant.primaryColor,
                    width: 35,
                  ),
                  IconButton(
                    onPressed: () {
                      cityController.clear();
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: SingleChildScrollView(
                              child: Container(
                                height: size.height * .2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 10),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 70,
                                      child: Divider(
                                        thickness: 2.5,
                                        color: constant.primaryColor,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    TextField(
                                      onChanged: (searchText) {
                                        fetchWeatherData(searchText);
                                      },
                                      controller: cityController,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.search,
                                          color: constant.primaryColor,
                                        ),
                                        suffixIcon: InkWell(
                                          onTap: () => cityController.clear(),
                                          child: Icon(
                                            Icons.close,
                                            color: constant.primaryColor,
                                          ),
                                        ),
                                        hintText: "Search city ..",
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: constant.primaryColor),
                                          borderRadius:
                                              BorderRadius.circular(18),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                    color: constant.primaryColor,
                    icon: Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 35,
                      color: constant.primaryColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentDate,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 16.0,
                ),
              ),
              const SizedBox(height: 50),
              Container(
                width: size.width,
                height: 200,
                decoration: BoxDecoration(
                    color: constant.primaryColor,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: constant.primaryColor.withOpacity(.5),
                        offset: const Offset(0, 25),
                        blurRadius: 10,
                        spreadRadius: -12,
                      )
                    ]),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -40,
                      left: 20,
                      child: Image.asset(
                        'assets/$weatherIcon.png',
                        width: 150,
                      ),
                    ),
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Text(
                        currentWeatherStatus,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 20,
                      right: 20,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              temperature.toString(),
                              style: TextStyle(
                                fontSize: 80,
                                color: constant.textColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            '°C',
                            style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: constant.textColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    weatherItem(
                      text: 'Wind Speed',
                      value: windspeed,
                      unit: 'km/h',
                      imageUrl: 'assets/windspeed.png',
                    ),
                    weatherItem(
                        text: 'Humidity',
                        value: humidity,
                        unit: '%',
                        imageUrl: 'assets/humidity.png'),
                    weatherItem(
                      text: 'Temperature',
                      value: temperature,
                      unit: '°C',
                      imageUrl: 'assets/max-temp.png',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  Text(
                    'Next 7 Days',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: constant.primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: EdgeInsets.only(top: 9),
                height: size.height * .2,
                child: ListView.builder(
                    itemCount: hourlyWeatherForecast.length,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      String currentTime =
                          DateFormat("HH:mm:ss").format(DateTime.now());
                      String currentHour = currentTime.substring(0, 2);
                      String forecastTime = hourlyWeatherForecast[index]['time']
                          .substring(11, 16);
                      String forecastHour = hourlyWeatherForecast[index]['time']
                          .substring(11, 13);

                      String forecastTemperature = hourlyWeatherForecast[index]
                              ["temp_c"]
                          .round()
                          .toString();

                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        margin: EdgeInsets.only(right: 18),
                        width: 60,
                        decoration: BoxDecoration(
                            color: currentHour == forecastHour
                                ? constant.primaryColor
                                : Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(32)),
                            boxShadow: [
                              BoxShadow(
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                  color:
                                      constant.primaryColor.withOpacity(0.2)),
                            ]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              forecastTime,
                              style: TextStyle(
                                  fontSize: 18, color: Colors.white30),
                            ),
                            Text(
                              forecastTemperature,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "°C",
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
