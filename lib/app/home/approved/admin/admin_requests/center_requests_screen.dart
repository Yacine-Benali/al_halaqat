import 'package:alhalaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_requests/center_requests_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_requests/center_requests_provider.dart';
import 'package:alhalaqat/app/models/center_request.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/constants/key_translate.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'center_requests_tile_widget.dart';

class CenterRequestsScreen extends StatefulWidget {
  const CenterRequestsScreen._({
    Key key,
    @required this.bloc,
    @required this.centers,
  }) : super(key: key);

  final CenterRequestsBloc bloc;
  final List<StudyCenter> centers;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centers,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    CenterRequestsProvider provider =
        CenterRequestsProvider(database: database);
    User user = Provider.of<User>(context, listen: false);
    ConversationHelpeBloc conversationHelper =
        Provider.of<ConversationHelpeBloc>(context, listen: false);

    CenterRequestsBloc bloc = CenterRequestsBloc(
      provider: provider,
      admin: user,
      conversationHelper: conversationHelper,
    );

    return CenterRequestsScreen._(
      bloc: bloc,
      centers: centers,
    );
  }

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<CenterRequestsScreen> {
  CenterRequestsBloc get bloc => widget.bloc;

  final ScrollController listScrollController = ScrollController();
  Stream<List<CenterRequest>> centerRequestsStream;

  List<CenterRequest> centerRequests;
  bool isLoadingMoreRequests;
  bool isLoading = false;
  //
  List<String> requestsStateList = KeyTranslate.requestsStateList.keys.toList();
  String chosenRequestsState;
  StudyCenter chosenCenter;

  @override
  void initState() {
    chosenRequestsState = requestsStateList[0];
    chosenCenter = widget.centers[0];

    centerRequestsStream = bloc.centerRequestsStream;
    isLoadingMoreRequests = false;
    bloc.fetchecenterRequests(chosenRequestsState, chosenCenter);

    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (centerRequests.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          bloc.fetchMorecenterRequests().then((value) {
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoading ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الدعوات'),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<StudyCenter>(
                dropdownColor: Colors.indigo,
                value: chosenCenter,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (StudyCenter newValue) {
                  setState(() {
                    chosenCenter = newValue;
                    bloc.fetchecenterRequests(
                        chosenRequestsState, chosenCenter);
                  });
                },
                items: widget.centers
                    .map<DropdownMenuItem<StudyCenter>>((StudyCenter value) {
                  return DropdownMenuItem<StudyCenter>(
                    value: value,
                    child: Text(value.name),
                  );
                }).toList(),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Center(
              child: DropdownButton<String>(
                dropdownColor: Colors.indigo,
                value: chosenRequestsState,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                underline: Container(),
                elevation: 0,
                style: TextStyle(color: Colors.white, fontSize: 20),
                onChanged: (String newValue) {
                  setState(() {
                    chosenRequestsState = newValue;
                    bloc.fetchecenterRequests(
                        chosenRequestsState, chosenCenter);
                  });
                },
                items: requestsStateList
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(KeyTranslate.requestsStateList[value]),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<CenterRequest>>(
        stream: centerRequestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            centerRequests = snapshot.data;
            if (centerRequests.isNotEmpty) {
              return _buildList();
            } else {
              return EmptyContent(
                title: 'لا توجد أي طلبات',
                message: 'الطلبات ستظهر هنا',
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

  Widget _buildList() {
    return ListView.separated(
      controller: listScrollController,
      itemCount: centerRequests.length + 1,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == centerRequests.length) {
          return _buildProgressIndicator();
        }

        return CenterRequestTileWidget(
          centerRequest: centerRequests[index],
          bloc: bloc,
          center: chosenCenter,
        );
      },
    );
  }
}
