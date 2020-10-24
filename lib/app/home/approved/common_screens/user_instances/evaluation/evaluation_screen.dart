import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_provider.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_tile.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/new_evaluation_screen.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen._({Key key, @required this.bloc}) : super(key: key);

  final EvaluationBloc bloc;
  static Widget create({
    @required BuildContext context,
    @required Instance instance,
    @required String studentId,
    @required String studentName,
    @required Quran quran,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    EvaluationProvider provider = EvaluationProvider(database: database);
    EvaluationBloc bloc = EvaluationBloc(
      instance: instance,
      provider: provider,
      user: user,
      studentId: studentId,
      quran: quran,
      studentName: studentName,
    );

    return EvaluationScreen._(
      bloc: bloc,
    );
  }

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<EvaluationScreen> {
  EvaluationBloc get bloc => widget.bloc;
  //
  ProgressDialog pr;
  Stream<List<Evaluation>> evaluationsListFuture;
  List<Evaluation> evaluationsList;
  Future<Quran> quranFuture;

  @override
  void initState() {
    evaluationsListFuture = bloc.fetchEvaluations();

    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
    );
    pr.style(
      message: 'جاري الرفع',
      messageTextStyle: TextStyle(fontSize: 14),
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('تقييم'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Evaluation>>(
          stream: evaluationsListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              evaluationsList = snapshot.data;
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => NewEvaluationScreen(
                        bloc: bloc,
                        evaluationsList: evaluationsList,
                      ),
                      fullscreenDialog: true,
                    ),
                  ),
                  tooltip: 'add',
                  child: Icon(Icons.add),
                ),
                body: Card(
                  margin: EdgeInsets.all(4.0),
                  child: ListView.builder(
                    itemCount: evaluationsList.length,
                    itemBuilder: (_, int index) => Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: EvaluationTile(
                            evaluation: evaluationsList[index],
                            bloc: bloc,
                          ),
                        ),
                        Divider(height: 1),
                        if (index == evaluationsList.length - 1) ...[
                          SizedBox(height: 75),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
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
