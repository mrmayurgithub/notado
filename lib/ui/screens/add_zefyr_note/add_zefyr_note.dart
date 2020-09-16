import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notado/global/providers/zefyr_providers.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/ui/screens/add_zefyr_note/bloc/zefyr_bloc.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';
import 'package:zefyr/zefyr.dart';

// class ZefyrNote extends StatefulWidget {
//   @override
//   _ZefyrNoteState createState() => _ZefyrNoteState();
// }

// class _ZefyrNoteState extends State<ZefyrNote> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => ZefyrBloc(),
//       child: ZefyrMainPage(),
//     );
//   }
// }

// class ZefyrMainPage extends StatefulWidget {
//   final Note note;
//   const ZefyrMainPage({Key key, this.note}) : super(key: key);
//   @override
//   _ZefyrMainPageState createState() => _ZefyrMainPageState();
// }

// class _ZefyrMainPageState extends State<ZefyrMainPage> {
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ZefyrBloc, ZefyrState>(
//       listener: (context, state) {
//         if (state is ZefyrError) {
//           Toast.show(state.message.toString(), context);
//         }
//         if (state is UpdateSuccess) {
//           Navigator.of(context).pop();
//           Toast.show('Updated', context);
//         }
//         if (state is CreateSuccess) {}
//         if (state is CreateLoading) {
//           Toast.show('Creating note...', context);
//         }
//         if (state is UpdateLoading) {
//           Toast.show('Updating...', context);
//         }
//         if (state is Cancelled) {}
//       },
//       builder: (context, state) {
//         return Consumer<NoteModeProvider>(
//           builder: null,
//         );
//       },
//     );
//   }
// }
class ZefyrNote extends StatefulWidget {
  final NotusDocument contents;
  final String id;
  final String title;
  final String date;
  final String searchKey;
  ZefyrNote({
    this.contents,
    this.date,
    this.id,
    this.searchKey,
    this.title,
  });

  @override
  _ZefyrNoteState createState() => _ZefyrNoteState();
}

class _ZefyrNoteState extends State<ZefyrNote> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
