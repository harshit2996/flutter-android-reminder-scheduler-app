import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

pd(BuildContext context) {}

class DatePicker extends StatefulWidget {
  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  DateTime dt;
  TimeOfDay time;
  List alarms = [];
  Map<int, String> monthsInYear = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };
  FlutterLocalNotificationsPlugin fltrNotification =
      new FlutterLocalNotificationsPlugin();
  @override
  void initState() {
    super.initState();
    dt = DateTime.now();
    time = TimeOfDay.now();
    var androidInitialize = new AndroidInitializationSettings('app_icon');
    var iOSinitialize = new IOSInitializationSettings();
    var initilizationsSettings =
        new InitializationSettings(androidInitialize, iOSinitialize);
    fltrNotification.initialize(initilizationsSettings,
        onSelectNotification: notificationSelected);
  }

  Future _sNotification(DateTime scheduledTime, int id) async {
    var androidDetails = new AndroidNotificationDetails(
        "1", "Epap", "EpapNotificationChannel",
        importance: Importance.Max);
    var iOSDetails = new IOSNotificationDetails();
    var generalNotificationDetails =
        new NotificationDetails(androidDetails, iOSDetails);

    // await fltrNotification.show(
    //     0, "Task", "You created a Task", generalNotificationDetails,
    //     payload: "Task");
    // var scheduledTime = DateTime.now().add(Duration(seconds: 10));
    // scheduledTime.add()
    fltrNotification.schedule(
        id, "Epap", "Reminder", scheduledTime, generalNotificationDetails);
  }

  Future cancelAllNotifications() async {
    await fltrNotification.cancelAll();
    setState(() {
      alarms = [];
    });
  }

  Future cancelNotification(int id) async {
    await fltrNotification.cancel(id);
    alarms.removeAt(id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Epap'), actions: [
        IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              cancelAllNotifications();
            })
      ]),
      body: Column(children: [
        Expanded(
          child: ListView.builder(
              // padding: const EdgeInsets.all(8),
              itemCount: alarms.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  child: Column(children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              child: ListTile(
                            title: Text(
                                '${alarms[index][0].day} ${monthsInYear[alarms[index][0].month]} ${alarms[index][0].year} , ${alarms[index][1].hourOfPeriod}:${getminute(alarms[index][1])} ${getm(alarms[index][1])}'),
                          )),
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              if (alarms.isEmpty) {
                                index = null;
                              }
                              editAlarm(context, index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.cancel),
                            color: Colors.red,
                            onPressed: () {
                              cancelNotification(index);
                            },
                          )
                        ],
                      ),
                    )
                  ]),
                );
              }),
        ),
      ]),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child:
                  Text('Drawer Header', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                color: Colors.purple[900],
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickDate(context, null);
        },
        child: Icon(Icons.event),
        tooltip: 'Add',
      ),
    );
  }

  Future notificationSelected(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification : $payload"),
      ),
    );
  }

  picktime(BuildContext context, int index) async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: (index != null) ? alarms[index][1] : TimeOfDay.now(),
    );
    if (t != null) {
      int l = alarms.length;
      time = t;
      index = l;
      DateTime st =
          dt.add(Duration(hours: t.hour, minutes: t.minute, seconds: 10));
      setState(() {
        _sNotification(st, index);
        alarms.insert(l, [dt, time]);
      });
    }
  }

  pickDate(BuildContext context, int index) async {
    DateTime date = await showDatePicker(
      context: context,
      initialDate: (index != null) ? alarms[index][0] : DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2022),
    );
    if (date != null) {
      setState(() {
        dt = date;
      });
      picktime(context, index);
    }
  }

  getminute(t) {
    if (t.minute < 10)
      return "0" + t.minute.toString();
    else
      return t.minute;
  }

  getm(t) {
    if (t.period.toString() == "DayPeriod.am")
      return "am";
    else
      return "pm";
  }

  editAlarm(BuildContext context, int index) async {
    DateTime newDate = await showDatePicker(
      context: context,
      initialDate: alarms[index][0],
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
    );
    if (newDate != null) {
      TimeOfDay newtime = await showTimePicker(
        context: context,
        initialTime: alarms[index][1],
      );
      if (newtime != null) {
        List newdateTime = [newDate, newtime];

        if (newdateTime[0] != alarms[index][0] ||
            newdateTime[1] != alarms[index][1]) {
          alarms[index] = newdateTime;
          DateTime nst = dt.add(Duration(
              hours: newtime.hour, minutes: newtime.minute, seconds: 10));
          await fltrNotification.cancel(index);
          await _sNotification(nst, index);
          setState(() {});
        }
      }
    }
  }
}
