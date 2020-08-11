import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:notado/login/bloc.dart';
import 'package:notado/user_repository/user_Repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  // UserRepository variable required to perform different functions
  UserRepository _userRepository;
  LoginBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(null);

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    try {
      if (event is LoginButtonPressed) {
        yield (LoginInProgress());
        //TODO: Implement Login with email and password
        await _userRepository.signInWithCredentials(
            email: event.email, password: event.password);
        final _currentUser = await FirebaseAuth.instance.currentUser();
      } else if (event is LoginWithGoogle) {
        yield LoginInProgress();
        _userRepository.signInWithGoogle();
      } else if (event is SubmitButtonPressed) {
        yield LoginInProgress();
        _userRepository.signUp(
          email: event.email,
          password: event.password,
        );
      } else if (event is ForgetPassword) {
        //TODO: Implement forget password
      }
    } catch (e) {
      yield (LoginFailure(message: e.toString()));
    }
  }
}
