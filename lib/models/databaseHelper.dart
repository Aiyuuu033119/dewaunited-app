import 'package:dewaunited/formatting/event.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> getDB() async {
    return await openDatabase('dewaunited.db');
  }

  Future<int> addEvent(Event event) async {
    final db = await getDB();
    return await db.insert("event_tbl", event.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteEvent(data) async {
    final db = await getDB();
    return await db.delete(
      "event_tbl",
      where: 'ticketing_id = ?',
      whereArgs: [data],
    );
  }

  Future addBulkTicket(data) async {
    final db = await getDB();
    return await db.transaction((txn) async {
      Batch batch = txn.batch();
      for (var item in data) {
        batch.insert('ticket_tbl', item);
      }
      batch.commit();
    });
  }

  Future<int> deleteTicket(data) async {
    final db = await getDB();
    return await db.delete(
      "ticket_tbl",
      where: 'event_id = ?',
      whereArgs: [data],
    );
  }
}
