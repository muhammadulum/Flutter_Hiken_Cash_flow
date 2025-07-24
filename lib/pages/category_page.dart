import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _nameState();
}

class _nameState extends State<CategoryPage> {
  bool isExpense = true;

  void OpenDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Text(
                    (isExpense) ? 'Add Expense' : 'Add Income',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: (isExpense) ? Colors.red : Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(),
                      hintText: 'Enter Name',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(onPressed: () {}, child: Text('Save')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Switch(
                  value: isExpense,
                  onChanged: (bool value) {
                    setState(() {
                      isExpense = value;
                    });
                  },
                  inactiveTrackColor: Colors.green[200],
                  inactiveThumbColor: Colors.green,
                  activeColor: Colors.red,
                ),
                IconButton(
                  onPressed: () {
                    OpenDialog();
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              elevation: 10,
              child: ListTile(
                leading:
                    (isExpense)
                        ? Icon(Icons.upload, color: Colors.red)
                        : Icon(Icons.download, color: Colors.green),
                title: Text('Category 1'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                    SizedBox(width: 10),
                    IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
