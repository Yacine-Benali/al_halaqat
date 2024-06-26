import 'package:alhalaqat/app/home/approved/globalAdmin/ga_requests/ga_request_details_screen.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_bloc.dart';
import 'package:alhalaqat/app/models/global_admin_request.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GaRequestTileWidget extends StatelessWidget {
  GaRequestTileWidget({
    Key key,
    @required this.gaRequest,
    @required this.bloc,
  }) : super(key: key);

  final GlobalAdminRequest gaRequest;
  final GaRequestsBloc bloc;

  final Map<String, String> actionTranslate = {
    'join-existing': ':يريد الإنضمام إلى مركز ',
    'join-new': 'يريد الإنضمام و إنشاء مركز جديد',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(),
      subtitle: _buildSubtitle(),
      enabled: gaRequest.state == 'pending' || gaRequest.state == 'disapproved'
          ? true
          : false,
      onTap: () => Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => GaRequestDetailsScreen(
            gaRequest: gaRequest,
            bloc: bloc,
          ),
          fullscreenDialog: true,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    String t =
        ((gaRequest.action == 'join-new') ? "انضمام مشرف" : "إنشاء مركز");
    print(t);
    return Text(
      t ??
          '' +
              ': ' +
              '${gaRequest.admin.name} ' +
              actionTranslate[gaRequest.action] +
              ' ' +
              gaRequest.center.name,
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('دولة ' +
            KeyTranslate.isoCountryToArabic[gaRequest.admin.nationality]),
        Text(_format(gaRequest.createdAt)),
      ],
    );
  }

  String _format(var t) {
    DateTime d = t.toDate();
    d = d.toLocal();
    return '${d.day}-${d.month}-${d.year}  ${d.hour}:${d.minute}';
  }
}
