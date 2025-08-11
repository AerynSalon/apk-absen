import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/employee.dart';
import '../models/attendance.dart';

class DBService {
  static final DBService _instance = DBService._();
  DBService._();
  factory DBService() => _instance;

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _init();
    return _db!;
  }

  Future<Database> _init() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'aeryn_salon_absen.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE employees(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            code TEXT UNIQUE,
            name TEXT,
            role TEXT
          );
        ''');
        await db.execute('''
          CREATE TABLE attendance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            employeeCode TEXT,
            checkTime TEXT,
            type TEXT
          );
        ''');
      },
    );
  }

  // Employees
  Future<List<Employee>> getEmployees() async {
    final db = await database;
    final res = await db.query('employees', orderBy: 'name ASC');
    return res.map((e) => Employee.fromMap(e)).toList();
  }

  Future<int> addEmployee(Employee e) async {
    final db = await database;
    return db.insert('employees', e.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteEmployee(int id) async {
    final db = await database;
    return db.delete('employees', where: 'id=?', whereArgs: [id]);
  }

  // Attendance
  Future<int> addAttendance(Attendance a) async {
    final db = await database;
    return db.insert('attendance', a.toMap());
  }

  Future<List<Attendance>> getAttendanceByDate(DateTime date) async {
    final db = await database;
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(Duration(days: 1));
    final res = await db.query('attendance',
      where: 'checkTime >= ? AND checkTime < ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'checkTime DESC'
    );
    return res.map((e) => Attendance.fromMap(e)).toList();
  }

  Future<List<Attendance>> getAttendanceByEmployee(String code) async {
    final db = await database;
    final res = await db.query('attendance',
      where: 'employeeCode = ?',
      whereArgs: [code],
      orderBy: 'checkTime DESC'
    );
    return res.map((e) => Attendance.fromMap(e)).toList();
  }
}
