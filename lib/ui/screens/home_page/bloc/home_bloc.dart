import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/global/database_helper/database_helper.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/ui/components/note_tile.dart';
import 'package:notado/ui/screens/add_zefyr_note/bloc/zefyr_bloc.dart';
import 'package:zefyr/zefyr.dart';
part 'home_state.dart';
part 'home_event.dart';

class HomepageBloc extends Bloc<HomeEvent, HomeState> {
  HomepageBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    try {
      if (event is NotesRequested) {
        // List<NoteTile> _noteList = [];
        // for (var _note in savedNotes) {
        //   _noteList.add(
        //     NoteTile(
        //       title: _note.title,
        //       contents: _note.contents,
        //       id: _note.id,
        //       date: _note.date,
        //       searchKey: _note.searchKey,
        //     ),
        //   );
        // }
        // yield HomepageLoaded(notelist: _noteList);
        logger.v('Notes Requested');
        yield HomepageLoaded(notelist: savedNotes);
      }
      if (event is CreateNote) {
        yield NewZefyrPageLoaded();
      }
      if (event is EditNoteRequest) {
        var zefyrnotedata = NotusDocument.fromJson(jsonDecode(event.contents));
        yield EditZefyrpageLoaded(
          contents: zefyrnotedata,
          date: event.date,
          searchKey: event.searchKey,
          title: event.title,
          id: event.id,
        );
      }
      if (event is NewNoteRequest) {
        yield NewZefyrPageLoaded();
      }
      if (event is UpdateNote) {
        yield UpdateLoading();
        await DatabaseHelper.updateZefyrUserData(
          contents: event.contents,
          title: event.title,
          id: event.id,
          date: event.date,
          searchKey: event.searchKey,
        );
        //TODO: by userchoice
        await getNotesFromNotesOBName();
        yield UpdateSuccess();
      }
      if (event is CancelRequest) {
        yield Cancelled();
      }
      if (event is DeleteNotesRequest) {
        yield DeletingNotes();
        logger.v('Deleting Notes...');
        event.deleteNotesList.forEach((element) {
          if (savedNotes.contains(element)) {
            DatabaseHelper.deleteZefyrUserDataFromNotes(
              contents: element.contents,
              title: element.title,
              id: element.id,
              date: element.date,
              searchKey: element.searchKey,
            );
          }
        });
        logger.v('Deleted Successfully');
        await getNotesFromNotesOBName();
        yield HomepageLoaded(notelist: savedNotes);
      }
    } on PlatformException catch (e) {
      yield (HomepageError(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (HomepageError(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (HomepageError(message: e.toString()));
    }
  }
}
