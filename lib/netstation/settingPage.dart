import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uas_net/netstation/AccountPage.dart';
import 'package:uas_net/netstation/Login/Service/AuthControler.dart';
import 'package:uas_net/netstation/Login/loginS.dart';

class SettingP extends StatefulWidget {
  const SettingP({Key? key}) : super(key: key);

  @override
  State<SettingP> createState() => _SettingPState();
}

class _SettingPState extends State<SettingP> {
  final FirebaseAuthController _authController = FirebaseAuthController();
  late String uuid;
  late String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getData(),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView(
              children: <Widget>[
                Divider(),
                ListTile(
                  leading: Icon(Icons.verified_user),
                  title: Text('Pusat akun'),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountPage(
                          username: snapshot.data!['username'] ?? '',
                          email: snapshot.data!['email'] ?? '',
                        ),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete),
                  title: Text('Hapus Akun'),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Konfirmasi'),
                          content:
                              Text('Apakah Anda yakin ingin menghapus akun?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () async {
                                bool success = await _authController.deleteUser();
                                if (success) {
                                  // Show a success message or navigate to a success page
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Berhasil'),
                                        content: Text('Akun berhasil dihapus.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginS()),
                                              );
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } else {
                                  // Show an error message
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Gagal'),
                                        content: Text(
                                            'Gagal menghapus akun. Silakan coba lagi.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text('OK'),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }
                              },
                              child: Text('Ya'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Tidak'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> getData() async {
    User? user = FirebaseAuth.instance.currentUser;
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
