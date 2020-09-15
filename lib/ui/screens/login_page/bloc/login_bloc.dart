import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/global/helper/global_helper.dart';
import 'package:notado/services/userRepository/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial());
  UserRepository _userRepository;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      if (event is LoginWithGoogle) {
        _userRepository.LoginWithGoogle();
        await FirebaseAnalytics().logLogin(loginMethod: "google_signin");
        await initializeApi;
        yield LoginSuccess();
      }
    } on PlatformException catch (e) {
      yield (LoginFailure(message: "Error: ${e.message}"));
    } on TimeoutException catch (e) {
      yield (LoginFailure(message: "Timeout: ${e.message}"));
    } catch (e) {
      yield (LoginFailure(message: e.toString()));
    }
  }
}
