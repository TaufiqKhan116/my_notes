import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/database/database_helper.dart';
import 'package:my_notes/note.dart';
import 'package:my_notes/note_lab.dart';

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  TextEditingController titleTextController = TextEditingController();
  TextEditingController descriptionTextController = TextEditingController();


  @override
  Widget build(BuildContext context) {

    DatabaseHelper databaseHelper = DatabaseHelper();

    Note args = ModalRoute.of(context).settings.arguments;
    bool flag = false;
    if(args != null){
      flag = true;
      titleTextController.text = args.title;
      descriptionTextController.text = args.description;
    }

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.amber,
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: ()
          async {
            if(flag){
              args.title = titleTextController.text;
              args.description = descriptionTextController.text;
              databaseHelper.updateNote(args);
              Navigator.pop(context);
              return;
            }

            //NoteLab().addNote(Note(titleTextController.text, descriptionTextController.text));
            int result = await databaseHelper.insertNote(Note(titleTextController.text, descriptionTextController.text));
            if(result == 0)
              print('Error saving');
            Navigator.pop(context);
          })
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 5, bottom: 5),
              child: TextField(
                controller: titleTextController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                  icon: Icon(Icons.view_headline),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 30, right: 5),
                child: Card(
                  color: Colors.amber[50],
                  child: TextField(
                    cursorHeight: 30,
                    controller: descriptionTextController,
                    maxLines: 40,
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
