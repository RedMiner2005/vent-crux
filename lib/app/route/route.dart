import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/app/app.dart';
import 'package:vent/app/widgets/dialogPage.dart';
import 'package:vent/home/home.dart';
import 'package:vent/home/views/homeContactDialog.dart';
import 'package:vent/login/views/loginView.dart';
import 'package:vent/src/models/models.dart';
import 'package:vent/src/repository/repository.dart';

final ventRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeView(),
      redirect: (context, state) {
        if (context.read<AppBloc>().state.status == AppStatus.unauthenticated)
          return '/login';
        return null;
      }
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginView(),
    ),
    GoRoute(
      path: '/contactDialog',
      pageBuilder: (context, state) => DialogPage(
          builder: (_) {
            List<Map<String, dynamic>> contacts = state.extra as List<Map<String, dynamic>>;
            return ContactDialog(contacts: contacts);
          }
      ),
    )
  ],
);

extension GoRouterExtension on GoRouter{
  void clearStackAndPush(String location){
    while(canPop()){
      pop();
    }
    pushReplacement(location);
  }
}
