import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:rxdart/rxdart.dart';
import 'package:vent/app/bloc/app_bloc.dart';
import 'package:vent/app/widgets/loading.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/widgets/widgets.dart';
import 'package:vent/src/config.dart';
import 'package:vent/src/repository/repository.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key, required this.cubit, required this.textController, required this.pageController, required this.focusNode});

  final TextEditingController textController;
  final PageController pageController;
  final FocusNode focusNode;
  final HomeCubit cubit;

  @override
  State<NotificationsPage> createState() => _HomePageState();
}

class _HomePageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthenticationService>();
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Container(),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            widget.pageController.previousPage(
              duration: VentConfig.ANIMATION_PAGE_SWIPE_DURATION,
              curve: Curves.easeOut,
            );
          },
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        initialData: [{"LOADING": "LOADING"}],
        stream: authService.inbox,
        builder: (context, snapshot) {
          if (snapshot.data?[0].containsKey("LOADING") ?? false) {
            return LoadingWidget();
          }
          if (!snapshot.hasData || snapshot.data == [] || snapshot.data == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: Text("Nothing to see here!")),
              ],
            );
          }
          return ListView.separated(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final dateTime = snapshot.data![index]["time"];
              final message = (snapshot.data![index]["message"] ?? "") as String;
              final today = DateTime.timestamp().toLocal();
              String formattedDateTime;
              if (today.difference(dateTime).inDays >= 7) {
                formattedDateTime = VentConfig.dateFormat.format(dateTime);
              } else if (today.day != dateTime.day) {
                formattedDateTime = VentConfig.weekdayFormat.format(dateTime);
              } else {
                formattedDateTime = VentConfig.timeFormat.format(dateTime);
              }
              return AnimationConfiguration.staggeredList(
                position: index,
                duration: Duration(milliseconds: VentConfig.ANIMATION_DURATION.inMilliseconds~/2),
                child: SlideAnimation(
                  verticalOffset: VentConfig.ANIMATION_SLIDE_OFFSET,
                  child: FadeInAnimation(
                    child: ListTile(
                      key: ValueKey<String>(message + formattedDateTime),
                      title: Text(message),
                      subtitle: Text(formattedDateTime),
                      trailing: ((snapshot.data![index]["unread"] ?? false) as bool) ? Badge() : null,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return AnimationConfiguration.staggeredList(
                position: 2 * index + 1,
                duration: Duration(milliseconds: VentConfig.ANIMATION_DURATION.inMilliseconds~/2),
                child: FadeInAnimation(
                  child: const Divider(
                    thickness: 1,
                    height: 20,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
