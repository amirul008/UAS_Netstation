import 'package:flutter/material.dart';
import 'package:uas_net/netstation/TopPage.dart';
import 'package:uas_net/netstation/bodyHome.dart';
import 'package:uas_net/netstation/profileHome.dart';
import 'package:uas_net/netstation/service/fillmData.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({Key? key}) : super(key: key);

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;
  late List? filmdatanew2;

  @override
  void initState() {
    super.initState();
  }

  Future<List?> _setupDatas() async {
    FilmDetailService filmdatas = FilmDetailService();
    await filmdatas.getData();
    return filmdatas.filmDetailsList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List?>(
      future: _setupDatas(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // or some loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          filmdatanew2 = snapshot.data;
          return _buildMainWidget();
        }
      },
    );
  }

  Widget _buildMainWidget() {
  List allPages = [BodyHome(filmDataNew: filmdatanew2!), TopPage(filmDataNew: filmdatanew2!), ProfilePage()];
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: allPages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.white,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.leaderboard_outlined,
                color: Colors.white,
              ),
              label: 'Top List',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: 'Profile',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(color: Colors.black),
          unselectedLabelStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
