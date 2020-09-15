import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:notado/global/database_helper/database_helper.dart';
import 'package:notado/global/helper/global_helper.dart';
part 'zefyr_event.dart';
part 'zefyr_state.dart';

class ZefyrBloc extends Bloc<ZefyrEvent, ZefyrState> {
  //TODO: check
  //TODO: check
  ZefyrBloc() : super(null);

  @override
  Stream<ZefyrState> mapEventToState(ZefyrEvent event) async* {
    try {
      if (event is CreateNote) {
        yield CreateLoading();
        await DatabaseHelper.createZefyrUserData(
          contents: event.contents,
          date: event.date,
          title: event.title,
          searchKey: event.searchKey,
        );
        //TODO: check
        //TODO: implement this below acc to userchoice
        await getNotesFromNotesOBName();
        yield CreateSuccess();
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
        //TODO: check
        //TODO: implement this below acc to userchoice
        await getNotesFromNotesOBName();
        yield UpdateSuccess();
      }
      if (event is CancelEdit) {
        yield Cancelled();
      }
    } on PlatformException catch (e) {
      yield (ZefyrError(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (ZefyrError(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (ZefyrError(message: e.toString()));
    }
  }
}
