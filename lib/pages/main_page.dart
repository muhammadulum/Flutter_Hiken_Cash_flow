import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:hiken_cash_flow/pages/home_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CalendarAppBar(
        backButton: false,
        locale: 'id',
        onDateChanged: (value) => print(value),
        firstDate: DateTime.now().subtract(Duration(days: 140)),
        lastDate: DateTime.now(),
      ),

      body: HomePage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action for the floating action button
        },
        backgroundColor: Colors.blueAccent,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                // Handle home button tap
              },
            ),
            SizedBox(width: 20), // Space between icons
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                // Handle home button tap
              },
            ),
          ],
        ),
      ),

      // Handle bottom navigation bar item tap
    );
  }
}
