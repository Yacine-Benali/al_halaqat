import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_new_supervisor_screen.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_supervisor_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_supervisors_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_supervisors/admin_supervisors_provider.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/supervisor.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/app/models/user_halaqa.dart';
import 'package:alhalaqat/common_packages/pk_search_bar/pk_search_bar.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/auth.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

//! TODO load supervisor lazly
class AdminSupervisorsScreen extends StatefulWidget {
  const AdminSupervisorsScreen._({
    Key key,
    @required this.bloc,
    @required this.center,
  }) : super(key: key);

  final AdminSupervisorsBloc bloc;
  final StudyCenter center;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);
    Auth auth = Provider.of<Auth>(context, listen: false);

    AdminSupervisorsProvider provider =
        AdminSupervisorsProvider(database: database);
    ConversationHelpeBloc conversationHelper =
        Provider.of<ConversationHelpeBloc>(context, listen: false);
    LogsHelperBloc logsHelperBloc =
        Provider.of<LogsHelperBloc>(context, listen: false);
    AdminSupervisorsBloc bloc = AdminSupervisorsBloc(
      auth: auth,
      admin: user,
      provider: provider,
      conversationHelper: conversationHelper,
      logsHelperBloc: logsHelperBloc,
    );

    return AdminSupervisorsScreen._(
      bloc: bloc,
      center: center,
    );
  }

  @override
  _AdminSupervisorsScreenState createState() => _AdminSupervisorsScreenState();
}

class _AdminSupervisorsScreenState extends State<AdminSupervisorsScreen> {
  AdminSupervisorsBloc get bloc => widget.bloc;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> supervisorsStateList;

  String chosenSupervisorState;
  StudyCenter chosenCenter;
  UserHalaqa<Supervisor> supervisorHalaqaList;
  Stream<UserHalaqa<Supervisor>> supervisorsListStream;
  ProgressDialog pr;

