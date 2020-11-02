import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/global/constants.dart';
import 'package:notado/ui/components/CircularProgress.dart';
import 'package:notado/ui/components/google_login_button.dart';
import 'package:notado/ui/screens/login_page/bloc/login_bloc.dart';
import 'package:notado/ui/components/snackbar.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoginPage(),
      ),
    );
  } 
}

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) async {
          if (state is LoginFailure) {
            Navigator.pop(context);
            context.showSnackBar(state.message);
          }
          if (state is LoginSuccess) {
            Navigator.of(context).pop();
            await context.showSnackBar('Login Successfull');
            Navigator.of(context).pushReplacementNamed('Home');
          }
          if (state is LoginInProgress) {
            showProgress(context);
          }
        },
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Welcome",
                  style: Theme.of(context).textTheme.headline1.copyWith(
                        fontSize: SizeConfig.screenHeight * 0.042249047,
                      ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight * 0.036689962,
                ),
                GoogleButton(
                  title: 'Continue with Google',
                  onPressed: () {
                    BlocProvider.of<LoginBloc>(context).add(LoginWithGoogle());
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Google Sign In"),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
          // return ListView(
          //   children: [
          //     Container(
          //       margin: EdgeInsets.symmetric(
          //         horizontal: SizeConfig.screenWidth * 0.072916667,
          //       ),
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.end,
          //         mainAxisSize: MainAxisSize.min,
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Text(
          //             "Welcome",
          //             style: Theme.of(context).textTheme.headline1.copyWith(
          //                   fontSize: SizeConfig.screenHeight * 0.042249047,
          //                 ),
          //           ),
          //           SizedBox(
          //             height: SizeConfig.screenHeight * 0.036689962,
          //           ),
          //           GoogleButton(
          //             title: 'Continue with Google',
          //             onPressed: () {
          //               BlocProvider.of<LoginBloc>(context)
          //                   .add(LoginWithGoogle());
          //               Scaffold.of(context).showSnackBar(
          //                 SnackBar(
          //                   content: Text("Google Sign In"),
          //                 ),
          //               );
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}
