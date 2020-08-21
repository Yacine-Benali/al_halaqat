import 'package:al_halaqat/app/home/approved/common_screens/user_instances/attendance/attendance_bloc.dart';
import 'package:al_halaqat/app/home/approved/common_screens/user_instances/attendance/attendance_provider.dart';
import 'package:al_halaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_screen.dart';
import 'package:al_halaqat/app/models/admin.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/quran.dart';
import 'package:al_halaqat/app/models/student_attendance.dart';
import 'package:al_halaqat/app/models/teacher_summery.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/common_widgets/size_config.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final AttendanceBloc bloc;
  static Widget create({
    @required BuildContext context,
    @required Instance instance,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    AttendanceProvider provider = AttendanceProvider(database: database);
    AttendanceBloc bloc = AttendanceBloc(
      provider: provider,
      instance: instance,
      user: user,
    );

    return AttendanceScreen._(
      bloc: bloc,
    );
  }

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  AttendanceBloc get bloc => widget.bloc;
//
  Future<Instance> instanceFuture;
  Future<Quran> quranFuture;
  Instance instance;
  Quran quran;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> attendanceState;

  ProgressDialog pr;
  //

  @override
  void initState() {
    // instancesStream = bloc.instancesStream;
    // isLoadingNextInstances = false;
    // bloc.fetchFirstInstances();
    instanceFuture = bloc.fetchInstance();
    quranFuture = bloc.fetchQuran();
    attendanceState = KeyTranslate.attendanceState.keys.toList();

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

  void action() async {
    try {
      await pr.show();
      await bloc.saveInstance(instance);
      await pr.hide();

      PlatformAlertDialog(
        title: 'نجح الحفظ',
        content: 'تم حفظ البيانات',
        defaultActionText: 'حسنا',
      ).show(context);
    } on PlatformException catch (e) {
      await pr.hide();
      PlatformExceptionAlertDialog(
        title: 'فشلت العملية',
        exception: e,
      ).show(context);
    }
  }

  Future<void> _studentNoteWidget(StudentAttendance studentAttendance) async {
    String newNote = studentAttendance.note;
    bool isConfirm = await showDialog<bool>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                maxLength: 100,
                initialValue: studentAttendance.note,
                onChanged: (value) => newNote = value,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'ملاحظة',
                  hintText: 'ملاحظة',
                  counter: Text(''),
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('إلغاء'),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
          ),
          FlatButton(
            child: const Text('حفظ'),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
          ),
        ],
      ),
    );
    if (isConfirm == true && newNote != studentAttendance.note.toString()) {
      studentAttendance.note = newNote;
    }
  }

  Future<void> _teacherNoteWidget(TeacherSummery teacherSummery) async {
    String newNote = teacherSummery.note;
    bool isConfirm = await showDialog<bool>(
      context: context,
      child: AlertDialog(
        contentPadding: const EdgeInsets.all(16.0),
        content: Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                maxLength: 100,
                initialValue: teacherSummery.note,
                onChanged: (value) => newNote = value,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'ملاحظة',
                  hintText: 'ملاحظة',
                  counter: Text(''),
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          FlatButton(
            child: const Text('إلغاء'),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(false),
          ),
          FlatButton(
            child: const Text('حفظ'),
            onPressed: () =>
                Navigator.of(context, rootNavigator: true).pop(true),
          ),
        ],
      ),
    );
    if (isConfirm == true && newNote != teacherSummery.note.toString()) {
      teacherSummery.note = newNote;
    }
  }

  TableRow buildColumnBlock() {
    List<String> columnTitleList = bloc.getColumnTitle();
    List<TableCell> cells = [];

    for (String columnTitle in columnTitleList) {
      TableCell cell = TableCell(
        child: Container(
          padding: EdgeInsets.all(8),
          child: Align(
            alignment: Alignment.centerLeft,
            child: AutoSizeText(
              '$columnTitle',
              wrapWords: false,
            ),
          ),
        ),
      );
      cells.add(cell);
    }
    return TableRow(children: cells);
  }

  List<TableRow> buildRowList() {
    List<TableRow> tableRowList = List();

    if (bloc.user is Admin) {
      tableRowList.add(TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                instance.teacherSummery.name,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: (value) {
                instance.teacherSummery.state = attendanceState[0];
                setState(() {});
              },
              value: instance.teacherSummery.state == attendanceState[0],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: (value) {
                instance.teacherSummery.state = attendanceState[1];
                setState(() {});
              },
              value: instance.teacherSummery.state == attendanceState[1],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: (value) {
                instance.teacherSummery.state = attendanceState[2];
                setState(() {});
              },
              value: instance.teacherSummery.state == attendanceState[2],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: (value) {
                instance.teacherSummery.state = attendanceState[3];
                setState(() {});
              },
              value: instance.teacherSummery.state == attendanceState[3],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: RaisedButton(
              child: Text(''),
              onPressed: () => _teacherNoteWidget(instance.teacherSummery),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
          ),
        ],
      ));
    }
    for (StudentAttendance studentAttendance
        in instance.studentAttendanceList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: Text(
              studentAttendance.name,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {
              studentAttendance.state = attendanceState[0];
              setState(() {});
            },
            value: studentAttendance.state == attendanceState[0],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {
              studentAttendance.state = attendanceState[1];
              setState(() {});
            },
            value: studentAttendance.state == attendanceState[1],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {
              studentAttendance.state = attendanceState[2];
              setState(() {});
            },
            value: studentAttendance.state == attendanceState[2],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: (value) {
              studentAttendance.state = attendanceState[3];
              setState(() {});
            },
            value: studentAttendance.state == attendanceState[3],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: RaisedButton(
            child: Text(''),
            onPressed: () => _studentNoteWidget(studentAttendance),
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: RaisedButton(
            child: Text(''),
            onPressed: () => Navigator.of(context, rootNavigator: false).push(
              MaterialPageRoute(
                builder: (context) => EvaluationScreen.create(
                  context: context,
                  instance: instance,
                  studentId: studentAttendance.id,
                  quran: quran,
                  studentName: studentAttendance.name,
                ),
                fullscreenDialog: true,
              ),
            ),
          ),
        ),
      ]);

      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Center(child: Text('تسجيل الحضور')), actions: [
          Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: InkWell(
                onTap: action,
                child: Icon(
                  Icons.save,
                  size: 26.0,
                ),
              )),
        ]),
        body: FutureBuilder(
          future: Future.wait([instanceFuture, quranFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshots) {
            if (snapshots.hasData) {
              instance = snapshots.data[0];
              quran = snapshots.data[1];

              return SingleChildScrollView(
                child: Card(
                  margin: EdgeInsets.all(4.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: SizeConfig.screenWidth,
                      maxWidth: SizeConfig.screenWidth,
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidate: true,
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder(
                          horizontalInside:
                              BorderSide(width: 1.0, color: Colors.grey[350]),
                          bottom:
                              BorderSide(width: 1.0, color: Colors.grey[350]),
                        ),
                        children: [
                              buildColumnBlock(),
                            ] +
                            buildRowList(),
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshots.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
