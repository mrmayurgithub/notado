import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:notado/services/userRepository/user_repository.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository _userRepository;

  AuthenticationBloc() : super(UninitializedAuth());

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    try {
      if (event is AppStarted) {
        yield AuthInProgress();
        final isSignedIn = await _userRepository.isSignedIn();
        if (isSignedIn) {
          yield AuthenticatedAuth();
        } else
          yield UnauthenticatedAuth();
      } else if (event is LoggedIn) {
        yield AuthenticatedAuth();
      } else if (event is LoggedOut) {
        yield (AuthInProgress());
        await _userRepository.signOut();
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
