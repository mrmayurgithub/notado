part of 'trash_bloc.dart';

class TrashState extends Equatable {
  @override
  List<Object> get props => [];
}

class TrashInitial extends TrashState {
  @override
  List<Object> get props => [];
}

class TrashError extends TrashState {
  final String message;

  TrashError({@required this.message});

  @override
  List<Object> get props => [message];
}

class TrashLoading extends TrashState {
  @override
  List<Object> get props => [];
}

class TrashSuccess extends TrashState {
  @override
  List<Object> get props => [];
}

class TrashLoaded extends TrashState {
  final List<Note> trashList;

  TrashLoaded({@required this.trashList});
  @override
  List<Object> get props => [trashList];
}

class DeletingNoteFromTrash extends TrashState {
  @override
  List<Object> get props => [];
}

class DeleteFromTrashSuccess extends TrashState {
  @override
  List<Object> get props => [];
}


class RestoringNotesFromTrash extends TrashState{
  @override
  List<Object> get props => [];
}

class RestoringNotesFromTrashSuccess extends TrashState{
  @override
  List<Object> get props => [];
}