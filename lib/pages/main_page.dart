import 'package:calendar_appbar/calendar_appbar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiken_cash_flow/pages/category_page.dart';
import 'package:hiken_cash_flow/pages/home_page.dart';
import 'package:hiken_cash_flow/pages/transaction_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _nameState();
}

class _nameState extends State<MainPage> {
  final List<Widget> _pages = [HomePage(), CategoryPage()];
  int _currentIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          (_currentIndex == 0)
              ? CalendarAppBar(
                backButton: false,
                locale: 'id',
                onDateChanged: (value) => print(value),
                firstDate: DateTime.now().subtract(Duration(days: 140)),
                lastDate: DateTime.now(),
              )
              : PreferredSize(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 36,
                    ),
                    child: Text(
                      'Categories',
                      style: GoogleFonts.montserrat(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                preferredSize: Size.fromHeight(100),
              ),

      body: _pages[_currentIndex],

      floatingActionButton: Visibility(
        visible: _currentIndex == 0 ? true : false,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context)
                .push(
                  MaterialPageRoute(builder: (context) => TransactionPage()),
                )
                .then((value) {
                  setState(() {});
                }); // Action for the floating action button
          },
          backgroundColor: Colors.blueAccent,
          child: Icon(Icons.add),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(Icons.home),
              onPressed: () {
                _onItemTapped(0);
                // Handle home button tap
              },
            ),
            SizedBox(width: 20), // Space between icons
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                _onItemTapped(1);
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
