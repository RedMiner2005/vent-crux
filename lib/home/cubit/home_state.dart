part of 'home_cubit.dart';

enum HomeStatus {
  home,
  notifications
}

class HomeState extends Equatable {
  const HomeState._({required this.status, this.connectionStatus=ConnectionStatus.connected, required this.message, required this.persistentMessage, required this.isRecording, required this.isProcessing, required this.isFieldEmpty, required this.doIntroAnimationHome, required this.doIntroAnimationNotifications});

  HomeState.defaultState(HomeStatus status) : this._(status: status, message: VentConfig.greetingSecondaryText, persistentMessage: VentConfig.greetingSecondaryText, isRecording: false, isProcessing: false, isFieldEmpty: true, doIntroAnimationHome: true, doIntroAnimationNotifications: true);

  final HomeStatus status;
  final ConnectionStatus connectionStatus;
  final String message;
  final String persistentMessage;
  final bool isRecording;
  final bool isProcessing;
  final bool isFieldEmpty;
  final bool doIntroAnimationHome;
  final bool doIntroAnimationNotifications;

  @override
  List<Object?> get props => [status, connectionStatus, message, isRecording, isProcessing, isFieldEmpty];

  HomeState copyWith({HomeStatus? status, ConnectionStatus? connectionStatus, String? message, String? persistentMessage, bool? isRecording, bool? isProcessing, bool? isFieldEmpty, bool? doIntroAnimationHome, bool? doIntroAnimationNotifications}) {
    return HomeState._(
      status: status ?? this.status,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      message: message ?? this.message,
      persistentMessage: persistentMessage ?? this.persistentMessage,
      isRecording: isRecording ?? this.isRecording,
      isProcessing: isProcessing ?? this.isProcessing,
      isFieldEmpty: isFieldEmpty ?? this.isFieldEmpty,
      doIntroAnimationHome: doIntroAnimationHome ?? false,
      doIntroAnimationNotifications: doIntroAnimationNotifications ?? this.doIntroAnimationNotifications,
    );
  }
}

