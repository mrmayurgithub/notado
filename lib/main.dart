import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/authentication/authenticationBloc/authentication_event.dart';
import 'package:notado/authentication/authentication_bloc.dart';
import 'package:notado/packages/packages.dart';
import 'package:notado/screens/home/home_screen.dart';
import 'package:notado/screens/login/login_screen.dart';
import 'package:notado/screens/register/register_screen.dart';
import 'package:notado/screens/verification/verification.dart';
import 'package:notado/theme/themes.dart';
import 'package:notado/user_repository/user_Repository.dart';
import 'screens/splash/splash_screen.dart';

void main() {
  runApp(App());
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.blue, // navigation bar color
    statusBarColor: Colors.green, // status bar color
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  // UserRepository's instance is needed for AuthenticationBloc
  final UserRepository _userRepository = UserRepository();
  AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    //Initializing _authenticationBloc
    _authenticationBloc = AuthenticationBloc(userRepository: _userRepository);
    // _authenticationBloc.add(AppStarted());
    _authenticationBloc.add(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    // Disposing AuthenticationBloc instance when not needed
    _authenticationBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ListenableProvider<ThemeChanger>(
          create: (_) => ThemeChanger(
            ThemeData.light(),
          ),
        ),
      ],
      child: Builder(
        builder: (BuildContext context) {
          final _theme = Provider.of<ThemeChanger>(context).getTheme();
          return BlocProvider(
            create: (BuildContext context) => _authenticationBloc,
            child: MaterialApp(
              // routes: {
              //   './RegisterScreen': (context) =>
              //       RegisterScreen(userRepository: _userRepository),
              //   './LoginScreen': (context) =>
              //       LoginScreen(userRepository: _userRepository),
              //   './VerificationScreen': (context) =>
              //       VerificationScreen(userRepository: _userRepository),
              //   './HomeScreen': (context) => BlocProvider.value(
              //         value: _authenticationBloc,
              //         child: HomeScreen(userRepository: _userRepository),
              //       ),
              // },
              // theme: ThemeData.light().copyWith(
              //   appBarTheme: AppBarTheme().copyWith(color: Colors.purple),
              // ),
              theme: _theme,
              debugShowCheckedModeBanner: false,
              home: BlocBuilder(
                cubit: _authenticationBloc,
                builder: (BuildContext context, AuthenticationState state) {
                  if (state is Uninitialized) {
                    //Show the Splash Screen when app is being started
                    return SplashScreen();
                  } else if (state is Authenticated) {
                    //Show the Home Screen when the user is Authenticated
                    return HomeScreen(userRepository: _userRepository);
                  } else if (state is Unauthenticated) {
                    //Show the Login Screen when the user hasn't loggedin
                    return LoginScreen(userRepository: _userRepository);
                  }
                  return Container();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
