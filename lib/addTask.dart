import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddTask extends StatefulWidget {
  AddTask({this.email});
  final String email;
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  
  DateTime _dueDate = new DateTime.now();
  String _dateText = '';

  String newTask = '';
  String note = '';
  Future<Null> _selectDueDate(BuildContext context) async {
    final picked = await showDatePicker(
        context: context,
        initialDate: _dueDate,
        firstDate: DateTime(2018),
        lastDate: DateTime(2080));

    if(picked != null){
      setState(() {
        _dueDate=picked;
        _dateText = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _addData(){
    Firestore.instance.runTransaction((Transaction transaction) async{
      CollectionReference reference = Firestore.instance.collection('task');
      await reference.add({
          "email" : widget.email,
        "title": newTask,
        "duedate": _dueDate,
        "note": note,
      });
    });
    Navigator.pop(context);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateText = "${_dueDate.day}/${_dueDate.month}/${_dueDate.year}";
  }

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

                  image:  AssetImage("img/bg.jpg"), fit: BoxFit.cover
                //TODO: Poner imagen transparente
                //image:  AssetImage("img/bgpattern.png"), fit: BoxFit.cover
              ),
                color: Color.fromRGBO(3, 81, 57, 1.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Mis tareas",style: new TextStyle(
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
              onChanged: (String str){
                setState(() {
                  newTask=str;
                });
              },
              decoration: new InputDecoration(
                icon: Icon(Icons.dashboard),
                hintText: "Nueva Tarea",
                border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: new Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets. only(right: 16.0),
                  child: new Icon(Icons.date_range),
                ),
                new Expanded(child: Text("Due Date",  style: new TextStyle(fontSize: 22.2, color: Colors.black54),)),
               new FlatButton(
                   onPressed: ()=> _selectDueDate(context),
                   child: Text(_dateText,  style: new TextStyle(fontSize: 22.2, color: Colors.black54),)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (String str){
                setState(() {
                  note=str;
                });
              },
              decoration: new InputDecoration(
                  icon: Icon(Icons.note),
                  hintText: "Nota",
                  border: InputBorder.none
              ),
              style: new TextStyle(fontSize: 22.0, color: Colors.black),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
            IconButton(
                icon: Icon(Icons.check, size: 40.0,),
                onPressed: (){
                  _addData();
                }
            ),
            IconButton(
                icon: Icon(Icons.close, size: 40.0,),
                onPressed: (){
                  Navigator.pop(context);
                }
            )
            ],
            ),
          )
        ],
      ),
    );
  }
}