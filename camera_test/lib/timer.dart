import 'dart:async';
import 'package:bloc/bloc.dart';

class TimerBloc extends Bloc<int, int> {
  TimerBloc() : super(60);

  @override
  Stream<int> mapEventToState(int event) async* {
    yield state - 1;
  }
}
