import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiken_cash_flow/models/database.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _nameState();
}

class _nameState extends State<CategoryPage> {
  bool isExpense = true;
  final AppDatabase database = AppDatabase();

  TextEditingController nameController = TextEditingController();

  Future insert(String name, int type) async {
    DateTime now = DateTime.now();

    final row = await database
        .into(database.categories)
        .insertReturning(
          CategoriesCompanion.insert(
            name: name,
            type: type,
            createdAt: now,
            updatedAt: now,
          ),
        );
    print('Inserted category with id: ${row.id}');
  }

  Future<List<Category>> getCategories(int type) async {
    return await database.getAllCategoriesRepo(type);
  }

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
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(),
                      hintText: 'Enter Name',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Call the insert function with the entered name and type
                      insert(nameController.text, isExpense ? 1 : 2);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      setState(() {
                        nameController
                            .clear(); // Clear the text field after saving
                      });
                    },
                    child: Text('Save'),
                  ),
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

          FutureBuilder<List<Category>>(
            future: getCategories(isExpense ? 1 : 2),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No categories found.'));
              } else {
                final categories = snapshot.data!;
                return Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          elevation: 10,
                          child: ListTile(
                            leading:
                                (isExpense)
                                    ? Icon(Icons.upload, color: Colors.red)
                                    : Icon(Icons.download, color: Colors.green),
                            title: Text(category.name),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete),
                                ),
                                SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 16),
          //   child: Card(
          //     elevation: 10,
          //     child: ListTile(
          //       leading:
          //           (isExpense)
          //               ? Icon(Icons.upload, color: Colors.red)
          //               : Icon(Icons.download, color: Colors.green),
          //       title: Text('Category 1'),
          //       trailing: Row(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
          //           SizedBox(width: 10),
          //           IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
