import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:todolist/addTask.dart';
import 'package:todolist/editTask.dart';
import 'package:todolist/main.dart';

class MyTask extends StatefulWidget {
  MyTask({this.user, this.googleSignIn});

  final FirebaseUser user;
  final GoogleSignIn googleSignIn;

  @override
  _MyTaskState createState() => _MyTaskState();
}

class _MyTaskState extends State<MyTask> {
  void _signOut() {
    AlertDialog alertDialog = new AlertDialog(
      content: Container(
        height: 250.0,
        child: Column(
          children: <Widget>[
            ClipOval(
              child: new Image.network(widget.user.photoUrl),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "¿Salir?",
                style: new TextStyle(fontSize: 16.0),
              ),
            ),
            new Divider(),
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    widget.googleSignIn.signOut();
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext contet) => new MyHomePage()));
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.check),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                      ),
                      Text("Si")
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    children: <Widget>[
                      Icon(Icons.close),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                      ),
                      Text("Cancelar")
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    showDialog(context: context, child: alertDialog);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (BuildContext context) => new AddTask(
                    email: widget.user.email,
                  )));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(3, 81, 57, 1.0),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: new BottomAppBar(
        elevation: 20.0,
        color: Color.fromRGBO(3, 81, 57, 1.0),
        child: ButtonBar(
          children: <Widget>[],
        ),
      ),
      body: new Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 160.0),
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("task")
                  .where("email", isEqualTo: widget.user.email)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData)
                  return new Container(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                return new TaskList(
                  document: snapshot.data.documents,
                );
              },
            ),
          ),
          Container(
            height: 170.0,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(

                    // TODO: poner imagen de fondo

                    image: new AssetImage("img/bgpattern.png"),
                    fit: BoxFit.cover),
                boxShadow: [
                  new BoxShadow(color: Colors.black, blurRadius: 8.0)
                ],
                color: Color.fromRGBO(3, 81, 57, 100.0)),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 60.0,
                        height: 60.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: new NetworkImage(widget.user.photoUrl),
                              fit: BoxFit.cover),
                        ),
                      ),
                      new Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 18.0),
                          child: new Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                "Bienvenido",
                                style: new TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                              new Text(
                                widget.user.displayName,
                                style: new TextStyle(
                                    fontSize: 24.0, color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ),
                      new IconButton(
                        icon: Icon(
                          Icons.exit_to_app,
                          color: Colors.white,
                          size: 30.0,
                        ),
                        onPressed: () {
                          _signOut();
                        },
                      )
                    ],
                  ),
                ),
                new Text(
                  "Mis Tareas",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 30.0,
                      letterSpacing: 1.0,
                      fontFamily: "Segoe"),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  TaskList({this.document});

  final List<DocumentSnapshot> document;

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext contex, int i) {
        String title = document[i].data['title'].toString();
        String note = document[i].data['note'].toString();
        String duedate = document[i].data['duedate'].toString();

        return Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          title,
                          style:
                              new TextStyle(fontSize: 20.0, letterSpacing: 1.0),
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.date_range,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            duedate,
                            style: new TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.note,
                              color: Colors.green,
                            ),
                          ),
                          Expanded(
                              child: Text(
                            note,
                            style: new TextStyle(
                              fontSize: 18.0,
                            ),
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            /* new IconButton(
                  icon: Icon(Icons.edit, color: Colors.green),
                  onPressed: () {
                    Navigator.of(context).push(new MaterialPageRoute(
                        builder: (BuildContext context)=> new EditTask())
                    );
                  },
                  )*/
            ] ,
          ),
        );
      },
    );
  }
}
