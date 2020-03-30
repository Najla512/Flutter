import 'package:flutter/material.dart';
import 'package:my_notes/note_list.dart';
import 'models/note.dart';
import 'dart:async';
import 'package:my_notes/utils//database_helper.dart';
import 'package:intl/intl.dart';
import 'Color.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
// ignore: must_be_immutable
class NoteDetail extends StatefulWidget {

  String appBarTitle;
  final Note note;
  NoteDetail(this.note,this.appBarTitle,);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note,this.appBarTitle);
    State<StatefulWidget> createState() {

      return NoteDetailState(this.note, this.appBarTitle);
    }
  }
}


class NoteDetailState extends State<NoteDetail> {


  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Note note;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  NoteDetailState(this.note, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle=Theme.of(context).textTheme.title;

    titleController.text = note.title;
    descriptionController.text = note.description;

    return WillPopScope(

    onWillPop:(){
        // Write some code to control things, when user press Back navigation button in device navigationBar
        moveToLastScreen();
      },

      child:Scaffold(
        backgroundColor: BgColor,

        appBar: AppBar(
        title: Text(appBarTitle),
          backgroundColor: BgColor,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.brightness_6),
                color: Colors.white,
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false).swapTheme();
                },
              )
            ],


leading: IconButton(icon: Icon(Icons.arrow_back),
    onPressed:() {
      moveToLastScreen();
    }
),
      ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),

          child: ListView(

            children: <Widget>[
              Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleController,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,

                  ),
                  onChanged: (value) {
                    debugPrint('Something changed in Title Text Field');
                    updateTitle();
                  },
                  decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),


                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                      )
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descriptionController,
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
                  onChanged: (value) {
                    debugPrint('Something changed in Description Text Field');
                    updateDescription();
                  },
                  decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: Colors.white
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                      ),

                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                          style:  TextStyle(
                              color: BgColor
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Save button clicked");
                            _save();
                          });

                        },
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),

                    ),


                    Container(width: 5.0,),

                    Expanded(
                      child: RaisedButton(
                        color: Colors.white,
                        textColor: Colors.black,
                        child: Text(
                          'Delete',
                          textScaleFactor: 1.5,
                          style: TextStyle(
                              color: BgColor

                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            debugPrint("Delete button clicked");
                            _delete();
                          });
                        },
                        shape:  RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),

                  ],
                ),
              ),

            ],
          ),
        ),

      ));
  }


    void moveToLastScreen() {
    Navigator.pop(context,true);

  }

  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'High':
        note.priority = 1;
        break;
      case 'Low':
        note.priority = 2;
        break;
    }
  }



  // Update the title of Note object
  void updateTitle(){
    note.title = titleController.text;
  }

  // Update the description of Note object
  void updateDescription() {
    note.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    note.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (note.id != null) {  // Case 1: Update operation
      result = await helper.updateNote(note);
    } else { // Case 2: Insert Operation
      result = await helper.insertNote(note);
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Note Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Note');
    }

  }

  void _delete() async {

    moveToLastScreen();

    // Case 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (note.id == null) {
      _showAlertDialog('Status', 'No Note was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Note Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Note');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}
