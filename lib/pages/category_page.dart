import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiken_cash_flow/database/db_helper.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  bool isExpense = true;
  final TextEditingController nameController = TextEditingController();

  final DBHelper dbHelper = DBHelper();

  Future<void> insert(String name, int type) async {
    final now = DateTime.now();
    final data = {
      'name': name,
      'type': type,
      'created_at': now.toIso8601String(),
      'updated_at': now.toIso8601String(),
      'deleted_at': null,
    };

    final id = await dbHelper.insertCategory(data);
    print('Inserted category with id: $id');
    setState(() {}); // refresh UI
  }

  Future<List<Map<String, dynamic>>> getCategories(int type) async {
    return await dbHelper.getCategories(type);
  }

  Future<void> deleteCategory(int id) async {
    await dbHelper.deleteCategory(id);
    setState(() {}); // refresh UI
  }

  //edit
  void editCategoryDialog(int id, String oldName) {
    TextEditingController editController = TextEditingController(text: oldName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Category'),
          content: TextFormField(
            controller: editController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await dbHelper.updateCategory(id, editController.text);
                Navigator.pop(context);
                setState(() {});
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void openDialog() {
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Enter Name',
                      border: OutlineInputBorder(),
                      hintText: 'Enter Name',
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      insert(nameController.text, isExpense ? 1 : 2);
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                      nameController.clear();
                    },
                    child: const Text('Save'),
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
                    openDialog();
                  },
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: getCategories(isExpense ? 1 : 2),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No categories found.'));
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
                                    ? const Icon(
                                      Icons.upload,
                                      color: Colors.red,
                                    )
                                    : const Icon(
                                      Icons.download,
                                      color: Colors.green,
                                    ),
                            title: Text(category['name']),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    deleteCategory(category['id']);
                                  }, // TODO: delete
                                  icon: const Icon(Icons.delete),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  onPressed: () {
                                    editCategoryDialog(
                                      category['id'],
                                      category['name'],
                                    );
                                  }, // TODO: edit
                                  icon: const Icon(Icons.edit),
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
        ],
      ),
    );
  }
}
