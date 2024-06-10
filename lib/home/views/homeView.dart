import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/app/app.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/home.dart';
import 'package:vent/home/views/notificationsPage.dart';
import 'package:vent/home/widgets/widgets.dart';
import 'package:vent/src/repository/authService.dart';
import 'package:vent/src/repository/backendService.dart';
import 'package:vent/src/repository/repository.dart';

class HomeView extends StatefulWidget {
  const HomeView({required this.initialStatus});

  final HomeStatus initialStatus;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController textController;
  late PageController pageController;
  late FocusNode focusNode;
  late VoiceService _voiceService;

  @override
  Widget build(BuildContext context) {
    _voiceService = context.read<VoiceService>();
    final _authService = context.read<AuthenticationService>();
    final _backendService = context.read<BackendService>();
    final _contactService = context.read<ContactService>();
    return BlocProvider(
      create: (context) => HomeCubit(
        authService: _authService,
        backendService: _backendService,
        voiceService: _voiceService,
        contactService: _contactService,
        textController: textController,
      ),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            body: PageView(
              children: [
                HomePage(cubit: cubit, textController: textController, focusNode: focusNode, pageController: pageController),
                NotificationsPage(cubit: cubit, textController: textController, focusNode: focusNode, pageController: pageController,),
              ],
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              controller: pageController,
              onPageChanged: cubit.onPageChanged,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    textController = TextEditingController();
    pageController = PageController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    textController.dispose();
    focusNode.dispose();
    pageController.dispose();
    _voiceService.dispose();
    super.dispose();
  }
}
