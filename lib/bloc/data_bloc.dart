import 'package:flutter_application_danabot/com/page.dart';
import 'package:flutter_application_danabot/retdio/retdio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data_event.dart';
import 'data_state.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  final Controlapi apiService;

  DataBloc(this.apiService) : super(DataInitial()) {
    on<FetchCommentsEvent>(_onFetchCommentsEvent);
  }

  Future<void> _onFetchCommentsEvent(
      FetchCommentsEvent event, Emitter<DataState> emit) async {
    emit(DataLoading());
    try {
      List<Comment> comments = await apiService.fetchComments();
      if (comments.isNotEmpty) {
        emit(DataLoaded(comments));
      } else {
        emit(DataError('No comments received'));
      }
    } catch (e) {
      emit(DataError(e.toString()));
    }
  }
}
