import 'package:equatable/equatable.dart';

import 'state_status.dart';

class BaseState<T> extends Equatable {
  final StateStatus status;
  final T? data;
  final String? message;

  const BaseState({
    this.status = StateStatus.initial,
    this.data,
    this.message,
  });

  BaseState<T> copyWith({
    StateStatus? status,
    T? data,
    String? message,
  }) {
    return BaseState(
      status: status ?? this.status,
      data: data ?? this.data,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    status,
    data,
    message,
  ];
}