import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database/database_helper.dart';
import 'note.dart';

class Home extends StatefulWidget
{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

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
        future: databaseHelper.getNoteList(),
        builder: (context, snapshot){
          if(snapshot.hasError)
            print('Error');
          else if(snapshot.hasData){
            noteList = snapshot.data;
          }

          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () async{
                  await Navigator.pushNamed(context, '/details', arguments: noteList[index]);
                  setState(() {});
                },
                child: Card(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: Text('${noteList[index].title}')
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite),
                            onPressed: (){
                              noteList[index].isFavourite = !noteList[index].isFavourite;
                              databaseHelper.updateNote(noteList[index]);
                              setState(() {
                                print(noteList[index].isFavourite);
                              });
                            },
                            color: noteList[index].isFavourite? Colors.red[700] : Colors.black,
                          ),
                          IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: (){
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
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              title: Text('Favourites'),
            ),
          ],
          onTap: (index){
            if(index == 0) print('Home');
            else Navigator.pushReplacementNamed(context, '/favourites');
          },
          backgroundColor: Colors.amber,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
         await Navigator.pushNamed(context, '/details');
         setState(() {
         });
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}