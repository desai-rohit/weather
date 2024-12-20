import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:weather/service/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  WeatherProvider() {
    getLocation();
  }

  Location location = Location();
  bool permissiondeniedForever = false;

  String latitude = "16.690051";
  String longitude = "74.215642";

  WeatherService? weatherService;


  Future getLocation() async {
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled) {
      permissiondeniedForever = false;
      notifyListeners();
      serviceEnabled = await location.requestService();
      
      
    }
    

    permissionGranted = await location.hasPermission();

    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted != PermissionStatus.granted) {
      permissionGranted = await location.requestPermission();
    }
    if (permissionGranted == PermissionStatus.deniedForever) {
      permissiondeniedForever = true;
      notifyListeners();
    }
    if (permissionGranted == PermissionStatus.granted) {
      permissiondeniedForever = false;

      locationData = await location.getLocation();
      latitude = locationData.latitude.toString();
      longitude = locationData.longitude.toString();
      notifyListeners();
    }
  }
}
