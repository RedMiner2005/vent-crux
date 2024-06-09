import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vent/app/bloc/app_bloc.dart';
import 'package:vent/home/cubit/home_cubit.dart';
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
  bool isRecording = false;


  @override
  Widget build(BuildContext context) {
    _voiceService = context.read<VoiceService>();
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HomeTitle(pageController: widget.pageController, cubit: widget.cubit),
                SizedBox(height: 10.0,),
                HomeTextField(textEditingController: widget.textController, focusNode: widget.focusNode, cubit: widget.cubit,),
                SizedBox(height: 50.0),
              ],
            ),
          ),
        ),
        Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Container(
                child: Stack(
                  children: [
                    Card(
                      elevation: 10.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: SizedBox(
                        height: 100,
                        width: 300,
                      ),
                    ),
                    SizedBox(
                      width: 300,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ExtrasButton(cubit: widget.cubit),
                          VoiceButton(voiceService: _voiceService, textController: widget.textController, cubit: widget.cubit),
                          SendButton(textController: widget.textController, cubit: widget.cubit),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().slideY(begin: (widget.cubit.state.doIntroAnimation) ? 1.2 : 0.0, curve: Curves.easeOutQuad),
            ),
          ],
        )
      ],
    );
  }

  // Widget oldBuild(BuildContext context) {
  //   _voiceService = context.read<VoiceService>();
  //   final cubit = context.read<HomeCubit>();
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Padding(
  //         padding: const EdgeInsets.symmetric(vertical: 20.0),
  //         child: Container(),
  //       ),
  //       actions: <Widget>[
  //         NotificationsButton(pageController: widget.pageController,),
  //         PopupMenuButton<String>(
  //           onSelected: (value) {
  //             switch (value) {
  //               case 'Logout':
  //                 context.read<AppBloc>().add(AppLogoutRequested());
  //                 break;
  //               case 'About':
  //                 showAboutDialog(context: context);
  //                 break;
  //             }
  //           },
  //           itemBuilder: (BuildContext context) {
  //             return {'About', 'Logout'}.map((String choice) {
  //               return PopupMenuItem<String>(
  //                 value: choice,
  //                 child: Text(choice),
  //               );
  //             }).toList();
  //           },
  //         ),
  //       ],
  //     ),
  //     body: SingleChildScrollView(
  //       physics: BouncingScrollPhysics(),
  //       child: Center(
  //         child: Column(
  //           children: [
  //             Padding(
  //               padding: const EdgeInsets.all(32.0),
  //               child: TextField(
  //                 controller: widget.textController,
  //                 focusNode: widget.focusNode,
  //               ),
  //             ),
  //             VoiceButton(voiceService: _voiceService, textController: widget.textController, cubit: cubit,),
  //             ElevatedButton(
  //                 onPressed: () async {
  //                   final processData = await widget.cubit.process();
  //                   if (processData == {}) {
  //                     return;
  //                   }
  //                   if (processData["result"]["isValid"] != true) {
  //                     Fluttertoast.showToast(msg: "Don't beat around the bush. Talk about someone who's nagging you.");
  //                     return;
  //                   }
  //                   String? chosenHash;
  //                   log(processData["matches"].toString());
  //                   if(processData["matches"].length == 1) {
  //                     chosenHash = processData["matches"][0]["hash"];
  //                   } else {
  //                     chosenHash = await context.push("/contactDialog", extra: processData["matches"]);
  //                     if (chosenHash == null) {
  //                       Fluttertoast.showToast(msg: "No contact chosen. Vent cancelled.");
  //                       return;
  //                     }
  //                   }
  //                   if (chosenHash == null) {
  //                     Fluttertoast.showToast(msg: "Some error occurred. Vent cancelled.");
  //                     return;
  //                   }
  //                   widget.cubit.send(processData, chosenHash);
  //                 },
  //                 child: Text("Process")
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  @override
  void dispose() {
    _voiceService.dispose();
    super.dispose();
  }
}
