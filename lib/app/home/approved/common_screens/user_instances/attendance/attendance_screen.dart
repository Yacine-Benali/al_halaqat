import 'package:alhalaqat/app/home/approved/common_screens/user_instances/attendance/attendance_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/attendance/attendance_provider.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_screen.dart';
import 'package:alhalaqat/app/models/admin.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:alhalaqat/app/models/student_attendance.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher.dart';
import 'package:alhalaqat/app/models/teacher_summery.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen._({
    Key key,
    @required this.bloc,
    @required this.halaqatList,
    @required this.chosenCenter,
  }) : super(key: key);

  final AttendanceBloc bloc;
  final List<Halaqa> halaqatList;
  final StudyCenter chosenCenter;
  static Widget create({
    @required BuildContext context,
    @required Instance instance,
    @required List<Halaqa> halaqatList,
    @required StudyCenter chosenCenter,
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
      halaqatList: halaqatList,
      chosenCenter: chosenCenter,
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
  bool studentRoaming;
  ProgressDialog pr;
  bool canChange;
  //

  @override
  void initState() {
    if (bloc.user is Admin)
      studentRoaming = true;
    else
      studentRoaming = widget.chosenCenter.studentRoaming;
    instanceFuture = bloc.fetchInstance();
    quranFuture = bloc.fetchQuran();
    attendanceState = KeyTranslate.attendanceState.keys.toList();

    var a = DateTime.now().difference(bloc.instance.createdAt.toDate());
    print(a.inDays);
    if (a.inDays > 31) {
      canChange = false;
    } else {
      canChange = true;
    }
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
      bloc.saveInstance(instance);
      await Future.delayed(Duration(seconds: 1));
      await pr.hide();

      await PlatformAlertDialog(
        title: 'نجح الحفظ',
        content: 'تم حفظ البيانات',
        defaultActionText: 'حسنا',
      ).show(context);
      Navigator.of(context).pop();
    } catch (e) {
      await pr.hide();
      if (e is PlatformException) {
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
      } else if (e is FirebaseException)
        FirebaseExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
      else
        PlatformAlertDialog(
          title: 'فشلت العملية',
          content: 'فشلت العملية',
          defaultActionText: 'حسنا',
        ).show(context);
    }
  }

  Future<void> _studentNoteWidget(StudentAttendance studentAttendance) async {
    String newNote = studentAttendance.note;
    bool isConfirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16.0),
          content: Row(
            children: <Widget>[
              Expanded(
                child: TextFormField(
                  enabled: canChange,
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
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(false),
            ),
            TextButton(
              child: const Text('حفظ'),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop(true),
            ),
          ],
        );
      },
    );
    if (isConfirm == true && newNote != studentAttendance.note.toString()) {
      studentAttendance.note = newNote;
    }
  }

  Future<void> _teacherNoteWidget(TeacherSummery teacherSummery) async {
    String newNote = teacherSummery.note;
    bool isConfirm = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    enabled: canChange,
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
              TextButton(
                child: const Text('إلغاء'),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(false),
              ),
              TextButton(
                child: const Text('حفظ'),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(true),
              ),
            ],
          );
        });
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
          child: RotatedBox(
            quarterTurns: 3,
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                '$columnTitle',
                wrapWords: false,
              ),
            ),
          ),
        ),
      );
      cells.add(cell);
    }
    return TableRow(children: cells);
  }

  Future<void> openStudentProfile(String studentId) async {
    // TODO for some raison this is causing an error
    // Student student = bloc.getStudentFromId(studentId);
    // await Navigator.of(context, rootNavigator: false).push(
    //   MaterialPageRoute(
    //     builder: (context) => StudentProfileScreen.create(
    //       onTap: () {},
    //       context: context,
    //       halaqatList: widget.halaqatList,
    //       student: student,
    //       quran: quran,
    //       studentRoaming: studentRoaming,
    //     ),
    //     fullscreenDialog: true,
    //   ),
    // );
  }

  List<TableRow> buildRowList() {
    List<TableRow> tableRowList = List();

    if (!(bloc.user is Teacher)) {
      tableRowList.add(TableRow(
        children: [
          Container(
            alignment: Alignment.center,
            child: Text(
              instance.teacherSummery.name,
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: canChange
                  ? (value) {
                      instance.teacherSummery.state = attendanceState[0];
                      setState(() {});
                    }
                  : null,
              value: instance.teacherSummery.state == attendanceState[0],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: canChange
                  ? (value) {
                      instance.teacherSummery.state = attendanceState[1];
                      setState(() {});
                    }
                  : null,
              value: instance.teacherSummery.state == attendanceState[1],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: canChange
                  ? (value) {
                      instance.teacherSummery.state = attendanceState[2];
                      setState(() {});
                    }
                  : null,
              value: instance.teacherSummery.state == attendanceState[2],
            ),
          ),
          Container(
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: Checkbox(
              onChanged: canChange
                  ? (value) {
                      instance.teacherSummery.state = attendanceState[3];
                      setState(() {});
                    }
                  : null,
              value: instance.teacherSummery.state == attendanceState[3],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: TextButton(
              child: Icon(
                Icons.message,
                color: Colors.grey,
              ),
              onPressed: () => _teacherNoteWidget(instance.teacherSummery),
            ),
          ),
          if (!(bloc.user is Student)) ...[
            Container(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              alignment: Alignment.center,
              height: kMinInteractiveDimension,
            ),
          ],
        ],
      ));
    }
    for (StudentAttendance studentAttendance
        in instance.studentAttendanceList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(0.0),
          child: InkWell(
            onTap: () => openStudentProfile(studentAttendance.id),
            child: Container(
              alignment: Alignment.center,
              child: AutoSizeText(
                studentAttendance.name,
                maxLines: 3,
                minFontSize: 8,
                softWrap: true,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: canChange
                ? (value) {
                    studentAttendance.state = attendanceState[0];
                    setState(() {});
                  }
                : null,
            value: studentAttendance.state == attendanceState[0],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: canChange
                ? (value) {
                    studentAttendance.state = attendanceState[1];
                    setState(() {});
                  }
                : null,
            value: studentAttendance.state == attendanceState[1],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: canChange
                ? (value) {
                    studentAttendance.state = attendanceState[2];
                    setState(() {});
                  }
                : null,
            value: studentAttendance.state == attendanceState[2],
          ),
        ),
        Container(
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: Checkbox(
            onChanged: canChange
                ? (value) {
                    studentAttendance.state = attendanceState[3];
                    setState(() {});
                  }
                : null,
            value: studentAttendance.state == attendanceState[3],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.center,
          height: kMinInteractiveDimension,
          child: TextButton(
            child: Icon(
              Icons.message,
              color: Colors.grey,
            ),
            onPressed: () {
              _studentNoteWidget(studentAttendance);
            },
          ),
        ),
        if (!(bloc.user is Student)) ...[
          Container(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            alignment: Alignment.center,
            height: kMinInteractiveDimension,
            child: TextButton(
              child: Icon(
                Icons.book,
                color: Colors.grey,
              ),
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
        ]
      ]);

      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  String getTitle() {
    DateTime createdAt2 =
        bloc.instance.createdAt?.toDate()?.toLocal() ?? DateTime.now();
    String dateString = intl.DateFormat.yMMMEd('ar').format(createdAt2);
    return dateString;
  }

  void selectAll() {
    for (StudentAttendance studentAttendance
        in instance.studentAttendanceList) {
      studentAttendance.state =
          KeyTranslate.attendanceState.keys.toList().elementAt(0);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(getTitle()),
          actions: [
            if (canChange) ...[
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: InkWell(
                  onTap: selectAll,
                  child: Icon(
                    Icons.check,
                    size: 26.0,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: InkWell(
                  onTap: action,
                  child: Icon(
                    Icons.save,
                    size: 26.0,
                  ),
                ),
              ),
            ]
          ],
        ),
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
                        columnWidths: {
                          0: FlexColumnWidth(2.0),
                          // 1: FlexColumnWidth(4.0),
                          // 2: FlexColumnWidth(3.0),
                        },
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
