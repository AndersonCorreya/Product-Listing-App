import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_listing_app/features/home/data/repositories/search_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  static const Duration _debounceDuration = Duration(milliseconds: 400);

  SearchBloc({required this.repository}) : super(const SearchInitialState()) {
    on<SearchQueryChanged>(
      _onQueryChanged,
      transformer: (events, mapper) =>
          events.debounce(_debounceDuration).switchMap(mapper),
    );
    on<SearchSubmitted>(_onSubmitted);
    on<SearchCleared>(_onCleared);
  }

  Future<void> _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitialState());
      return;
    }
    emit(const SearchLoadingState());
    try {
      final results = await repository.search(query);
      if (emit.isDone) return;
      emit(SearchLoadedState(results: results));
    } catch (e) {
      if (emit.isDone) return;
      emit(SearchErrorState(message: e.toString()));
    }
  }

  Future<void> _onSubmitted(
    SearchSubmitted event,
    Emitter<SearchState> emit,
  ) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(const SearchInitialState());
      return;
    }
    emit(const SearchLoadingState());
    try {
      final results = await repository.search(query);
      if (emit.isDone) return;
      emit(SearchLoadedState(results: results));
    } catch (e) {
      if (emit.isDone) return;
      emit(SearchErrorState(message: e.toString()));
    }
  }

  void _onCleared(SearchCleared event, Emitter<SearchState> emit) {
    emit(const SearchInitialState());
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
