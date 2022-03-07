part of 'student_bloc.dart';

enum EventType { add, delete, update, search, clear }

class StudentEvent {
  EventType eventType = EventType.add;
  int studentIndex = 0;
  Student student = Student(
      studentId: 0,
      studentName: "",
      studentEmail: "",
      studentPhone: 1234567890,
      studentPlace: "",
      image_path: "");

  StudentEvent.add(this.student) {
    this.eventType = EventType.add;
    this.student = student;
  }
  StudentEvent.delete(index) {
    this.eventType = EventType.delete;
    this.studentIndex = index;
  }
  StudentEvent.update(index, Student student) {
    this.eventType = EventType.update;
    this.studentIndex = index;
    this.student = student;
  }
  StudentEvent.search(String search) {
    this.eventType = EventType.search;
    this.student.studentName = search;
  }
  StudentEvent.clear() {
    this.eventType = EventType.clear;
  }
}
