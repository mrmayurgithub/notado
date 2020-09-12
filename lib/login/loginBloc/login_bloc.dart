import 'package:notado/packages/packages.dart';
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
    // Login Button Pressed
    // if (event is LoginButtonPressed) {
    //   try {
    //     // yield LoginProgress when login process is being started
    //     yield (LoginInProgress());
    //     if (await _userRepository.isEmailVerified()) {
    //       await _userRepository.signInWithCredentials(
    //           email: event.email, password: event.password);
    //       yield LoginSuccess();
    //     } else
    //       print('Not verified');
    //     // yield login success event when user is loggedin
    //   } catch (e) {
    //     print(e.toString());
    //     yield LoginFailure(message: e.toString());
    //   }
    // }
    // Login With Google Pressed
    if (event is LoginWithGoogle) {
      // yield LoginProgress when login process is being started
      // yield LoginInProgress();
      try {
        await _userRepository.signInWithGoogle();

        //TODO:
        // yield login success event when user is loggedin
        yield LoginSuccess();
      } catch (e) {
        yield LoginFailure(message: e.toString());
      }
    }
    // // Sign Up Button Pressed
    // else if (event is SubmitButtonPressed) {
    //   // yield RegistrationProgress() until success or failure
    //   yield RegistrationProgress();
    //   try {
    //     await _userRepository.signUp(
    //       email: event.email,
    //       password: event.password,
    //     );
    //     yield NotVerified();
    //     //   yield NotVerified();
    //   } catch (e) {
    //     yield LoginFailure(message: e.toString());
    //   }
    // }
    // Check for Verification
    // else if (event is checkVerification) {
    //   yield RegistrationProgress();
    //   try {
    //     if (await _userRepository.isEmailVerified())
    //       yield RegistrationSuccess();
    //     else
    //       yield VerificationFailure();
    //   } catch (e) {
    //     print('faileddddddddddddddddddddddddddddddddddddddddd.....');
    //     print('Verification Failure  ' + e.toString());
    //     yield VerificationFailure();
    //   }
    // }
    // // Forget Password
    // else if (event is ForgetPassword) {
    //   //TODO: Implement forget password
    // }
  }
}
