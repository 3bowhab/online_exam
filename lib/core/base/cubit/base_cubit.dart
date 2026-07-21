import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  void emitSafe(S state) {
    if (!isClosed) {
      emit(state);
    }
  }

  void logMessage(Object message) {
    developer.log("[$runtimeType] $message");
  }
}