import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:vent/src/repository/authService.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required AuthenticationService authService}) : _authService = authService, super(HomeState.initial());

  final AuthenticationService _authService;
}
