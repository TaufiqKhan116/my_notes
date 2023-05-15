import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'note.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList;

  @override
  Widget build(BuildContext context) {

    if(noteList == null){
      noteList = List();
    }

    return Scaffold(
      backgroundColor: Colors.amber[50],
      body: FutureBuilder(
        future: databaseHelper.getFavNoteList(),
        builder: (context, snapshot) {
          if(snapshot.hasError)
            print('Error');
          else if(snapshot.hasData){
            noteList = snapshot.data;
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async {
                  await Navigator.pushNamed(context, '/details',
                      arguments: noteList[index]);
                  setState(() {});
                },
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text('${noteList[index].title}')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite),
                            onPressed: () {
                              noteList[index].isFavourite = !noteList[index].isFavourite;
                              databaseHelper.updateNote(noteList[index]);
                              setState(() {});
                            },
                            color: noteList[index].isFavourite
                                ? Colors.red[700]
                                : Colors.black,
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
                                //NoteLab().deleteNote(noteList[index]);
                                databaseHelper.deleteNote(noteList[index].id);
                                noteList.removeAt(index);
                                setState(() {});
                              }),
                        ],
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: noteList.length,
          );
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 2,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          currentIndex: 1,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favourites'),
            ),
          ],
          onTap: (index) {
            if (index == 0)
              Navigator.pushReplacementNamed(context, '/');
            else
              print('Favourites');
          },
          backgroundColor: Colors.amber,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
