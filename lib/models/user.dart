import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path_provider/path_provider.dart';

import 'dart:io';

import '../database_helper.dart';

// ignore: camel_case_types
class myUser {
  String firstName = '';
  String lastName = '';
  int employeeId = 0;
  int dateOfBirth = 0;
  int dateOfJoining = 0;
  String imagePath = "";

  CollectionReference users = FirebaseFirestore.instance.collection('baby');
  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  save() {
    addUser();
    uploadFile();
    print('saving user using a web service');
  }

  Future<void> uploadFile() async {
    File file = File(this.imagePath);

    print(this.imagePath);
      await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${this.employeeId}.jpg')
        .putFile(file);
  }

  Future<void> updateUser() {
    return rootBundle
        .load(imagePath.toString())
        .then((bytes) => bytes.buffer.asUint8List())
        .then((avatar) {
      return users
          .doc('${this.employeeId}')
          .update({'info.avatar': Blob(avatar)});
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  //final _imageLinkController = TextEditingController();

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return users
        .doc("${this.employeeId}")
        .set({
      'first_name': this.firstName,
      'last_name': this.lastName,
      'employee_id': this.employeeId
    })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<bool> isSQFLiteRecordAvailable(){

    return true as Future<bool>;
  }

  void insertToSQFLite() async {

    // reference to our single class that manages the database
    final dbHelper = DatabaseHelper.instance;

    // row to insert
    Map<String, dynamic> row = {
      DatabaseHelper.columnEmployeeId : this.employeeId,
      DatabaseHelper.columnFirstName : this.firstName,
      DatabaseHelper.columnLastName : this.lastName,
      DatabaseHelper.columnDOB  : this.dateOfBirth,
      DatabaseHelper.columnDOJ  : this.dateOfJoining,
      DatabaseHelper.columnImagePath : this.imagePath
    };

    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void populateProfile(){
      users
      .doc("${this.employeeId}")
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          this.firstName = document.data()['first_name'];
          this.lastName = document.data()['last_name'];
          this.employeeId = document.data()['employee_id'];
        } else {
          print('Document does not exist on the database');
        }
      });
  }

  Future<void> downloadImage() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    File downloadToFile = File('${appDocDir.absolute}/${this.employeeId}.jpg');

    print("This is where my image is gonna store...");
    print(downloadToFile);
      await firebase_storage.FirebaseStorage.instance
          .ref('images/${this.employeeId}.jpg')
          .writeToFile(downloadToFile);
  }
}