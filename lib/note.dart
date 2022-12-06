import 'package:flutter/material.dart';
import 'package:notes/main.dart';
import 'package:sqflite/sqflite.dart';

class note extends StatefulWidget {

  Database?database;
  String method;
  Map?m;
  note(this.database,this.method,[this.m]);

  @override
  State<note> createState() => _noteState();
}

class _noteState extends State<note> {
  TextEditingController t1 =TextEditingController();
  TextEditingController t2 =TextEditingController();

  @override
  void initState() {
    if(widget.method=="update")
      {
        print(widget.m);
        t1.text=widget.m!['title'];
        t2.text=widget.m!['content'];

      }
  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: TextField(controller: t1),actions: [
        IconButton(onPressed: () async {
          String a=t1.text;
          String b=t2.text;
          if(widget.method=="insert")
            {
            await  widget.database!.transaction((txn) async {
              int id1 = await txn.rawInsert(
                  'INSERT INTO Test(id, title, content) VALUES(null, "$a","$b")');
              print('inserted1: $id1');
              if(id1>=1)
                {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return first();
                  },));
                }

              });
            }
          else
            {
            await widget.database!.transaction((txn) async {
            String q ="update Test set title ='$a',content='$b' where id=${widget.m!['id']}";
            int id1= await txn.rawUpdate(q);
            print('update no of row:$id1');
                if(id1==1)
                  {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return first();
                    },));
                  }
            });
                }



        }, icon: Icon(Icons.save)),
        PopupMenuButton(itemBuilder: (context) => [
          PopupMenuItem(onTap:() async {
            int count = await widget.database!.rawDelete('DELETE FROM Test WHERE id=${widget.m!['id']}');
            if(count==1)
              {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                  return first();
                },));
              }

          },child: Icon(Icons.delete,color: Colors.black,))
        ])
      ],),
      body: TextField(controller: t2,),
    );
  }
}
