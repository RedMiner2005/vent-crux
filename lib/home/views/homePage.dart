import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/app/bloc/app_bloc.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/home.dart';
import 'package:vent/home/widgets/homeBottomBar.dart';
import 'package:vent/home/widgets/widgets.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.cubit, required this.textController, required this.pageController, required this.focusNode,});

  final TextEditingController textController;
  final PageController pageController;
  final FocusNode focusNode;
  final HomeCubit cubit;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late VoiceService _voiceService;
  late StreamSubscription<ConnectionStatus> _connSub;

  @override
  Widget build(BuildContext context) {
    _voiceService = context.read<VoiceService>();
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: ListView(
              children: [
                HomeTitle(pageController: widget.pageController, cubit: widget.cubit),
                SizedBox(height: 10.0,),
                HomeTextField(textEditingController: widget.textController, focusNode: widget.focusNode, cubit: widget.cubit,),
                SizedBox(height: 120.0),
              ],
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            HomeBottomBar(cubit: widget.cubit),
          ],
        )
      ],
    );
  }

  @override
  void initState() {
    _connSub = widget.cubit.listenConnection();
    super.initState();
  }

  @override
  void dispose() {
    _connSub.cancel();
    _voiceService.dispose();
    super.dispose();
  }
}
