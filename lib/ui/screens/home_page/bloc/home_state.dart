part of 'home_bloc.dart';

class HomeState extends Equatable {
  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class HomepageError extends HomeState {
  final String message;

  HomepageError({this.message});
  @override
  List<Object> get props => [message];
}

class HomepageLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class HomepageSuccess extends HomeState {
  @override
  List<Object> get props => [];
}

class HomepageLoaded extends HomeState {
  final List<NoteTile> notelist;

  HomepageLoaded({@required this.notelist});
  @override
  List<Object> get props => [notelist];
}
