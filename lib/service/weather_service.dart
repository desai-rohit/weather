
import 'dart:convert';

import 'package:weather/model/hour_Weather_model.dart';
import 'package:weather/model/weather_model.dart';
import 'package:http/http.dart' as http;


class WeatherService {
  



  Future<WeatherModel> getWeather(lat,lon) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&units=metric&appid=b089354793bcf9126c5c11c3e24e1734"));

    if (response.statusCode == 200) {
     
      var data =  WeatherModel.fromMap(jsonDecode(response.body.toString())as Map<String,dynamic> );
      return data;

    } else {
      throw Exception('Failed To Featch Data');
    }
  }


    Future<HourWeatherModel> getHourWeather(lat,lon) async {
    final response = await http.get(Uri.parse(
        "https://api.openweathermap.org/data/2.5/forecast?lat=$lat&lon=$lon&units=metric&appid=b089354793bcf9126c5c11c3e24e1734"));

    if (response.statusCode == 200) {
     
      var data =  HourWeatherModel.fromMap(jsonDecode(response.body.toString())as Map<String,dynamic> );
      return data;

    } else {
      throw Exception('Failed To Featch Data');
    }
  }

}