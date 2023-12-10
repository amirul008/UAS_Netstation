import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FirebaseAuthController {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      return null;
    }
  }

  Future<User?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
    required String country,
    required String phoneNumber,
    BuildContext? context,
  }) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
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
          'country': country,
          'phoneNumber': phoneNumber,
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
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  Future<User?> updateUserData({
    required String uid,
    String? username,
    String? photo,
    String? country,
    String? phoneNumber,
    BuildContext? context,
  }) async {
    try {
      Map<String, dynamic> requestData = {};

      if (username != null) {
        requestData['username'] = username;
      }

      if (photo != null) {
        requestData['photo'] = photo;
      }

      if (country != null) {
        requestData['country'] = country;
      }

      if (phoneNumber != null) {
        requestData['phoneNumber'] = phoneNumber;
      }

      var response = await Dio().put(
        'https://uas-net-l-default-rtdb.asia-southeast1.firebasedatabase.app/users/$uid.json',
        data: requestData,
      );

      if (response.statusCode == 200) {
        print("Update Response Data: ${response.data}");
        return _auth.currentUser;
      } else {
        print("Update Failed with status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      final String errorMessage = e.toString();
      if (context != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    }
  }

  Future<bool> deleteUser() async {
    try {
      User? user = _auth.currentUser;

      if (user != null) {
        String uid = user.uid;

        await Dio().delete(
          'https://uas-net-l-default-rtdb.asia-southeast1.firebasedatabase.app/users/$uid.json',
        );

        await user.delete();
        return true;
      } else {
        print("User is null");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
