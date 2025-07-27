import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:hiken_cash_flow/models/category.dart';
import 'package:hiken_cash_flow/models/transaction_data.dart';
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Transaction_data, Categories])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  Future<List<Category>> getAllCategoriesRepo(int type) async {
    return await (select(categories)
      ..where((tbl) => tbl.type.equals(type))).get();
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        // By default, `driftDatabase` from `package:drift_flutter` stores the
        // database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // Buat semua tabel
      await m.createAll();
    },
    onUpgrade: (Migrator m, int from, int to) async {
      // Tambah kolom baru jika upgrade dari versi lama
      if (from == 1) {
        await m.addColumn(categories, categories.type);
      }
    },
  );
}
