import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vent/app/bloc/app_bloc.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/home.dart';

class ExtrasButton extends StatelessWidget {
  const ExtrasButton({super.key, required this.cubit});

  final HomeCubit cubit;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      height: 80.0,
      child: Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        clipBehavior: Clip.antiAlias,
        child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => ExtrasDialog(
                onLogout: () {
                  context.read<AppBloc>().add(AppLogoutRequested());
                },
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.more_horiz_rounded,
              size: 32.0,
            ),
          ),
        ),
      ),
    );
  }
}
