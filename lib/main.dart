import 'package:crud_app/bloc/student_bloc.dart';
import 'package:crud_app/database/db_helper.dart';
import 'package:crud_app/screens/add_student.dart';
import 'package:crud_app/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const CRUDApp());
}

class CRUDApp extends StatelessWidget {
  const CRUDApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
       
        return StudentBloc();
      },
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "CRUD App",
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: HomePage(),
        routes: {
          AddStudent.routeName: (ctx) => AddStudent(),
          HomePage.routePage: (ctx) => HomePage(),
        },
      ),
    );
  }
}
