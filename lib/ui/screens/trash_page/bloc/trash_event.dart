part of 'trash_bloc.dart';

abstract class TrashEvent extends Equatable {
  const TrashEvent();
  @override
  List<Object> get props => [];
}

class TrashNotesRequested extends TrashEvent {
  @override
  List<Object> get props => [];
}

class RestoreNoteRequested extends TrashEvent {
    final String contents;
  final String title;
  final String date;
  final String id;
  final String searchKey;
  RestoreNoteRequested({
    @required this.contents,
    @required this.date,
    @required this.id,
    @required this.searchKey,
    @required this.title,
  });
  @override
  List<Object> get props => [contents,title,date,id,searchKey];
}

class DeleteNoteFromTrash extends TrashEvent {
  final String id;

  DeleteNoteFromTrash({@required this.id});

  @override
  List<Object> get props => [id];
}
