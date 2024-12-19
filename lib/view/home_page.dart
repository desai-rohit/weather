import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather/const/animation.dart';
import 'package:weather/model/hour_Weather_model.dart';
import 'package:weather/model/weather_model.dart';
import 'package:weather/provider/weather_Provider.dart';
import 'package:weather/service/weather_service.dart';
import 'package:weather/theme/color.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    WeatherProvider weatherProvider =
        Provider.of<WeatherProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Colors.blueAccent,
      onRefresh: () async {
        weatherProvider.getLocation();
        if (weatherProvider.permissiondeniedForever == true) {
          showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Permission'),
              content: const Text(
                  'this app need location permission to get weather your location please click open settings and allow the permission'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    handler.openAppSettings();
                    Navigator.pop(context);
                  },
                  child: const Text('Open Setting'),
                ),
              ],
            ),
          );
        }
      },
      child: Consumer<WeatherProvider>(
        builder: (context, value, child) => Scaffold(
            body: FutureBuilder<WeatherModel>(
                future: WeatherService()
                    .getWeather(value.latitude, value.longitude),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    WeatherModel weatherData = snapshot.data;
                    var sunriseMillisecond =
                        DateTime.fromMillisecondsSinceEpoch(
                            weatherData.sys.sunrise * 1000);
                    var sunsetMillisecond = DateTime.fromMillisecondsSinceEpoch(
                        weatherData.sys.sunset * 1000);

                    var sunRise =
                        DateFormat('hh:mm a').format(sunriseMillisecond);
                    var sunSet =
                        DateFormat('hh:mm a').format(sunsetMillisecond);

                    return Stack(
                      children: [
                        SizedBox(
                            child: Image.asset(
                          "assets/images/winter_night.jpg",
                          height: height,
                          fit: BoxFit.cover,
                        )),
                        Padding(
                          padding: const EdgeInsets.only(top: 34),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: header(weatherData),
                                ),
                                SizedBox(
                                  height: 24,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Text(
                                    "Today forcast",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: color_white),
                                  ),
                                ),
                                SizedBox(
                                  height: 12,
                                ),
                                todayForcast(value, height, weatherData),
                                windHumidity(height, context, weatherData),
                                Row(
                                  children: [
                                    sunRiseSet(
                                        height,
                                        width,
                                        sunRise,
                                        "Sun Rise",
                                        "assets/images/sunrise.png"),
                                    sunRiseSet(height, width, sunSet, "Sun Set",
                                        "assets/images/sunset.png"),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text("Something Wrong...");
                  }

                  return Center(
                    child: CircularProgressIndicator(),
                  );
                })),
      ),
    );
  }

  Container sunRiseSet(double height, double width, String sunRise,
      String riseSet, String image) {
    return Container(
      padding: EdgeInsets.all(16),
      height: height / 3.5,
      width: width / 2,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  Text(riseSet,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color_white)),
                  Image.asset(
                    image,
                    height: 100,
                    width: 100,
                  ),
                  Text(
                    sunRise,
                    style: TextStyle(color: color_white),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Container windHumidity(
      double height, BuildContext context, WeatherModel weatherData) {
    return Container(
      padding: EdgeInsets.all(16),
      height: height / 3.5,
      width: MediaQuery.of(context).size.width,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(
                      Icons.wind_power,
                      color: color_white,
                    ),
                    Text(
                      "${weatherData.wind.speed} km/h",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: color_white),
                    ),
                    Text("wind", style: TextStyle(color: color_white))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.water_drop_outlined, color: color_white),
                    Text("${weatherData.main.humidity}°C",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color_white)),
                    Text("humidity", style: TextStyle(color: color_white))
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.visibility, color: color_white),
                    Text((weatherData.visibility * 1000).toString(),
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: color_white)),
                    Text(
                      "visibility",
                      style: TextStyle(color: color_white),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FutureBuilder<HourWeatherModel> todayForcast(
      WeatherProvider value, double height, WeatherModel weatherData) {
    return FutureBuilder(
      future: WeatherService().getHourWeather(value.latitude, value.longitude),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          HourWeatherModel hourWeatherData = snapshot.data;
          return Container(
            padding: EdgeInsets.all(16),
            height: height / 2.5,
            width: MediaQuery.of(context).size.width,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(16)),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        "Generally Clear Toady High Max Temp ${(weatherData.main.tempMax).toInt()}°C",
                        style: TextStyle(color: color_white),
                      ),
                      Divider(),
                      SizedBox(
                        height: height / 4,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 13,
                            itemBuilder: (context, index) {
                              String time = DateFormat("h.mma")
                                  .format(hourWeatherData.list[index].dtTxt);
                              return Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(time,
                                        style: TextStyle(color: color_white)),
                                    Image.network(
                                      "https://openweathermap.org/img/wn/${hourWeatherData.list[index].weather[0].icon}@2x.png",
                                      height: 50,
                                      width: 50,
                                    ),
                                    Text(
                                        "${hourWeatherData.list[index].main.temp}°C",
                                        style: TextStyle(color: color_white))
                                  ],
                                ),
                              );
                            }),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error"),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Row header(WeatherModel weatherData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text(
              textAlign: TextAlign.center,
              weatherData.name,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color_white),
            ),
            Text(
              "${(weatherData.main.temp).toInt()}°C",
              style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: color_white),
            ),
            Text(
              textAlign: TextAlign.center,
              weatherData.weather[0].main,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: color_white),
            ),
            Text(
              textAlign: TextAlign.center,
              weatherData.weather[0].description,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color_white),
            ),
          ],
        ),
        animationwidget(weatherData.weather[0].icon),
      ],
    );
  }
}
