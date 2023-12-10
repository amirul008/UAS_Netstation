import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  final String username;
  final String email;

  AccountPage({required this.username, required this.email});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late ImageProvider<Object>? myImageProvider;
  late String country = '';
  late String phoneNumber = '';
  late Future<void> userDataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the Future for fetching user data
    userDataFuture = _fetchUserData();
    // Set the default image if needed
    myImageProvider = AssetImage('Assets/image/conanP.jpg') as ImageProvider<Object>;
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;

      try {
        var response = await Dio().get(
          'https://uas-net-l-default-rtdb.asia-southeast1.firebasedatabase.app/users.json',
        );
        if (response.statusCode == 200) {
          Map<String, dynamic> userData = response.data;

          String? userProfileKey;
          for (var key in userData.keys) {
            if (userData[key] != null && userData[key]['uid'] == uid) {
              userProfileKey = key;
              break;
            }
          }

          if (userProfileKey != null && userData[userProfileKey] != null) {
            Map<String, dynamic> userProfileData = userData[userProfileKey];

            setState(() {
              country = userProfileData['country'] ?? '';
              phoneNumber = userProfileData['phoneNumber'] ?? '';
            });
          } else {
            print('User profile with UID $uid not found.');
          }
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Information'),
      ),
      body: FutureBuilder<void>(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display a loading indicator while fetching data
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Handle error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display the actual content once data is loaded
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 80,
                    backgroundImage: myImageProvider,
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: widget.username,
                    decoration: InputDecoration(labelText: 'Username'),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: widget.email,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: country,
                    decoration: InputDecoration(labelText: 'Country'),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    readOnly: true,
                    initialValue: phoneNumber,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
