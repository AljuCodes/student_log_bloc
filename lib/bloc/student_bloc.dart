import 'package:bloc/bloc.dart';
import 'package:crud_app/database/db_helper.dart';
import 'package:crud_app/models/student.dart';
import 'package:meta/meta.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, List<Student>> {
  StudentBloc() : super(<Student>[]) {
    on<StudentEvent>((event, emit) {
      if (event.eventType == EventType.add) {
        print("add is working");
        List<Student> newList = List.from(state);
        if (event.student != null) {
          newList.add(event.student);
          emit(newList);
        }
      }
      if (event.eventType == EventType.delete) {
        print("222 delete is working");
        List<Student> newList1 = List.from(state);
        newList1.removeAt(event.studentIndex);
        emit(newList1);
      }
      if (event.eventType == EventType.update) {
        print("222 update is working");
        List<Student> newList2 = List.from(state);
        newList2[event.studentIndex] = event.student;
        emit(newList2);
      }
      if (event.eventType == EventType.search) {
        print("222 search is working");
        List<Student> newList3 = DatabaseHelper.returnStudent();

        List<Student> newList4 = newList3
            .where((student) =>
                student.studentName.contains(event.student.studentName))
            .toList();
        emit(newList4);
      }
      if (event.eventType == EventType.clear) {
        emit([]);
      }
    });
  }
}
