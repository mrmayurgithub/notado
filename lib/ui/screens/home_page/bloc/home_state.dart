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

class NewZefyrPageLoaded extends HomeState {
  @override
  List<Object> get props => [];
}

class EditZefyrpageLoaded extends HomeState {
  final NotusDocument contents;
  final String title;
  final String date;
  final String searchKey;
  final String id;
  EditZefyrpageLoaded({
    @required this.contents,
    @required this.date,
    @required this.searchKey,
    @required this.title,
    @required this.id,
  });
  @override
  List<Object> get props => [contents, title, date, searchKey, id];
}

class CreateLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class UpdateLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class Cancelled extends HomeState {
  @override
  List<Object> get props => [];
}

class UpdateSuccess extends HomeState {
  @override
  List<Object> get props => [];
}

class CreateSuccess extends HomeState {
  @override
  List<Object> get props => [];
}
