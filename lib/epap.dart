import 'package:flutter/material.dart';
import 'package:epap/datepicker.dart';

class Epap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: Colors.purple[900],
          primaryColor: Colors.purple[900],
        ),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Epap'),
          ),
          body: Center(
            child: DatePicker(),
          ),
          drawer: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  child: Text('Drawer Header',
                      style: TextStyle(color: Colors.white)),
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
        ));
  }
}
