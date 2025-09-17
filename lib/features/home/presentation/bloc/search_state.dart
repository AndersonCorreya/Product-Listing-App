part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitialState extends SearchState {
  const SearchInitialState();
}

class SearchLoadingState extends SearchState {
  const SearchLoadingState();
}

class SearchLoadedState extends SearchState {
  final List<Map<String, dynamic>> results;
  const SearchLoadedState({required this.results});

  @override
  List<Object?> get props => [results];
}

class SearchErrorState extends SearchState {
  final String message;
  const SearchErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
