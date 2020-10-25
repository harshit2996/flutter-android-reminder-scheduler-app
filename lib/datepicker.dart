import 'package:flutter/material.dart';

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
  @override
  void initState() {
    super.initState();
    dt = DateTime.now();
    time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          // padding: const EdgeInsets.all(8),
          itemCount: alarms.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                // height: 50,
                // margin: EdgeInsets.all(2),
                child: Column(
                    // child: Text(
                    children: <Widget>[
                  ListTile(
                    title: Text(
                        '${alarms[index][0].day} ${monthsInYear[alarms[index][0].month]} ${alarms[index][0].year} , ${alarms[index][1].hourOfPeriod}:${getminute(alarms[index][1])} ${getm(alarms[index][1])}'),
                    trailing: Icon(Icons.edit),
                    onTap: () {
                      if (alarms.isEmpty) {
                        index = null;
                      }
                      editAlarm(context, index);
                    },
                  ),
                ]));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          pickDate(context, null);
        },
        child: Icon(Icons.event),
        tooltip: 'Add',
      ),
    );
  }

  picktime(BuildContext context, int index) async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: (index != null) ? alarms[index][1] : TimeOfDay.now(),
    );
    if (t != null) {
      setState(() {
        time = t;
      });
      int l = alarms.length;
      alarms.insert(l, [dt, time]);
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
          setState(() {});
        }
      }
    }
  }
}
