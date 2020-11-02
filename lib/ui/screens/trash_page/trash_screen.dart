import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/global/providers/zefyr_providers.dart';
import 'package:notado/ui/components/CircularProgress.dart';
import 'package:notado/ui/screens/trash_page/bloc/trash_bloc.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:notado/ui/components/snackbar.dart';

class TrashScreen extends StatefulWidget {
  @override
  _TrashScreenState createState() => _TrashScreenState();
}

class _TrashScreenState extends State<TrashScreen>
    with SingleTickerProviderStateMixin {
  var h = 1001.0694778740428;
  final w = 462.03206671109666;
  final padV60 = 60 / 1001.0694778740428;
  final padH10 = 10 / 462.03206671109666;
  AnimationController viewController;

  Future<bool> _checkConnection() async {
    if (await DataConnectionChecker().hasConnection) {
      return true;
    } else
      return false;
  }

  Future<bool> _onBackPressed() async {
    DateTime currentBackPressTime;
    var deTl = Provider.of<SelectedTileProvider>(context);
    if (deTl.selectedOnes.length == 0) {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Toast.show('Press again to exit', context);
        return Future.value(false);
      }
      return Future.value(true);
    } else {
      Future.delayed(Duration(milliseconds: 1), () {
        deTl.clearSelectedOnes();
        return false;
      });
    }
  }

  @override
  void initState() {
    viewController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrashBloc, TrashState>(
      listener: (context, state) {
        if (state is TrashInitial) {
          return Center(child: CircularProgressIndicator());
        }
        if (state is TrashError) {
          context.showSnackBar(state.message);
        }
        if (state is TrashLoading) {
          showProgress(context);
        }
        if (state is TrashSuccess) {
          Navigator.of(context).pop();
          BlocProvider.of<TrashBloc>(context).add(TrashNotesRequested());
        }
      },
    );
  }
}
