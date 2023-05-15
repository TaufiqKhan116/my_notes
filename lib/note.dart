import 'package:floor/floor.dart';
import 'package:uuid/uuid.dart';

@entity
class Note
{
  @primaryKey
  String id;
  String title;
  String description;
  bool isFavourite;

  Note(this.title, this.description)
  {
    id = Uuid().v1();
    isFavourite = false;
  }

  Map<String, dynamic> toMap()
  {
    Map<String, dynamic> map = Map();

    map['id'] = id;
    map['title'] = title;
    map['description'] = description;
    map['isFav'] = isFavourite.toString();

    return map;
  }

  Note.fromMapObject(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.isFavourite = map['isFav'] == 'true'? true : false;
  }
}