  @override
  void initState() {
    if (bloc.admin is Admin) {
      supervisorsStateList = KeyTranslate.adminTeachersState.keys.toList();
    } else {
      supervisorsStateList = KeyTranslate.gaTeachersState.keys.toList();
    }
    supervisorsListStream = bloc.fetchSupervisors([widget.center]);
    chosenCenter = widget.center;
    chosenSupervisorState = supervisorsStateList[0];
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
    );
    pr.style(
      message: 'جاري تحميل',
      messageTextStyle: TextStyle(fontSize: 14),
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  Future<void> downloadReport() async {
    try {
      final isPermissionStatusGranted = await _requestPermissions();

      if (isPermissionStatusGranted) {
        await pr.show();
        // String filePath = await bloc.getReportasCsv(
        //   supervisorHalaqaList,
        //   chosenCenter,
        //   chosenSupervisorState,
        // );
        //await pr.hide();
        //await PlatformReportDialog(filePath: filePath).show(context);
      } else {
        throw PlatformException(
          code: 'storage permission are required',
          message: 'storage permission are required',
        );
      }
    } on Exception catch (e) {
      await pr.hide();
      if (e is PlatformException)
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
    }
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted)
      permission = await Permission.storage.request();

    return permission == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Center(child: Text('')),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<String>(
                dropdownColor: Colors.indigo,
                value: chosenSupervisorState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenSupervisorState = newValue;
                  });
                },
                items: supervisorsStateList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(KeyTranslate.gaTeachersState[value]),
                  );
                }).toList(),
              ),
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.only(left: 20.0),
          //   child: IconButton(
          //     icon: Icon(Icons.cloud_download),
          //     onPressed: () =>
          //         supervisorHalaqaList == null ? null : downloadReport(),
          //   ),
          // ),
        ],
      ),
      body: StreamBuilder<UserHalaqa<Supervisor>>(
        stream: supervisorsListStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            supervisorHalaqaList = snapshot.data;

            List<Supervisor> supervisorsList = bloc.getFilteredSupervisorsList(
              snapshot.data.usersList,
              chosenCenter,
              chosenSupervisorState,
            );

            List<Halaqa> halaqatList = snapshot.data.halaqatList;
            List<Halaqa> availableHalaqat = bloc.getAvailableHalaqat(
              halaqatList,
              supervisorsList,
              chosenCenter,
            );

            return Scaffold(
              floatingActionButton: FloatingActionButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: false).push(
                  MaterialPageRoute(
                    builder: (context) => AdminNewSupervisorScreen(
                      isEnabled: true,
                      halaqatList: availableHalaqat,
                      bloc: bloc,
                      chosenCenter: chosenCenter,
                      supervisor: null,
                    ),
                    fullscreenDialog: true,
                  ),
                ),
                tooltip: 'add',
                child: Icon(Icons.add),
              ),
              body: buildBody(supervisorsList, halaqatList, availableHalaqat),
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

  Widget buildBody(
    List<Supervisor> supervisorsList,
    List<Halaqa> halaqatList,
    List<Halaqa> availableHalaqatList,
  ) {
    if (supervisorsList.isNotEmpty) {
      return _buildList(supervisorsList, halaqatList, availableHalaqatList);
    } else {
      return EmptyContent(
        title: 'لا يوجد  ',
        message: 'لا يوجد  ',
      );
    }
  }

  Widget _buildList(
    List<Supervisor> supervisorsList,
    List<Halaqa> halaqatList,
    List<Halaqa> availableHalaqatList,
  ) {
    return SearchBar<Supervisor>(
      searchBarPadding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 5),
      headerPadding: EdgeInsets.only(left: 0, right: 0),
      listPadding: EdgeInsets.only(left: 0, right: 0),
      hintText: "إبحث بالاسم  أو الرقم التعريفي",
      hintStyle: TextStyle(
        color: Colors.black54,
      ),
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.normal,
      ),
      iconActiveColor: Colors.deepPurple,
      shrinkWrap: true,
      mainAxisSpacing: 5,
      crossAxisSpacing: 5,
      suggestions: supervisorsList,
      minimumChars: 1,
      emptyWidget: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Text("لم يتم العثور على أي معلم"),
        ),
      ),
      onError: (error) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text("$error", textAlign: TextAlign.center),
          ),
        );
      },
      onSearch: (s) async => bloc.getSupervisorSearch(supervisorsList, s),
      buildSuggestion: (Supervisor supervisor, int index) {
        List<Halaqa> currentHalaqaList = List();
        currentHalaqaList.addAll(availableHalaqatList);

        Supervisor supervisor = supervisorsList[index];
        if (supervisor.halaqatSupervisingIn.isNotEmpty) {
          for (String currentHalaqaId in supervisor.halaqatSupervisingIn) {
            for (Halaqa halaqa in halaqatList) {
              if (currentHalaqaId == halaqa.id) currentHalaqaList.add(halaqa);
            }
          }
        }
        if (index == supervisorsList.length - 1) {
          return Column(
            children: [
              AdminSupervisorTileWidget(
                halaqatList: currentHalaqaList,
                supervisor: supervisor,
                chosenSupervisorState: chosenSupervisorState,
                bloc: bloc,
                scaffoldKey: _scaffoldKey,
                chosenCenter: chosenCenter,
              ),
              SizedBox(height: 75),
            ],
          );
        }
        return AdminSupervisorTileWidget(
          halaqatList: currentHalaqaList,
          supervisor: supervisor,
          chosenSupervisorState: chosenSupervisorState,
          bloc: bloc,
          scaffoldKey: _scaffoldKey,
          chosenCenter: chosenCenter,
        );
      },
      onItemFound: (Supervisor supervisor, int index) {
        List<Halaqa> currentHalaqaList = List();
        currentHalaqaList.addAll(availableHalaqatList);

        Supervisor supervisor = supervisorsList[index];
        if (supervisor.halaqatSupervisingIn.isNotEmpty) {
          for (String currentHalaqaId in supervisor.halaqatSupervisingIn) {
            for (Halaqa halaqa in halaqatList) {
              if (currentHalaqaId == halaqa.id) currentHalaqaList.add(halaqa);
            }
          }
        }
        return AdminSupervisorTileWidget(
          halaqatList: currentHalaqaList,
          supervisor: supervisor,
          chosenSupervisorState: chosenSupervisorState,
          bloc: bloc,
          scaffoldKey: _scaffoldKey,
          chosenCenter: chosenCenter,
        );
      },
    );
  }
}
