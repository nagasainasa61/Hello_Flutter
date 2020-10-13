import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import '../database_helper.dart';

class SecondFragment extends StatefulWidget {
  @override
  _SecondFragmentState createState() => _SecondFragmentState();
}

class _SecondFragmentState extends State<SecondFragment> {
  final _formKey = GlobalKey<FormState>();
  final _user = myUser();

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('baby');

    Future<void> addUser() {
      // Call the user's CollectionReference to add a new user
      return users
          .doc("${_user.employeeId}").set({
        'first_name': _user.firstName,
        'last_name': _user.lastName,
        'employee_id': _user.employeeId
      })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));
    }

    return Scaffold(
        body: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextFormField(
                            decoration:
                            InputDecoration(labelText: 'First name'),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter your first name';
                              }
                            },
                            onSaved: (val) =>
                                setState(() => _user.firstName = val),
                          ),
                          TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Last name'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your last name.';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _user.lastName = val)),
                          TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Employee Id'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your Employee Id.';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _user.employeeId = int.parse(val))),
                          TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Date of Birth'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your Date of Birth.';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _user.dateOfBirth = int.parse(val))),
                          TextFormField(
                              decoration:
                              InputDecoration(labelText: 'Date of Joining'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter your Date of Joining.';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _user.dateOfJoining = int.parse(val))),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      _user.save();
                                      _insert(_user);
                                      addUser();
                                      _showDialog(context);
                                    }
                                  },
                                  child: Text('Save'))),
                        ])))));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }


  void _insert(myUser user) async {

    //CollectionReference users = FirebaseFirestore.instance.collection('users');

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnEmployeeId : user.employeeId,
      DatabaseHelper.columnFirstName : user.firstName,
      DatabaseHelper.columnSecondName : user.lastName,
      DatabaseHelper.columnDOB  : user.dateOfBirth,
      DatabaseHelper.columnDOJ  : user.dateOfJoining
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }
}