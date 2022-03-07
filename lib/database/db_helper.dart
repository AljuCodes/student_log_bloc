// ignore_for_file: avoid_print

import 'package:crud_app/bloc/student_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';

import '../models/student.dart';

List<Student> students = [];

class DatabaseHelper {
  static Future<Database> db() async {
    return openDatabase('students.db', version: 1,
        onCreate: (Database database, int version) async {
      await database.execute('''
      CREATE TABLE students(
      student_id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
      student_name TEXT NOT NULL,
      student_email VARCHAR UNIQUE NOT NULL,
      student_phone INTEGER UNIQUE NOT NULL,
      student_place TEXT NOT NULL,
      image_path TEXT NOT NULL
      )
        ''');
    });
  }

  static Future<int> createStudent(String name, String email, int phone,
      String place, String image_path) async {
    final db = await DatabaseHelper.db();
    final data = {
      'student_name': name,
      'student_email': email,
      'student_phone': phone,
      'student_place': place,
      'image_path': image_path,
    };
    final id = await db.insert(
      'students',
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print(data['image_path']);
    return id;
  }

  static getInitialStudent(context) async {
    BlocProvider.of<StudentBloc>(context).add(StudentEvent.clear());
    await getStudents().then((students) {
      for (var student in students) {
        BlocProvider.of<StudentBloc>(context)
            .add(StudentEvent.add(Student.fromMap(student)));
      }
    });
  }

  static Future<List<Map<String, dynamic>>> getStudent(String name) async {
    final db = await DatabaseHelper.db();
    return db.query('students', where: "student_name = ?", whereArgs: [name]);
  }

  static Future<List<Map<String, dynamic>>> getStudents() async {
    final db = await DatabaseHelper.db();
    final value = await db.query('students', orderBy: 'student_id');
    students = [];
    for (var student in value) {
      students.add(Student.fromMap(student));
    }
    return value;
  }

  static Future<int> updateStudent(int id, String name, String email, int phone,
      String place, String image_path) async {
    final db = await DatabaseHelper.db();
    final data = {
      'student_name': name,
      'student_email': email,
      'student_phone': phone,
      'student_place': place,
      'image_path': image_path,
    };
    final result = await db
        .update("students", data, where: "student_id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteStudent(int id) async {
    final db = await DatabaseHelper.db();
    try {
      await db.delete('students', where: "student_id = ?", whereArgs: [id]);
    } catch (exception) {
      // ignore: avoid_print
      print(exception);
    }
  }
  static returnStudent(){
    
    return students;
  }
}
