import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/addition/addition_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';

class AdditionBloc {
  AdditionBloc({
    @required this.provider,
    @required this.conversationHelpeBloc,
    @required this.halaqa,
  });

  final AdditionProvider provider;
  final ConversationHelpeBloc conversationHelpeBloc;
  final Halaqa halaqa;

  Stream<List<Student>> fetchStudents() =>
      provider.fetchStudents(halaqa.centerId);

  Future<void> saveStudents(List<Student> studentsList) async {
    List<Future> liste = List();
    for (Student student in studentsList) {
      var f = provider.saveStudent(student);
      liste.add(f);
    }

    return Future.wait(liste);
  }

  Future<List<Student>> getStudentSearch(
      List<Student> studentsList, String search) async {
    print("Resident search = $search");
    if (search == "empty") return [];
    if (search == "error") throw Error();
    List<Student> filteredSearchList = [];

    for (Student s in studentsList) {
      if (s.name.toLowerCase().contains(search.toLowerCase()) ||
          s.readableId.toLowerCase().contains(search.toLowerCase())) {
        filteredSearchList.add(s);
      }
    }
    return filteredSearchList;
  }

  Future<void> saveChanges(
      List<Student> oldStudentsList, List<Student> newStudentsList) {
    List<Tuple2<Student, Student>> changedStudentsList = List();

    // print('${oldStudentsList.length} => ${newStudentsList.length} ');
    // oldStudentsList.forEach((e) {
    //   print('${e.name} => ${e.halaqatLearningIn}');
    // });
    // print("****");
    // newStudentsList.forEach((e) {
    //   print('${e.name} => ${e.halaqatLearningIn}');
    // });

    for (Student newStudent in newStudentsList) {
      for (Student oldStudent in oldStudentsList) {
        if (newStudent.id == oldStudent.id) {
          // print('${newStudent.name} is in the list');
          if (!listEquals(
              newStudent.halaqatLearningIn, oldStudent.halaqatLearningIn)) {
            print('${newStudent.name} changed');
            Tuple2<Student, Student> oldNewStudent =
                Tuple2(oldStudent, newStudent);

            changedStudentsList.add(oldNewStudent);
          } else {
            // print('${newStudent.name} not changed');
          }
        }
      }
    }

    List<Future> futureList = List();
    for (Tuple2<Student, Student> item in changedStudentsList) {
      Student oldStudent = item.item1;
      Student newStudent = item.item2;
      Future f1 =
          conversationHelpeBloc.onStudentModification(oldStudent, newStudent);
      Future f2 = provider.saveStudent(newStudent);

      futureList.addAll([f1, f2]);
    }
    return Future.any(futureList);
  }
}
