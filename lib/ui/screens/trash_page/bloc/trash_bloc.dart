import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/models/note_model/note_model.dart';
part 'trash_event.dart';
part 'trash_state.dart';

class TrashBloc extends Bloc<TrashEvent, TrashState> {
  TrashBloc() : super(TrashInitial());

  @override
  Stream<TrashState> mapEventToState(TrashEvent event) async* {
    try {
      if (event is TrashNotesRequested) {
        logger.v('Trash Notes Requested');
        yield TrashLoaded(trashList: deletedNotes);
      }
      if (event is RestoreNoteRequested) {}
      if (event is DeleteNoteFromTrash) {}
    } on PlatformException catch (e) {
      yield (TrashError(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (TrashError(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (TrashError(message: e.toString()));
    }
  }
}
