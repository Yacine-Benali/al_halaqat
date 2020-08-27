import 'package:al_halaqat/app/home/approved/student/student_summery/student_report_card_summery_screen.dart';
import 'package:al_halaqat/app/home/approved/student/student_summery/student_summery_bloc.dart';
import 'package:al_halaqat/app/home/approved/student/student_summery/student_summery_provider.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentSummeryScreen extends StatefulWidget {
  const StudentSummeryScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final StudentSummeryBloc bloc;

  static Widget create({
    @required BuildContext context,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    StudentSummeryProvider provider =
        StudentSummeryProvider(database: database);
    StudentSummeryBloc bloc = StudentSummeryBloc(
      provider: provider,
      student: user,
    );

    return StudentSummeryScreen._(
      bloc: bloc,
    );
  }

  @override
  _StudentSummeryScreenState createState() => _StudentSummeryScreenState();
}

class _StudentSummeryScreenState extends State<StudentSummeryScreen> {
  StudentSummeryBloc get bloc => widget.bloc;
  Future<ReportCard> reportCardFuture;
  @override
  void initState() {
    reportCardFuture = bloc.getReportCard();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('المراكز')),
        centerTitle: true,
      ),
      body: FutureBuilder<ReportCard>(
        future: reportCardFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.summery.isNotEmpty) {
              return StudentReportCardSummeryScreen(
                reportCard: snapshot.data,
              );
            } else {
              return EmptyContent(
                title: 'empty',
                message: 'empty',
              );
            }
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
