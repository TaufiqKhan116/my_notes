import 'package:floor/floor.dart';
import 'note.dart';

class NoteLab
{
  static final NoteLab noteLab = NoteLab._internal();
  List<Note> noteList = List();

  factory NoteLab()
  {
    return noteLab;
  }

  NoteLab._internal();

  void addNote(Note note) => noteList.add(note);
  List<Note> getNotes() => noteList;
  Future<List<Note>> getFavNotes()
  {
    return Future((){
      List<Note> notes = List();
      for(Note note in noteList){
        if(note.isFavourite){
          notes.add(note);
        }
      }
      return notes;
    });
  }

  void deleteNote(Note note)
  {
    noteList.remove(note);
  }
}