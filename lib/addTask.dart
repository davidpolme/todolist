import 'package:flutter/material.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  Widget build(BuildContext context) {
    return new Material(
      child: Column(
        children: <Widget>[
          Container(
            height: 200.0,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:  AssetImage("img/bgpattern.png"), fit: BoxFit.cover
              ),
                color: Color.fromRGBO(3, 81, 57, 1.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Añadir tarea",style: new TextStyle(
                color: Colors.white,
                fontSize: 30.0,
                letterSpacing: 1.0,
                fontFamily: "Segoe"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Text("Añadir Tarea", style: new TextStyle( fontSize: 24.0, color: Colors.white),),
                ),
                Icon(Icons.list, color: Colors.white, size: 30.0,),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: new InputDecoration(
                icon: Icon(Icons.dashboard),
                hintText: "Nueva Tarea",
                border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          )
        ],
      ),
    );
  }
}