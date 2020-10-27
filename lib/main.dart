import 'package:flutter/material.dart';
import 'package:epap/epap.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() {
  tz.initializeTimeZones();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Epap(),
  ));
}
