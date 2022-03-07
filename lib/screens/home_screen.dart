// ignore_for_file: avoid_print

import 'dart:io';

import 'package:crud_app/bloc/student_bloc.dart';
import 'package:crud_app/database/db_helper.dart';
import 'package:crud_app/models/student.dart';
import 'package:crud_app/screens/add_student.dart';
import 'package:crud_app/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatelessWidget {
  static const routePage = "homePage";

  File? image;

  final _formKey = GlobalKey<FormState>();
  String? query;
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> searchItems = [];
  bool isLoading = false;

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();
  final _searchCtrl = TextEditingController();

  Future<void> _refreshStudents() async {
    try {
      DatabaseHelper.getStudents().then((students) {
        _students = students;
        searchItems = students;
        isLoading = false;
      });
    } catch (err) {
      print("Exception caught: $err");
    }
  }

  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    isFirst ? DatabaseHelper.getInitialStudent(context) : null;
    isFirst = false;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "STUDENT LOG ",
          style: TextStyle(
              color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  // search bar
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (value) {
                        BlocProvider.of<StudentBloc>(context)
                            .add(StudentEvent.search(value));
                      },
                      decoration: const InputDecoration(
                          hintText: "Search student",
                          labelText: "Search",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          )),
                    ),
                  ),
                  // list of students
                  Expanded(child: BlocBuilder<StudentBloc, List<Student>>(
                    builder: (context, List<Student> state) {
                      if (state.isEmpty) {
                        return Center(
                          child: Text("No students found"),
                        );
                      }
                      List<Student>? filterStudent = [];
                      if (query != null && query!.isNotEmpty) {
                        for (var student in state) {
                          if (student.studentName
                              .toLowerCase()
                              .contains(query!.toLowerCase())) {
                            filterStudent.add(student);
                          }
                        }
                      } else {
                        filterStudent = state;
                      }

                      return ListView.builder(
                        itemCount: filterStudent.length,
                        itemBuilder: (context, index) {
                          // Student student =
                          //     Student.fromMap(searchItems[index]);
                          Student student = filterStudent![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailsScreen(
                                            student.image_path,
                                            student.studentName,
                                            student.studentEmail,
                                            student.studentPlace,
                                            student.studentPhone.toString(),
                                          )));
                            },
                            child: Card(
                              margin: const EdgeInsets.all(12.0),
                              child: ListTile(
                                isThreeLine: true,
                                leading: CircleAvatar(
                                    backgroundColor: Colors.amber,
                                    child: Image.file(
                                      File(student.image_path),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )),
                                title: Text(student.studentName),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(student.studentEmail),
                                    Text(student.studentPhone.toString()),
                                    Text(student.studentPlace),
                                  ],
                                ),
                                trailing: SizedBox(
                                  width: 100.0,
                                  child: Row(
                                    children: [
                                      IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () async {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        AddStudent(
                                                          id: student.studentId,
                                                          index: index,
                                                        )));
                                          }),
                                      IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            _deleteStudent(student.studentId,
                                                index, context);
                                          }),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )
                      // :
                      //  (_students.isEmpty)
                      //     ? const Center(
                      //         child: Text(
                      //             "Add students by clicking Floating button"),
                      //       )
                      //     : const Center(
                      //         child: Text("No students found!"),
                      //       ),
                      ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _nameCtrl.clear();
          _emailCtrl.clear();
          _phoneCtrl.clear();
          _placeCtrl.clear();
          Navigator.of(context).pushNamed(AddStudent.routeName);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _deleteStudent(int id, int index, BuildContext context) async {
    await DatabaseHelper.deleteStudent(id);
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Successfully deleted!"),
    ));
    BlocProvider.of<StudentBloc>(context).add(StudentEvent.delete(index));
    _refreshStudents();
  }
}
