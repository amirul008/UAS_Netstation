import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FirebaseAuthService {
  FirebaseAuth _authService = FirebaseAuth.instance;
  Future<User?> signUpWithEmailandPassword(
      String email, String password, String username, BuildContext context) async {
    try {
      UserCredential credential = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String uid = credential.user?.uid ?? "";
      print("UID: $uid");

      var response = await Dio().post(
        'https://uas-net-l-default-rtdb.asia-southeast1.firebasedatabase.app/users.json',
        data: {
          'uid': uid,
          'username': username,
          'photo': '',
        },
      );

      if (response.statusCode == 200) {
        print("Response Data: ${response.data}");
        return credential.user;
      } else {
        print("Failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    }
  }


  Future<User?> loginWithEmailandPassword(
      String email, password, BuildContext context) async {
    try {
      UserCredential credential = await _authService.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      final String errorMessage = e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ), // SnackBar
      );
    }
  }
}
