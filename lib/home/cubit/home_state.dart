part of 'home_cubit.dart';

enum HomeStatus {
  initial
}

class HomeState extends Equatable {
  const HomeState._({required this.status});

  const HomeState.initial() : this._(status: HomeStatus.initial);

  final HomeStatus status;

  @override
  List<Object?> get props => [status];
}

