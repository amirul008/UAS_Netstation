import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_net/netstation/AccountPage.dart';
import 'package:uas_net/netstation/Login/loginS.dart';
import 'package:uas_net/netstation/searchHome.dart';
import 'package:uas_net/netstation/settingPage.dart';

class ProfilePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String uuid = '';
  String email = '';

  ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: 
                    AssetImage('Assets/image/conanP.jpg') as ImageProvider<Object>,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    snapshot.data!['username'] ?? '',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    snapshot.data!['email'] ?? '',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Setting'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => AccountPage(username:  snapshot.data!['username'] ?? '', email:  snapshot.data!['email'] ?? '')
                          builder: (context) =>  SettingP()
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Log out'),
                    onTap: () {
                      _auth.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginS()),
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      uuid = user.uid;
      email = user.email ?? '';
    }

    try {
      var response = await Dio().get(
          'https://uas-net-l-default-rtdb.asia-southeast1.firebasedatabase.app/users.json');
      if (response.statusCode == 200) {
        Map<String, dynamic> userData = response.data;

        String? userProfileKey;
        for (var key in userData.keys) {
          if (userData[key] != null && userData[key]['uid'] == uuid) {
            userProfileKey = key;
            break;
          }
        }

        if (userProfileKey != null && userData[userProfileKey] != null) {
          Map<String, dynamic> userProfileData = userData[userProfileKey];

          userProfileData['email'] = email;
          userProfileData['uid'] = uuid;

          return userProfileData;
        } else {
          print('User profile with UID $uuid not found.');
        }
      }
      return {};
    } catch (e) {
      print('Error: $e');
      return {};
    }
  }
}
