class ViewState<T> {
  final bool isLoading;
  final T? data;
  final String? error;

  const ViewState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  ViewState<T> copyWith({
    bool? isLoading,
    T? data,
    String? error,
  }) {
    return ViewState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error ?? this.error,
    );
  }
}