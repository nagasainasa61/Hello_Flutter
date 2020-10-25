

import 'package:Hello_Flutter/signInWithGoogle.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:provider/provider.dart';
import 'GetUserName.dart';
import 'auth/authentication_service.dart';
import 'camera_helper.dart';
import 'models/user.dart';

class SinglePageHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Named Routes Demo',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => HomeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/add_employee': (context) => AddEmployeeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/find_employee': (context) => FindEmployeeScreen(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/sign_in': (context) => SignInScreen(),
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('First Screen'),
      ),
      body: Center(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children:<Widget>[
            Container(
              child: RaisedButton(
                child: Text('Add Employee'),
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/add_employee');
                },
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text('Find Employee'),
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/find_employee');
                },
              ),
            ),
            Container(
              child: RaisedButton(
                child: Text('Sign In'),
                onPressed: () {
                  // Navigate to the second screen using a named route.
                  Navigator.pushNamed(context, '/sign_in');
                },
              ),
            ),
          ]
        ),
      ),
    );
  }
}

class AddEmployeeScreen extends StatefulWidget{
  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {

  String imageResult = "Image_Null";

  _navigateAndDisplaySelection(BuildContext context) async {

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    final firstCamera = cameras.first;
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.

    imageResult = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      )),
    );

    // After the Selection Screen returns a result, hide any previous snackbars
    // and show the new result.
    Scaffold.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text("$imageResult")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Employee Screen"),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:[
                  Container(
                    child: RaisedButton(
                      onPressed: () {
                        // Navigate back to the first screen by popping the current route
                        // off the stack.
                        Navigator.pop(context);
                      },
                      child: Text('Go back!'),
                    ),
                  ),
                  Container(
                      child: RaisedButton(
                        onPressed: (){
                          _navigateAndDisplaySelection(context);
                          print("Button Pressed!");
                        },
                        child: Text('Take Image'),
                      )
                  )
                ]
              ),
            ),
          ],
        )
      )
    );
  }
}

class FindEmployeeScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _FindEmployeeScreenState();
}

class _FindEmployeeScreenState extends State<FindEmployeeScreen> {
  final _formKey1 = GlobalKey<FormState>();
  final _user = myUser();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Find Employee'),
        ),
        body: Container(
            padding:
            const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Builder(
                builder: (context) => Form(
                    key: _formKey1,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                                    final form = _formKey1.currentState;
                                    if (form.validate()) {
                                      form.save();
                                      //_user.populateProfile();
                                      _user.downloadImage();
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => FoundEmployeeDisplayScreen(
                                        // Pass the appropriate camera to the TakePictureScreen widget.
                                        _user,
                                      )),

                                      );
                                    }
                                    else{
                                      print("form not validated...");
                                    }
                                  },
                                  child: Text('Search'))),
                          /*Container(
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

                          ),*/
                          // Container(
                          //     padding: const EdgeInsets.symmetric(
                          //         vertical:16.0, horizontal: 16.0),
                          //     child:  GetUserName(_user.employeeId.toString())
                          // ),
                        ])))));
  }
}

// ignore: must_be_immutable
class FoundEmployeeDisplayScreen extends StatefulWidget{
  var user = myUser();

  FoundEmployeeDisplayScreen(this.user) ;

  @override
  _FoundEmployeeDisplayScreenState createState() => _FoundEmployeeDisplayScreenState(this.user);
}

class _FoundEmployeeDisplayScreenState extends State<FoundEmployeeDisplayScreen>{
  final _user = myUser();

  var user = myUser();

  _FoundEmployeeDisplayScreenState(this.user);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Found Employee Screen"),
        ),
        body: Center(
            child: GetUserName(user.employeeId.toString())
        )
    );
  }

}

class SignInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                signInWithGoogle();
              },
              child: Text("Sign Up"),
            ),
            RaisedButton(
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                // off the stack.
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}

class SignOutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In Screen"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RaisedButton(
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              },
              child: Text("Sign out"),
            ),
            RaisedButton(
              onPressed: () {
                // Navigate back to the first screen by popping the current route
                // off the stack.
                Navigator.pop(context);
              },
              child: Text('Go back!'),
            ),
          ],
        ),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class AddUserWithImageDisplayScreen extends StatefulWidget {
  final String imagePath;

  AddUserWithImageDisplayScreen({this.imagePath}) ;

  @override
  _AddUserWithImageDisplayScreenState createState() => _AddUserWithImageDisplayScreenState(imagePath: this.imagePath);
}

// A widget that displays the picture taken by the user.
class _AddUserWithImageDisplayScreenState extends State<AddUserWithImageDisplayScreen> {
  final String imagePath;
  final _formKey = GlobalKey<FormState>();
  final _user = myUser();

  _AddUserWithImageDisplayScreenState({this.imagePath}){
    _user.imagePath = this.imagePath;
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: AppBar(
          title: Text("Add User"),
        ),
        body: new Container(
          color: Colors.white,
          child: new ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 200.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    width: 180.0,
                                    height: 140.0,
                                    // decoration: new BoxDecoration(
                                    //   shape: BoxShape.circle,
                                    // )
                                    child: ClipRect(
                                      child: new OverflowBox(
                                        alignment: Alignment.center,
                                        child: FittedBox(
                                          fit: BoxFit.fitWidth,
                                          child: Image.file(File(imagePath)),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            // Padding(
                            //     padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            //     child: new Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: <Widget>[
                            //         new CircleAvatar(
                            //           backgroundColor: Colors.red,
                            //           radius: 25.0,
                            //           child: new Icon(
                            //             Icons.camera_alt,
                            //             color: Colors.white,
                            //           ),
                            //         )
                            //       ],
                            //     )),
                          ]),
                        ),
                      ],
                    ),
                  ),
               Container(
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
                                  }else{
                                    print("something got messed >..");
                                  }
                                  return null;
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
                                        if (form.validate() && imagePath != null) {
                                          form.save();
                                          _user.imagePath = imagePath;
                                          _user.save();
                                          _showDialog(context);
                                          form.reset();
                                        }else{
                                          print("Image result is NULL");
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(content: Text('Please capture the Image of the employee')));
                                        }
                                      },
                                      child: Text('Save'))),
                            ]))))
                ],
              ),
            ],
          ),
        )
    );
  }

  _showDialog(BuildContext context) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Submitting form')));
  }
}



