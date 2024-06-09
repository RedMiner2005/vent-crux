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
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      // pageBuilder: (context, state) => CustomTransitionPage<void>(
      //   key: state.pageKey,
      //   child: const HomeView(),
      //   transitionDuration: const Duration(milliseconds: 300),
      //   transitionsBuilder: (BuildContext context,
      //       Animation<double> animation,
      //       Animation<double> secondaryAnimation,
      //       Widget child) {
      //     // Change the opacity of the screen using a Curve based on the the animation's
      //     // value
      //     return FadeTransition(
      //       opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      //       child: SlideTransition(
      //         position: Tween<Offset>(
      //           begin: Offset.zero,
      //             end: Offset(-1.5, 0),
      //         ).animate(new CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
      //         child: child,
      //       ),
      //     );
      //   },
      // ),
      builder: (context, state) => HomeView(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => LoginView(),
        redirect: (context, state) {
          if (context.read<AppBloc>().state.status == AppStatus.authenticated)
            return '/';
          return null;
        }
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
