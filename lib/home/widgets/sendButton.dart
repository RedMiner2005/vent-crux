import 'package:flutter/material.dart';
import 'package:vent/home/cubit/home_cubit.dart';
import 'package:vent/home/widgets/customTooltip.dart';
import 'package:vent/src/repository/connnectionService.dart';

class SendButton extends StatelessWidget {
  const SendButton({super.key, required this.cubit, required this.openDialog});

  final HomeCubit cubit;
  final Function openDialog;

  @override
  Widget build(BuildContext context) {
    final isEnabled = !cubit.state.isRecording && !cubit.state.isProcessing && !cubit.state.isFieldEmpty && cubit.state.connectionStatus == ConnectionStatus.connected;
    final activeColor = Color.lerp(Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer, 0.7);
    return Container(
      width: 80.0,
      height: 80.0,
      child: Material(
        color: (isEnabled) ? activeColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: (isEnabled) ? 0.0 : 0.0,
        clipBehavior: Clip.antiAlias,
        child: CustomTooltip(
          message: "Send",
          child: MaterialButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onPressed: (isEnabled) ? () {cubit.onSendButtonPressed(openDialog);} : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                (!isEnabled) ? Icons.cancel_schedule_send_outlined : Icons.send_rounded,
                size: 32.0,
                color: (isEnabled) ? null : Colors.grey[500],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
