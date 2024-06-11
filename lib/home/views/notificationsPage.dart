import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
    return StreamBuilder<List<Map<String, dynamic>>>(
      initialData: [{"LOADING": "LOADING"}],
      stream: authService.inbox,
      builder: (context, snapshot) {
        final nothingWidget = Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NotificationsTitle(pageController: widget.pageController, cubit: widget.cubit),
            Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 48.0, 32.0, 16.0),
                  child: Icon(Icons.sentiment_satisfied_rounded, size: 72.0,),
                )
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(48.0, 16.0, 48.0, 48.0),
                child: Text("Hmm, nobody has vented about you... yet.", textAlign: TextAlign.center,),
              ),
            ),
          ],
        );
        try {
          if (!snapshot.hasData || snapshot.data == [] || snapshot.data == null) {
            return nothingWidget;
          } else if ((snapshot.data ?? [{}])[0].containsKey("LOADING")) {
            return LoadingWidget();
          }
          return ListView.separated(
            itemCount: snapshot.data!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0)
                return NotificationsTitle(pageController: widget.pageController, cubit: widget.cubit);
              index -= 1;
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
                duration: Duration(milliseconds: VentConfig.animationDuration.inMilliseconds~/4),
                child: SlideAnimation(
                  verticalOffset: VentConfig.animationSlideOffset,
                  child: FadeInAnimation(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
                      child: ListTile(
                        key: ValueKey<String>(message + formattedDateTime),
                        title: Text(
                          message,
                          style: TextStyle(
                              fontFamily: 'Englebert',
                              fontSize: 18.0
                          ),
                        ),
                        subtitle: Text(formattedDateTime),
                        trailing: ((snapshot.data![index]["unread"] ?? false) as bool) ? Badge(
                          smallSize: 10.0,
                        ) : null,
                      ),
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              if (index == 0)
                return Container();
              index -= 1;
              return AnimationConfiguration.staggeredList(
                position: 2 * index + 1,
                duration: Duration(milliseconds: VentConfig.animationDuration.inMilliseconds~/4),
                child: SlideAnimation(
                  verticalOffset: VentConfig.animationSlideOffset,
                  child: FadeInAnimation(
                    child: const Divider(
                      thickness: 1,
                      height: 20,
                      indent: 10.0,
                      endIndent: 10.0,
                    ),
                  ),
                ),
              );
            },
          );
        } on RangeError catch (e) {
          return nothingWidget;
        }
      },
    );
  }
}
