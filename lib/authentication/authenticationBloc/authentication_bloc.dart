import 'package:notado/packages/packages.dart';
import 'package:notado/authentication/authenticationBloc/authentication_event.dart';
import 'package:notado/authentication/authenticationBloc/authentication_state.dart';
import 'package:notado/user_repository/user_Repository.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(null);

  @override
  // ignore: missing_return
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    try {
      if (event is AppStarted) {
        //TODO: implement USERREPOSITORY
        final isSignedIn = await _userRepository.isSignedIn();
        if (isSignedIn)
          yield Authenticated();
        else
          yield Unauthenticated();
      } else if (event is LoggedIn) {
        //TODO: return userUID also
        yield Authenticated();
      } else if (event is LoggedOut) {
        print('vkcxvkjxbcvjk.............bsdbv.......................hdsclchl');
        await _userRepository.signOut();
        print((await _userRepository.isSignedIn()).toString());
        yield Unauthenticated();
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
