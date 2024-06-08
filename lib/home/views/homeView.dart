import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vent/app/app.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/widgets/widgets.dart';
import 'package:vent/src/repository/authService.dart';
import 'package:vent/src/repository/backendService.dart';
import 'package:vent/src/repository/repository.dart';

class HomeView extends StatefulWidget {
  const HomeView();

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late TextEditingController controller;
  late FocusNode focusNode;
  late VoiceService _voiceService;
  bool isRecording = false;
  bool initOnce = false;

  @override
  Widget build(BuildContext context) {
    _voiceService = context.read<VoiceService>();
    // _voiceService?.init(
    //   () => null,
    //   (append) {
    //     controller.text += append;
    //   },
    //   (e) {
    //     Fluttertoast.showToast(msg: "Recording error");
    //     log("Recording error: ${e.toString()}");
    //     setState(() {
    //       isRecording = false;
    //     });
    //   },
    //   (duration) => null
    // );
    return BlocProvider(
      create: (context) => HomeCubit(
          backendService: context.read<BackendService>(),
          voiceService: context.read<VoiceService>(),
          contactService: context.read<ContactService>(),
          controller: controller
      ),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final cubit = context.read<HomeCubit>();
          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Container(),
              ),
              actions: <Widget>[
                NotificationsButton(),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    switch (value) {
                      case 'Logout':
                        context.read<AppBloc>().add(AppLogoutRequested());
                        break;
                      case 'About':
                        showAboutDialog(context: context);
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'About', 'Logout'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
            body: Container(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: TextField(
                        controller: controller,
                        focusNode: focusNode,
                      ),
                    ),
                    Spacer(),
                    VoiceButton(voiceService: _voiceService, controller: controller),
                    ElevatedButton(
                        onPressed: cubit.send,
                        child: Text("Process")
                    ),
                    Spacer()
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    controller = TextEditingController();
    focusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    _voiceService.dispose();
    super.dispose();
  }
}
