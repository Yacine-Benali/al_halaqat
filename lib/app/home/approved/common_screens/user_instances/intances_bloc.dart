import 'package:al_halaqat/app/home/approved/common_screens/user_instances/intances_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
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
      bool isInstanceExist = false;
      //! can this be optimized ?
      if (latestInstanceList.isNotEmpty) {
        if (instancesList.isNotEmpty) {
          for (Instance existingInstance in instancesList) {
            if (existingInstance.id == latestInstanceList.elementAt(0).id)
              isInstanceExist = true;
          }
          if (!isInstanceExist) {
            instancesList.insert(0, latestInstanceList.elementAt(0));
          }
        } else {
          instancesList.insertAll(0, latestInstanceList);
        }
        if (!instancessListController.isClosed) {
          //print('first fetch');
          instancessListController.sink.add(instancesList);
        }
      } else {
        instancessListController.sink.add(emptyList);
      }
    });
  }

  Future<bool> fetchNextMessages(Instance latestIntance) async {
    List<Instance> moreIntances = await provider.fetchMoreInstances(
      halaqa.id,
      latestIntance,
    );
    instancesList.addAll(moreIntances);
    if (!instancessListController.isClosed) {
      instancessListController.sink.add(instancesList);
    }
    return true;
  }

  Future<void> setInstance(Instance instance) async {
    if (instance.id == null) instance.id = provider.getUniqueId();

    await provider.setInstance(instance);
  }

  void dispose() {
    // print('bloc stream diposed called');
    instancessListController.close();
  }
}
