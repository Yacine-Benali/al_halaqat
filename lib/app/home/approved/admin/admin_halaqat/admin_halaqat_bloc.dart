import 'package:al_halaqat/app/home/approved/admin/admin_halaqat/admin_halaqat_provider.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/services/auth.dart';
import 'package:flutter/material.dart';

class AdminHalaqaBloc {
  AdminHalaqaBloc({
    @required this.provider,
    @required this.admin,
    @required this.auth,
  });

  final AdminHalaqatProvider provider;
  final Admin admin;
  final Auth auth;

  Stream<List<Halaqa>> fetchHalaqat(StudyCenter center) =>
      provider.fetchHalaqat(center.id);

  Future<void> createHalaqa(
    Halaqa halaqa,
    StudyCenter chosenCenter,
  ) async {
    if (halaqa.id == null) {
      halaqa.id = provider.getUniqueId();
      halaqa.createdBy = {
        'name': admin.name,
        'id': admin.id,
      };
      halaqa.centerId = chosenCenter.id;
      halaqa.state = 'approved';
    }

    await provider.createHalaqa(halaqa);
  }

  List<Halaqa> getFilteredHalaqatList(
    List<Halaqa> data,
    String chosenHalaqaState,
  ) {
    List<Halaqa> filteredHalaqatList = List();

    for (Halaqa halaqa in data) {
      if (halaqa.state == chosenHalaqaState) {
        filteredHalaqatList.add(halaqa);
      }
    }
    return filteredHalaqatList;
  }

  Future<void> executeAction(
    Halaqa halaqa,
    String action,
  ) async {
    switch (action) {
      case 'reApprove':
        halaqa.state = 'approved';
        break;
      case 'archive':
        halaqa.state = 'archived';
        break;
      case 'delete':
        halaqa.state = 'deleted';
        break;
    }
    await provider.createHalaqa(halaqa);
  }
}
