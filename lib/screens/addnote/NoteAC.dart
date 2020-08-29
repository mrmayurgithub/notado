// import 'package:flutter/material.dart';
// import 'package:notado/packages/packages.dart';

// class NoteAC extends StatefulWidget {
//   @override
//   _NoteACState createState() => _NoteACState();
// }

// class _NoteACState extends State<NoteAC> {
//   final TextEditingController _titleController = TextEditingController();
//   final FocusNode _zefyrfocusNode = FocusNode();
//   final FocusNode _titleFocus = FocusNode();
//   ZefyrController _zefyrController;

//   _formDelta() async{
//     final Delta delta = Delta()..insert('\n')..delete(0)..e
//   }

//   @override
//   void initState() {
//     _zefyrController = ZefyrController(NotusDocument.fromDelta(delta));
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ZefyrScaffold(
//       child: ZefyrEditor(
//         controller: _zefyrController,
//         focusNode: _zefyrfocusNode,
//       ),
//     );
//   }
// }
