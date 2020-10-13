import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../GetUserName.dart';
import '../models/user.dart';
import '../database_helper.dart';

class FirstFragment extends StatefulWidget {
  @override
  _FirstFragmentState createState() => _FirstFragmentState();
}

class _FirstFragmentState extends State<FirstFragment> {
  final _formKey = GlobalKey<FormState>();
  final _user = User();
  var allRows;

  Future<String> _employee_id;

  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {

    CollectionReference users = FirebaseFirestore.instance.collection('baby');

    Future<void> findUser() async{
      // Call the user's CollectionReference to add a new user
      final docRef = users.doc("${_user.employeeId}");

      print(docRef.get().toString());
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
                              InputDecoration(labelText: 'Employee Id'),
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Please enter Employee Id.';
                                }
                              },
                              onSaved: (val) =>
                                  setState(() => _user.employeeId = int.parse(val))),
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 16.0),
                              child: RaisedButton(
                                  onPressed: () {
                                    final form = _formKey.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      _searchEmployee();
                                      findUser();
                                      _showDialog(context);
                                    }
                                  },
                                  child: Text('Search'))),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical:16.0, horizontal: 16.0),
                            child:  FutureBuilder<String>(
                              future: _employee_id, // a previously-obtained Future<String> or null
                              builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                                List<Widget> children;

                                if (snapshot.hasData) {

                                }else if (snapshot.hasError){

                                }else{

                                }
                                return Center(
                                  child: Text(snapshot.data.toString()),
                                );
                              },
                            ),

                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical:16.0, horizontal: 16.0),
                            child:  GetUserName(_user.employeeId.toString())
                          )
            ])))));
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Searching for Employee.')));
  }

  Future<void> _searchEmployee() async {
    _employee_id =  _findEmployee();
  }

  Future<String> _findEmployee() async{
    final allRows = await dbHelper.queryEmployee(_user.employeeId);
    // while(_user.employeeId != allRows[0][DatabaseHelper.columnEmployeeId]){
    //   print("waiting");
    // }
    print("sending reply '${allRows[0][DatabaseHelper.columnFirstName]}'");
    return allRows[0][DatabaseHelper.columnFirstName];
  }
}


