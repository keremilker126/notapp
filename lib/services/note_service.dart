import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';

class NoteService {
  static late Isar isar;

  // DB başlat
  static Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();

    isar = await Isar.open(
      [NoteSchema],
      directory: dir.path,
    );
  }

  // Not ekle
  static Future<void> addNote(Note note) async {
    await isar.writeTxn(() async {
      await isar.notes.put(note);
    });
  }

  // Notları getir
  static Future<List<Note>> getNotes() async {
    return await isar.notes.where().sortByDateDesc().findAll();
  }

  // Not sil
  static Future<void> deleteNote(int id) async {
    await isar.writeTxn(() async {
      await isar.notes.delete(id);
    });
  }
}