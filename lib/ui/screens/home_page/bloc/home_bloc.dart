import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/ui/components/note_tile.dart';

part 'home_state.dart';
part 'home_event.dart';

class HomepageBloc extends Bloc<HomeEvent, HomeState> {
  HomepageBloc() : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {
    try {
      if (event is NotesRequested) {
        List<NoteTile> _noteList = [];
        for (var _note in savedNotes) {
          _noteList.add(
            NoteTile(
              title: _note.title,
              contents: _note.contents,
              id: _note.id,
              date: _note.date,
              searchKey: _note.searchKey,
            ),
          );
        }
        yield HomepageLoaded(notelist: _noteList);
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
