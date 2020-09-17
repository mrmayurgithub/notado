import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/auth/auth_bloc.dart';
import 'package:notado/global/providers/zefyr_providers.dart';
import 'package:notado/ui/screens/home_page/home_screen.dart';
import 'package:notado/ui/screens/login_page/login_screen.dart';
import 'package:notado/ui/screens/settings_page/settings_screen.dart';
import 'package:notado/ui/screens/splash_page/splash_Screen.dart';
import 'package:notado/ui/screens/trash_page/trash_screen.dart';
// import 'package:notado/ui/themes/theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  // Bloc.observer = SimpleBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      BlocProvider<AuthenticationBloc>(
        create: (context) => AuthenticationBloc()..add(AppStarted()),
        child: App(),
      ),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ListenableProvider(
        //   create: (_) => ThemeChanger(appTheme.getLightTheme()),
        // ),
        ChangeNotifierProvider<SelectedTileProvider>.value(
          value: SelectedTileProvider(),
        ),
        ChangeNotifierProvider<NoteModeProvider>.value(
          value: NoteModeProvider(),
        ),
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthenticationBloc _authenticationBloc;
  // var _theme;
  // Future<void> loadSavedThemeData() async {
  //   var _themechangerProvider = Provider.of<ThemeChanger>(context);
  //   SharedPreferences _prefs = await SharedPreferences.getInstance();
  //   _theme = _prefs.get('themeNotado') ?? ThemeData.light();
  //   _themechangerProvider.setTheme(_theme);
  //   _prefs.setString('themeNotado', _theme);
  // }

  @override
  void initState() {
    // loadSavedThemeData();
    _authenticationBloc = AuthenticationBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _authenticationBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {},
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          'Home': (context) => HomeScreen(),
          'Trash': (context) => TrashScreen(),
          'Login': (context) => LoginScreen(),
          'Settings': (context) => SettingsScreen(),
        },
        // theme: _theme ?? ThemeData.light(),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          cubit: _authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is UninitializedAuth) {
              return LoginScreen();
            } else if (state is AuthenticatedAuth) {
              return HomeScreen();
            } else if (state is UnauthenticatedAuth) {
              return LoginScreen();
            }
            return Container();
          },
        ),
      ),
    );
  }
}
