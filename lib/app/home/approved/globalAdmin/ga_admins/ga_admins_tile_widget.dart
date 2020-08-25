import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_new_admin_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:flutter/material.dart';

class GaAdminsTileWidget extends StatelessWidget {
  GaAdminsTileWidget({
    Key key,
    @required this.admin,
    @required this.chosenAdminsState,
    @required this.bloc,
  }) : super(key: key);

  final Admin admin;
  final String chosenAdminsState;
  final GaAdminsBloc bloc;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(admin.name),
      subtitle: Text(admin.address),
      onTap: chosenAdminsState == 'deleted '
          ? null
          : () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => GaNewAdminScreen(
                    admin: admin,
                    bloc: bloc,
                  ),
                  fullscreenDialog: true,
                ),
              ),
    );
  }
}
