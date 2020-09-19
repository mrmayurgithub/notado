import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/services/userRepository/user_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  // UserRepository _userRepository;

  AuthenticationBloc() : super(UnauthenticatedAuth());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    try {
      if (event is AppStarted) {
        yield AuthInProgress();
        logger.i('Auth in Progress....');
        final isSignedIn = await UserRepository().isSignedIn();
        if (isSignedIn) {
          logger.i(isSignedIn.toString());
          yield AuthenticatedAuth();
        } else
          yield UnauthenticatedAuth();
      } else if (event is LoggedIn) {
        logger.i('Logged In');
        yield AuthenticatedAuth();
      } else if (event is LoggedOut) {
        yield (AuthInProgress());
        logger.i('Authentication in progress');
        await UserRepository().signOut();
        await disposeApi;
        yield UnauthenticatedAuth();
      }
    } on PlatformException catch (e) {
      yield (AuthFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (AuthFailure(message: "Timeout: ${e.message}"));
    } on AuthException catch (e) {
      yield (AuthFailure(message: "Error: ${e.message}"));
    } catch (e) {
      yield (AuthFailure(message: e.toString()));
    }
  }
}
