// ignore_for_file: avoid_print

import 'dart:io';

import 'package:crud_app/bloc/student_bloc.dart';
import 'package:crud_app/database/db_helper.dart';
import 'package:crud_app/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

class AddStudent extends StatelessWidget {
  static const routeName = "addStudent";
  final int? id;
  final int? index;
  AddStudent({Key? key, this.id, this.index}) : super(key: key);

  final _formKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> searchItems = [];
  bool isLoading = false;
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();

  void _refreshStudents() async {
    // try {
    //   DatabaseHelper.getStudents().then((students) {
    //     _students = students;
    //     searchItems = students;
    //     isLoading = false;
    //   });
    // } catch (err) {
    //   print("Exception caught: $err");
    // }
  }

  File? image;

  Future pickImage(ImageSource source1) async {
    try {
      final image1 = await ImagePicker().pickImage(source: source1);
      if (image1 == null) return;
      final imagePerm = await saveImagePermanently(image1.path);
      print("the image permanant is $imagePerm");

      image = imagePerm;
    } on PlatformException catch (e1) {
      print("Failed to pick image: $e1");
    }
  }

  saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = path.basename(imagePath);
    final image = File('${directory.path}/$name');
    print(image.path);
    return File(imagePath).copy(image.path);
  }

  initEditButton(int id) async {
    print("inside initEdit");
    await DatabaseHelper.getStudents().then((students) {
      print(students.toList());

      _students = students;
      print("_student is $_students");
      final existingStudent =
          _students.firstWhere((element) => element['student_id'] == id);
      print("the existing element is ");
      print(existingStudent.toString());
      _nameCtrl.text = existingStudent['student_name'];
      _emailCtrl.text = existingStudent['student_email'];
      _phoneCtrl.text = existingStudent['student_phone'].toString();
      _placeCtrl.text = existingStudent['student_place'];
      image = File(existingStudent['image_path']);
    });
  }

  @override
  Widget build(BuildContext context) {
    (id != null) ? initEditButton(id!) : null;
    // print(image!.path);
    return Scaffold(
      body: ListView(children: [
        Container(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // name
                TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  controller: _nameCtrl,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(
                        RegExp('[a-zA-Z]+([a-zA-Z ]+)*'))
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter student name";
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                ),
                // email
                TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter an email address';
                    }
                    if (value.isNotEmpty) {
                      for (var item in _students) {
                        if (value == item['student_email'] && id == null) {
                          return "Email already exists! Please check your email";
                        }
                      }
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Email Address",
                  ),
                ),
                //number
                TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: "Phone number",
                  ),
                  validator: (value) {
                    if (value!.length < 10) {
                      return "Phone number should contain 10 digits";
                    }
                    if (value.isNotEmpty) {
                      for (var item in _students) {
                        if (value == item['student_phone'].toString() &&
                            id == null) {
                          return "Phone number already exists! Please check";
                        }
                      }
                    }
                    return null;
                  },
                ),
                //  place
                TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  controller: _placeCtrl,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter student's place";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: "Place",
                  ),
                ),

                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      color: Colors.purple,
                      height: 100,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          image != null
                              ? GestureDetector(
                                  onTap: () {
                                    pickImage(ImageSource.gallery);
                                  },
                                  child: Image.file(
                                    image!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    pickImage(ImageSource.gallery);
                                  },
                                  icon: const Icon(
                                    Icons.photo_library,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Gallery",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.purple,
                      height: 100,
                      width: 100,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          image != null
                              ? GestureDetector(
                                  onTap: () {
                                    pickImage(ImageSource.gallery);
                                  },
                                  child: Image.file(
                                    image!,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : IconButton(
                                  onPressed: () {
                                    pickImage(ImageSource.camera);
                                  },
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Camera",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        if (id == null) {
                          await _addStudent(context);
                          Navigator.of(context).pop();
                        }
                        if (id != null) {
                          await _updateStudent(id!, context);

                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text(id != null ? "Update" : "ADD STUDENT"))
              ],
            ),
          ),
        ),
      ]),
    );
  }

  Future<void> _updateStudent(int id, BuildContext context) async {
    await DatabaseHelper.updateStudent(
      id,
      _nameCtrl.text,
      _emailCtrl.text,
      int.parse(_phoneCtrl.text),
      _placeCtrl.text,
      image!.path,
    );
    BlocProvider.of<StudentBloc>(context).add(StudentEvent.update(
        index,
        Student(
            studentId: id,
            studentName: _nameCtrl.text,
            studentEmail: _emailCtrl.text,
            studentPhone: int.parse(_phoneCtrl.text),
            studentPlace: _placeCtrl.text,
            image_path: image!.path)));
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student updated successfully")));
    _refreshStudents();
  }

  Future<void> _addStudent(BuildContext context) async {
    int id = await DatabaseHelper.createStudent(_nameCtrl.text, _emailCtrl.text,
        int.parse(_phoneCtrl.text), _placeCtrl.text, image!.path);
    BlocProvider.of<StudentBloc>(context).add(StudentEvent.add(Student(
        studentId: id,
        studentName: _nameCtrl.text,
        studentEmail: _emailCtrl.text,
        studentPhone: int.parse(_phoneCtrl.text),
        studentPlace: _placeCtrl.text,
        image_path: image!.path)));

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Student added successfully")));
    _refreshStudents();
  }
}
