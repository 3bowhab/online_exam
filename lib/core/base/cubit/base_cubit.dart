import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BaseCubit<S> extends Cubit<S> {
  BaseCubit(super.initialState);

  void emitSafe(S state) {
    if (!isClosed) {
      emit(state);
    }
  }
  void log(Object message) {
    log("[${runtimeType}] $message");
  }

}