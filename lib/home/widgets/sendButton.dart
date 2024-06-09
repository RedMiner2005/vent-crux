import 'package:flutter/material.dart';
import 'package:vent/home/cubit/home_cubit.dart';

class SendButton extends StatefulWidget {
  const SendButton({super.key, required this.textController, required this.cubit});
  
  final TextEditingController textController;
  final HomeCubit cubit;

  @override
  State<SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<SendButton> {
  @override
  Widget build(BuildContext context) {
    final isEnabled = !widget.cubit.state.isRecording && !widget.cubit.state.isProcessing && widget.textController.text != "";
    final activeColor = Color.lerp(Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer, 0.7);
    return Container(
      width: 80.0,
      height: 80.0,
      child: Material(
        color: (isEnabled) ? activeColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: (isEnabled) ? 0.0 : 0.0,
        clipBehavior: Clip.antiAlias,
        child: MaterialButton(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onPressed: (isEnabled) ? widget.cubit.onSendButtonPressed : null,
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
    );
  }

  void controllerListener() {
    setState(() {

    });
  }

  @override
  void initState() {
    widget.textController.addListener(controllerListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.textController.removeListener(controllerListener);
    super.dispose();
  }
}
