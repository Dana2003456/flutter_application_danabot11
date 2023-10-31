abstract class DataState {}

class DataInitial extends DataState {}

class DataLoading extends DataState {}

class DataLoaded extends DataState {
  final List<dynamic> comments;

  DataLoaded(this.comments);
}

class DataError extends DataState {
  final String message;

  DataError(this.message);
}
