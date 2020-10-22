import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_bloc.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:flutter/material.dart';

class EvaluationTile extends StatelessWidget {
  const EvaluationTile({
    Key key,
    @required this.evaluation,
    @required this.bloc,
  }) : super(key: key);

  final Evaluation evaluation;
  final EvaluationBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 2,
                child: Text(
                  bloc.format(
                      evaluation?.createdAt?.toDate() ?? DateTime.now()),
                )),
            Expanded(flex: 1, child: Text('')),
            Expanded(
              flex: 1,
              child: Text('التقييم'),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 1, child: Text('حفظ')),
            Expanded(flex: 2, child: Text(bloc.format2(evaluation.memorized))),
            Expanded(
              flex: 1,
              child: Text(evaluation.memorized.mark.toString()),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(flex: 1, child: Text('مراجعة')),
            Expanded(
              flex: 2,
              child: Text(bloc.format2(evaluation.rehearsed)),
            ),
            Expanded(
              flex: 1,
              child: Text(evaluation.rehearsed.mark.toString()),
            ),
          ],
        ),
      ],
    );
  }
}
