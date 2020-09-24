import 'package:alhalaqat/app/common_forms/admin_form.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_centers/ga_centers_bloc.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/global_admin.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GaAboutAdminScreen extends StatefulWidget {
  const GaAboutAdminScreen({
    Key key,
    @required this.bloc,
    @required this.createdById,
  }) : super(key: key);

  final GaCentersBloc bloc;
  final String createdById;

  @override
  _GaAboutAdminScreenState createState() => _GaAboutAdminScreenState();
}

class _GaAboutAdminScreenState extends State<GaAboutAdminScreen> {
  GlobalAdmin globalAdmin;
  final GlobalKey<FormState> adminFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    globalAdmin = Provider.of<User>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('حول المشرف'),
      ),
      body: globalAdmin.id == widget.createdById
          ? EmptyContent(
              title: 'أنت قمت بإنشاء هذا المركز',
              message: '',
            )
          : FutureBuilder(
              future: widget.bloc.getAdminById(widget.createdById),
              builder: (BuildContext context, AsyncSnapshot<Admin> snapshot) {
                if (snapshot.hasData) {
                  Admin admin = snapshot.data;
                  if (admin != null)
                    return AdminForm(
                      adminFormKey: adminFormKey,
                      admin: admin,
                      onSavedAdmin: (t) {},
                      onSavedCenter: (t) {},
                      center: null,
                      isEnabled: false,
                      includeCenterForm: false,
                      includeCenterIdInput: false,
                      includeUsernameAndPassword: true,
                      includeCenterState: false,
                    );
                  else
                    EmptyContent(
                      title: 'لا يوجد مشرف لهذا المركز',
                      message: '',
                    );
                } else if (snapshot.hasError) {
                  return EmptyContent(
                    title: 'Something went wrong',
                    message: 'Can\'t load items right now',
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}
