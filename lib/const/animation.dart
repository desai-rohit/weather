import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget animationwidget(data) {
  return Lottie.asset(
      data == "01d"
          ? "assets/animation/sun.json"
          : data == "02d"
              ? "assets/animation/suncloud.json"
              : data == "03d"
                  ? "assets/animation/clouds.json"
                  : data == "04d"
                      ? "assets/animation/high_clouds.json"
                      : data == "09d"
                          ? "assets/animation/raining.json"
                          : data == "10d"
                              ? "assets/animation/sun-and-rain.json.json"
                              : data == "11d"
                                  ? "assets/animation/thunderstorm.json"
                                  : data == "13d"
                                      ? "assets/animation/snow.json"
                                      : data == "50d"
                                          ? "assets/animation/shape-layers-lottie-animation.json"
                                          : data == "01n"
                                              ? "assets/animation/sun.json"
                                              : data == "02n"
                                                  ? "assets/animation/suncloud.json"
                                                  : data == "03n"
                                                      ? "assets/animation/suncloud.json"
                                                      : data == "04n"
                                                          ? "assets/animation/suncloud.json"
                                                          : data.weather[0]
                                                                      .icon ==
                                                                  "09n"
                                                              ? "assets/animation/suncloud.json"
                                                              : data.weather[0]
                                                                          .icon ==
                                                                      "10n"
                                                                  ? "assets/animation/suncloud.json"
                                                                  : data ==
                                                                          "11n"
                                                                      ? "assets/animation/suncloud.json"
                                                                      : data ==
                                                                              "12n"
                                                                          ? "assets/animation/suncloud.json"
                                                                          : data == "13n"
                                                                              ? "assets/suncloud.json"
                                                                              : data == "14n"
                                                                                  ? "assets/animation/suncloud.json"
                                                                                  : data == "50n"
                                                                                      ? "assets/animation/suncloud.json"
                                                                                      : "assets/animation/suncloud.json",
      width: 150,
      height: 150);
}
