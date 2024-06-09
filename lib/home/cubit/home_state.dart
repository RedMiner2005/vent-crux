part of 'home_cubit.dart';

enum HomeStatus {
  initial,
  notifications
}

class HomeState extends Equatable {
  const HomeState._({required this.status, required this.message, required this.isRecording, required this.doIntroAnimation, required this.isProcessing});

  HomeState.initial() : this._(status: HomeStatus.initial, message: VentConfig.greetingSecondaryText, isRecording: false, doIntroAnimation: true, isProcessing: false);

  final HomeStatus status;
  final String message;
  final bool isRecording;
  final bool isProcessing;
  final bool doIntroAnimation;

  @override
  List<Object?> get props => [status, message, isRecording, isProcessing];

  HomeState copyWith({HomeStatus? status, String? message, bool? isRecording, bool? doIntroAnimation, bool? isProcessing}) {
    return HomeState._(
      status: status ?? this.status,
      message: message ?? this.message,
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      doIntroAnimation: doIntroAnimation ?? false,
    );
  }
}

