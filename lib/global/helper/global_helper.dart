import 'package:notado/global/database_helper/database_helper.dart';
import 'package:notado/models/note_model/note_model.dart';
import 'package:notado/models/user_model.dart';
import 'package:notado/services/userRepository/user_repository.dart';

UserModel _globalUser = UserModel();
List<Note> _savedNotes = [];
List<Note> _deletedNotes = [];

Future<void> _apiStart() async {
  UserRepository _userRepository = UserRepository();
  await getUserModel(_userRepository);
  await getNotesFromNotesOBName();
  await getNotesFromNotesOBDate();
}

Future<void> _disposeApi() async {
  _savedNotes = [];
  _deletedNotes = [];
}

Future<void> getUserModel(UserRepository ur) async {
  String _uid = await ur.getUID();
  String _email = await ur.getUserEmail();
  String _photoUrl = await ur.getPhotoUrl();
  String _displayName = await ur.getDisplayName();
  _globalUser = UserModel(
    uid: _uid,
    email: _email,
    photoUrl: _photoUrl,
    displayName: _displayName,
  );
}

Future<List<Note>> getNotesFromNotesOBName() async {
  _savedNotes = await DatabaseHelper.notesZefyrFromNotesOrderByTitle();
}

Future<List<Note>> getNotesFromNotesOBDate() async {
  _deletedNotes = await DatabaseHelper.notesZefyrFromNotesOrderByDate();
}

UserModel get globalUser => _globalUser;
List<Note> get savedNotes => _savedNotes;
List<Note> get deletedNotes => _deletedNotes;
Future<void> get initializeApi => _apiStart();
Future<void> get disposeApi => _disposeApi();
