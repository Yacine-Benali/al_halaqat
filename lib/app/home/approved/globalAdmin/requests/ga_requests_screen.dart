// import 'package:al_halaqat/app/home/approved/globalAdmin/requests/ga_requests_bloc.dart';
// import 'package:al_halaqat/app/home/approved/globalAdmin/requests/ga_requests_provider.dart';
// import 'package:al_halaqat/app/models/global_admin_request.dart';
// import 'package:al_halaqat/services/database.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class GaRequestsScreen extends StatefulWidget {
//   const GaRequestsScreen._({Key key, @required this.bloc}) : super(key: key);

//   final GaRequestsBloc bloc;

//   static Widget create({@required BuildContext context}) {
//     Database database = Provider.of<Database>(context, listen: false);
//     GaRequestsProvider provider = GaRequestsProvider(database: database);
//     GaRequestsBloc bloc = GaRequestsBloc(provider: provider);

//     return GaRequestsScreen._(
//       bloc: bloc,
//     );
//   }

//   @override
//   _RequestsScreenState createState() => _RequestsScreenState();
// }

// class _RequestsScreenState extends State<GaRequestsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(appBar: ,
//     body: FutureBuilder<List<GlobalAdminRequest>>(
//       future: ,
//       builder: (context,snapshot)
//       {

//       },
//     ),);
//   }
// }
