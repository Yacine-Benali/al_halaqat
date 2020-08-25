import 'package:al_halaqat/app/home/approved/common_screens/user_instances/intances_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/student_attendance.dart';
import 'package:al_halaqat/app/models/students_attendance_summery.dart';
import 'package:al_halaqat/app/models/teacher_summery.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class InstancesBloc {
  InstancesBloc({
    @required this.provider,
    @required this.halaqa,
    @required this.user,
  });

  final InstancesProvider provider;
  final Halaqa halaqa;
  final User user;

  List<Instance> instancesList = [];
  List<Instance> emptyList = [];
  BehaviorSubject<List<Instance>> instancessListController =
      BehaviorSubject<List<Instance>>();

  Stream<List<Instance>> get instancesStream => instancessListController.stream;

  void fetchFirstInstances() {
    Stream<List<Instance>> latestInstancesStream =
        provider.fetchIlatestInstances(halaqa.id);

    latestInstancesStream.listen((latestInstanceList) async {
      //! can this be optimized ?
      if (latestInstanceList.isNotEmpty) {
        if (instancesList.isNotEmpty) {
          for (Instance newInstance in latestInstanceList) {
            bool isFound = false;
            for (Instance existingInstance in instancesList) {
              if (existingInstance.id == newInstance.id) {
                isFound = true;
                existingInstance.studentAttendanceSummery =
                    newInstance.studentAttendanceSummery;
              }
            }
            if (!isFound) {
              instancesList.insert(0, newInstance);
            }
          }
        } else {
          instancesList.insertAll(0, latestInstanceList);
        }
        if (!instancessListController.isClosed) {
          instancessListController.sink.add(instancesList);
        }
      } else {
        instancesList.clear();
        instancessListController.sink.add(instancesList);
      }
    });
  }

  Future<bool> fetchNextMessages(Instance lastIntance) async {
    List<Instance> moreIntances = await provider.fetchMoreInstances(
      halaqa.id,
      lastIntance,
    );
    await Future.delayed(Duration(milliseconds: 500));
    instancesList.addAll(moreIntances);
    if (!instancessListController.isClosed) {
      instancessListController.sink.add(instancesList);
    }
    return true;
  }

  Future<void> setInstance(Instance instance) async {
    if (instance.id == null) {
      instance.id = provider.getUniqueId();
      instance.createdBy = {
        'name': user.name,
        'id': user.id,
      };
    }

    await provider.setInstance(instance);
  }

  Future<void> createNewInstance() async {
    Instance instance = Instance(
      id: provider.getUniqueId(),
      halaqaName: this.halaqa.name,
      halaqaId: this.halaqa.id,
      centerId: this.halaqa.centerId,
      createdAt: null,
      note: null,
      createdBy: {
        'name': user.name,
        'id': user.id,
      },
      teacherSummery:
          TeacherSummery(id: null, name: null, state: null, note: null),
      studentAttendanceSummery: StudentsAttendanceSummery(
          present: null, latee: null, absent: null, absentWithExecuse: null),
      studentAttendanceList: List<StudentAttendance>(),
      studentIdsList: List<String>(),
    );

    await provider.setInstance(instance);
  }

  Future<void> deleteInstance(Instance deletedInstance) async {
    List<Instance> temp = List();
    for (Instance existingInstance in instancesList) {
      if (existingInstance.id != deletedInstance.id) temp.add(existingInstance);
    }
    instancesList.clear();
    instancesList.addAll(temp);
    await provider.deleteInstance(deletedInstance);
    if (!instancessListController.isClosed) {
      instancessListController.sink.add(instancesList);
    }
  }

  void dispose() {
    // print('bloc stream diposed called');
    instancessListController.close();
  }
}
