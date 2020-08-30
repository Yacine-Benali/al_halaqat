import 'package:al_halaqat/app/conversation_helper/conversation_helper_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_requests/ga_requests_provider.dart';
import 'package:al_halaqat/app/models/global_admin_request.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'ga_requests_tile_widget.dart';

class GaRequestsScreen extends StatefulWidget {
  const GaRequestsScreen._({Key key, @required this.bloc}) : super(key: key);

  final GaRequestsBloc bloc;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    GaRequestsProvider provider = GaRequestsProvider(database: database);
    ConversationHelpeBloc conversationHelper =
        Provider.of<ConversationHelpeBloc>(context, listen: false);
    GaRequestsBloc bloc = GaRequestsBloc(
      provider: provider,
      conversationHelper: conversationHelper,
    );

    return GaRequestsScreen._(
      bloc: bloc,
    );
  }

  @override
  _RequestsScreenState createState() => _RequestsScreenState();
}

class _RequestsScreenState extends State<GaRequestsScreen> {
  GaRequestsBloc get bloc => widget.bloc;

  final ScrollController listScrollController = ScrollController();
  Stream<List<GlobalAdminRequest>> gaRequestsStream;

  List<GlobalAdminRequest> gaRequests;
  bool isLoadingMoreRequests;
  bool isLoading = false;
  //
  List<String> requestsStateList = KeyTranslate.requestsStateList.keys.toList();
  String chosenRequestsState;

  @override
  void initState() {
    chosenRequestsState = requestsStateList[0];
    gaRequestsStream = bloc.gaRequestsStream;
    isLoadingMoreRequests = false;
    bloc.fetcheGaRequests(chosenRequestsState);

    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (gaRequests.isNotEmpty) {
          setState(() {
            isLoading = true;
          });
          bloc.fetchMoreGaRequests().then((value) {
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
                    bloc.fetcheGaRequests(chosenRequestsState);
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
      body: StreamBuilder<List<GlobalAdminRequest>>(
        stream: gaRequestsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            gaRequests = snapshot.data;
            if (gaRequests.isNotEmpty) {
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
      itemCount: gaRequests.length + 1,
      separatorBuilder: (context, index) => Divider(height: 0.5),
      itemBuilder: (context, index) {
        if (index == gaRequests.length) {
          return _buildProgressIndicator();
        }

        return GaRequestTileWidget(
          bloc: bloc,
          gaRequest: gaRequests[index],
        );
      },
    );
  }
}
