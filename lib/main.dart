import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:notes/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'config.dart';

void main()
{
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:first() ,));
}
class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  Database? database;
  List list=[];
  createdb()
  async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'demo.db');
    print(path);

     database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          // When creating the db, create the table
          await db.execute(
              'CREATE TABLE Test (id INTEGER PRIMARY KEY, title TEXT, content TEXT)');
        });
    list= await database!.rawQuery("select * from Test");
    setState((){});
  }

  @override
  void initState() {
    createdb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Super notes"),),
      body: ListView.builder(itemCount:list.length,itemBuilder: (context, index) {
        Map m=list[index];
        return OpenContainer(closedBuilder: (context, action) {
          return ListTile(
            title: Text("${m['title']}"),
            subtitle: Text("${m['content']}"),
          );
        }, openBuilder: (context, action) {
          return note(database!,"update",m);

        },transitionDuration: Duration(seconds: 1),);
      },
      ),
      floatingActionButton: OpenContainer(
        closedBuilder: (context, action) {
        return FloatingActionButton(onPressed: null,child: Icon(Icons.add),);
      },
      openBuilder: (context, action) {
          return note(database!, "insert");

      },),
    );
  }
}
