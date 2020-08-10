import 'package:al_halaqat/app/common_screens/admin_form.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:flutter/material.dart';

class GaAdminsTileWidget extends StatelessWidget {
  const GaAdminsTileWidget({
    Key key,
    @required this.admin,
    @required this.chosenAdminsState,
  }) : super(key: key);

  final Admin admin;
  final String chosenAdminsState;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(admin.name),
      subtitle: Text(admin.address),
      onTap: chosenAdminsState == 'deleted '
          ? null
          : () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => AdminForm(
                    includeCenterForm: true,
                    adminFormKey: null,
                    onSavedAdmin: null,
                    admin: null,
                    center: null,
                    isEnabled: null,
                    onSavedCenter: (value) {},
                  ),
                  fullscreenDialog: true,
                ),
              ),
    );
  }
}
