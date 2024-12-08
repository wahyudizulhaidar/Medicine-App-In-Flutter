import 'dart:io';

import 'package:animated_widgets/animated_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../database/repository.dart';
import '../../models/calendar_day_model.dart';
import '../../models/pill.dart';
import '../../notifications/notifications.dart';
import '../../screens/home/calendar.dart';
import '../../screens/home/medicines_list.dart';

Future<void> requestExactAlarmPermission(BuildContext context) async {
  if (Platform.isAndroid) {
    if (!await Permission.scheduleExactAlarm.isGranted) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Grant Exact Alarm Permission')),
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                openAppSettings();
              },
              child: Text('Open Settings to Grant Permission'),
            ),
          ),
        ),
      ));
    }
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  //-------------------| Flutter notifications |-------------------
  final Notifications _notifications = Notifications();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //===============================================================

  //--------------------| List of Pills from database |----------------------
  List<Pill> allListOfPills = [];
  final Repository _repository = Repository();
  List<Pill> dailyPills = [];

  //=========================================================================

  //-----------------| Calendar days |------------------

  final CalendarDayModel _days = CalendarDayModel(
    dayLetter: 'M',
    dayNumber: 1,
    isChecked: false,
    month: 12,
    year: 2024,
  );
  late List<CalendarDayModel> _daysList;

  //====================================================

  //handle last choose day index in calendar
  int _lastChooseDay = 0;

  @override
  void initState() {
    super.initState();
    initNotifies();
    setData();
    _daysList = _days.getCurrentDays();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestExactAlarmPermission(context);
    });
  }

  //init notifications
  Future initNotifies() async => flutterLocalNotificationsPlugin =
      await _notifications.initNotifies(context);

  //--------------------GET ALL DATA FROM DATABASE---------------------
  Future setData() async {
    allListOfPills.clear();
    var pillsData = await _repository.getAllData("Pills");

    if (pillsData != null) {
      pillsData.forEach((pillMap) {
        // Pastikan parameter 'id' dan yang lainnya diberikan
        allListOfPills.add(Pill(
            id: pillMap['id'],
            name: pillMap['name'],
            amount: pillMap['amount'],
            type: pillMap['type'],
            howManyWeeks: pillMap['howManyWeeks'],
            medicineForm: pillMap['medicineForm'],
            time: pillMap['time'],
            notifyId: pillMap['notifyId']));
      });
    }

    chooseDay(_daysList[_lastChooseDay]);
  }

  //===================================================================

  @override
  Widget build(BuildContext context) {
    final double deviceHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final Widget addButton = FloatingActionButton(
      elevation: 2.0,
      onPressed: () async {
        //refresh the pills from database
        await Navigator.pushNamed(context, "/add_new_medicine")
            .then((_) => setData());
      },
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 24.0,
      ),
      backgroundColor: Theme.of(context).primaryColor,
    );

    return Scaffold(
      floatingActionButton: addButton,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Color.fromRGBO(248, 248, 248, 1),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(
                top: 0.0, left: 25.0, right: 25.0, bottom: 20.0),
            child: Column(
              children: [
                SizedBox(
                  height: deviceHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: deviceHeight * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Journal",
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(color: Colors.black),
                        ),
                        ShakeAnimatedWidget(
                          enabled: true,
                          duration: Duration(milliseconds: 2000),
                          curve: Curves.linear,
                          shakeAngle: Rotation.deg(z: 30),
                          child: Icon(
                            Icons.notifications_none,
                            size: 42.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceHeight * 0.01,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Calendar(chooseDay, _daysList),
                ),
                SizedBox(height: deviceHeight * 0.03),
                dailyPills.isEmpty
                    ? SizedBox(
                        width: double.infinity,
                        height: 100,
                        child: Center(
                          child: Text(
                            'No Reminder',
                            style: TextStyle(
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      )
                    : MedicinesList(
                        dailyPills, setData, flutterLocalNotificationsPlugin)
              ],
            ),
          ),
        ),
      ),
    );
  }

  //-------------------------| Click on the calendar day |-------------------------

  void chooseDay(CalendarDayModel clickedDay) {
    setState(() {
      _lastChooseDay = _daysList.indexOf(clickedDay);
      _daysList.forEach((day) => day.isChecked = false);
      CalendarDayModel chooseDay = _daysList[_daysList.indexOf(clickedDay)];
      chooseDay.isChecked = true;
      dailyPills.clear();
      allListOfPills.forEach((pill) {
        DateTime pillDate =
            DateTime.fromMicrosecondsSinceEpoch(pill.time * 1000);
        if (chooseDay.dayNumber == pillDate.day &&
            chooseDay.month == pillDate.month &&
            chooseDay.year == pillDate.year) {
          dailyPills.add(pill);
        }
      });
      dailyPills.sort((pill1, pill2) => pill1.time.compareTo(pill2.time));
    });
  }

//===============================================================================
}
