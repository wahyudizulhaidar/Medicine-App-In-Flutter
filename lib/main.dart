import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicine/screens/add_new_medicine/add_new_medicine.dart';
import 'package:medicine/screens/home/home.dart';
import 'package:permission_handler/permission_handler.dart';
import './screens/welcome/welcome.dart';

Future<void> requestNotificationPermission() async {
  if (Platform.isAndroid) {
    PermissionStatus permission = await Permission.notification.request();
    if (permission.isDenied || permission.isRestricted) {
      print('Notification permission denied');
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestNotificationPermission();

  runApp(MedicineApp());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black.withOpacity(0.05),
      statusBarColor: Colors.black.withOpacity(0.05),
      statusBarIconBrightness: Brightness.dark));
}

class MedicineApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          fontFamily: "Popins",
          primaryColor: Color.fromRGBO(7, 190, 200, 1),
          textTheme: TextTheme(
              displayLarge: ThemeData.light().textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 38.0,
                    fontFamily: "Popins",
                  ),
              headlineSmall: ThemeData.light().textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 17.0,
                    fontFamily: "Popins",
                  ),
              displaySmall: ThemeData.light().textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                    fontFamily: "Popins",
                  ))),
      routes: {
        "/": (context) => Welcome(),
        "/home": (context) => Home(),
        "/add_new_medicine": (context) => AddNewMedicine(),
      },
      initialRoute: "/",
    );
  }
}
