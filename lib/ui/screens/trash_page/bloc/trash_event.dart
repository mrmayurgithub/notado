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
  @override
  List<Object> get props => [];
}

class DeleteNoteFromTrash extends TrashEvent {
  final String id;

  DeleteNoteFromTrash({@required this.id});

  @override
  List<Object> get props => [id];
}
