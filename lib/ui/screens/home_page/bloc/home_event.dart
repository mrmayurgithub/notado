part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class NotesRequested extends HomeEvent {
  @override
  List<Object> get props => [];
}

class NewNoteRequest extends HomeEvent {
  @override
  List<Object> get props => [];
}

class SaveNewNote extends HomeEvent {
  final String contents;
  final String title;
  final String date;
  final String searchKey;
  SaveNewNote({
    @required this.contents,
    @required this.date,
    @required this.searchKey,
    @required this.title,
  });
  @override
  List<Object> get props => [contents, title, date, searchKey];
}

class EditNoteRequest extends HomeEvent {
  final String contents;
  final String title;
  final String date;
  final String id;
  final String searchKey;
  EditNoteRequest({
    @required this.contents,
    @required this.date,
    @required this.id,
    @required this.searchKey,
    @required this.title,
  });
  @override
  List<Object> get props => [contents, title, date, id, searchKey];
}

class UpdateNote extends HomeEvent {
  final String contents;
  final String title;
  final String date;
  final String id;
  final String searchKey;
  UpdateNote({
    @required this.contents,
    @required this.date,
    @required this.id,
    @required this.searchKey,
    @required this.title,
  });
  @override
  List<Object> get props => [contents, title, date, id, searchKey];
}

class DeleteNotesRequest extends HomeEvent {
  final List<Note> deleteNotesList;
  DeleteNotesRequest(this.deleteNotesList);
  @override
  List<Object> get props => [deleteNotesList];
}

class CancelRequest extends HomeEvent {}
