import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/home/home.dart';
import 'package:vent/login/views/loginView.dart';
import 'package:vent/src/models/models.dart';
import 'package:vent/src/repository/repository.dart';

final ventRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeView(),
      redirect: (context, state) {
        if (context.read<AuthenticationService>().userObject == UserModel.empty)
        // if (context.read<AppBloc>().state.status == AppStatus.unauthenticated)
          return '/login';
        return null;
      }
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginView(),
    ),
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
