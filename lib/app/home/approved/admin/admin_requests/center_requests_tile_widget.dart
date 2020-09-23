import 'package:alhalaqat/app/home/approved/admin/admin_requests/center_request_details_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_requests/center_requests_bloc.dart';
import 'package:alhalaqat/app/models/center_request.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CenterRequestTileWidget extends StatelessWidget {
  CenterRequestTileWidget({
    Key key,
    @required this.centerRequest,
    @required this.bloc,
    @required this.center,
  }) : super(key: key);

  final CenterRequest centerRequest;
  final CenterRequestsBloc bloc;
  final StudyCenter center;
  final Map<String, String> actionTranslate = {
    'join-existing': 'يريد الإنضمام إلى المركز ',
    'join-existing-new': 'يريد الإنضمام إلى المركز ',
    'create-halaqa': 'يريد إنشاء حلقة جديدة',
  };

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(),
      subtitle: _buildSubtitle(),
      enabled: centerRequest.state == 'pending' ||
              centerRequest.state == 'disapproved'
          ? true
          : false,
      onTap: () => Navigator.of(context, rootNavigator: false).push(
        MaterialPageRoute(
          builder: (context) => CenterRequestDetailsScreen(
            centerRequest: centerRequest,
            bloc: bloc,
            center: center,
          ),
          fullscreenDialog: true,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    String role = '';
    if (centerRequest.user is Teacher) {
      role = 'المعلم';
    } else if (centerRequest.user is Student) {
      role = 'الطالب';
    }
    return Text(
      role +
          ' ${centerRequest.user.name} ' +
          actionTranslate[centerRequest.action],
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(_format(centerRequest.createdAt)),
      ],
    );
  }

  String _format(var t) {
    DateTime d = t.toDate();
    d = d.toLocal();
    return '${d.day}-${d.month}-${d.year}  ${d.hour}:${d.minute}';
  }
}
