import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_admins_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_admins/ga_new_admin_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:flutter/material.dart';

class GaAdminsTileWidget extends StatefulWidget {
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
  _GaAdminsTileWidgetState createState() => _GaAdminsTileWidgetState();
}

class _GaAdminsTileWidgetState extends State<GaAdminsTileWidget> {
  Future<void> _executeAction(String action) async {
    if (action == 'edit') {
      await Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => GaNewAdminScreen(
            admin: widget.admin,
            bloc: widget.bloc,
            isEnabled: true,
          ),
          fullscreenDialog: true,
        ),
      );
    }
  }

  Widget _buildAction() {
    List<String> actions = List();
    actions.addAll(['edit']);

    return PopupMenuButton<String>(
      itemBuilder: (BuildContext context) => List.generate(
        actions.length,
        (i) {
          return PopupMenuItem<String>(
            value: actions[i],
            child:
                Text(KeyTranslate.centersActionsList[actions[i]] ?? actions[i]),
          );
        },
      ),
      onSelected: (value) => _executeAction(value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.admin.name),
      subtitle: Text(widget.admin.address),
      trailing: _buildAction(),
      onTap: widget.chosenAdminsState == 'deleted '
          ? null
          : () => Navigator.of(context, rootNavigator: false).push(
                MaterialPageRoute(
                  builder: (context) => GaNewAdminScreen(
                    admin: widget.admin,
                    bloc: widget.bloc,
                    isEnabled: false,
                  ),
                  fullscreenDialog: true,
                ),
              ),
    );
  }
}
