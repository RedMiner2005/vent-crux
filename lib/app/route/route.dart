import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:vent/app/app.dart';
import 'package:vent/home/home.dart';
import 'package:vent/login/views/loginView.dart';

final ventRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) {
        if (state.extra == null)
          return HomeView(initialStatus: HomeStatus.home);
        final initialStatus = state.extra as HomeStatus;
        return HomeView(initialStatus: initialStatus,);
      },
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
  ],
);

extension GoRouterExtension on GoRouter{
  void clearStackAndPush(String location, {Object? extra}){
    while(canPop()){
      pop();
    }
    pushReplacement(location, extra: extra);
  }
}
