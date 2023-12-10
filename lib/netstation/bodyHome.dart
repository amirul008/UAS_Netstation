import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uas_net/netstation/FillmInfo.dart';
import 'package:uas_net/netstation/detailPage.dart';
import 'package:uas_net/netstation/kategori/CurrentlyAiringPage.dart';
import 'package:uas_net/netstation/kategori/FinishedAiringPage.dart';
import 'package:uas_net/netstation/profileHome.dart';
import 'package:uas_net/netstation/searchHome.dart';
import 'package:uas_net/netstation/service/fillmData.dart';

import 'package:unicons/unicons.dart';

class BodyHome extends StatefulWidget {
  final List filmDataNew;

  BodyHome({Key? key, required this.filmDataNew});

  @override
  State<BodyHome> createState() => _BodyHomeState();
}

class _BodyHomeState extends State<BodyHome> {
  late List? filmdatanew2;

  Future<List?> _setupDatas() async {
    FilmDetailService filmdatas = FilmDetailService();
    await filmdatas.getData();
    return filmdatas.filmDetailsList;
  }

  @override
  void initState() {
    super.initState();
    _setupDatas().then((value) {
      setState(() {
        filmdatanew2 = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildTopRow(context),
            SizedBox(height: 10.0),
            _buildHorizontalList(context),
            // SizedBox(height: 10.0),
            _buildFinish(context),
            // SizedBox(height: 2.0),
            _buildVerticalList(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopRow(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
      ),
      child: Row(
        children: [
          Text(
            'It\'s Fun Time!',
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            onPressed: () async {
              await buildShowDialog(context);
            },
            child: Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
            child: Container(
              width: 30.0,
              height: 30.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(BuildContext context) {
    // Set the maximum count of items
    int maxCount = 17; // You can change this to any desired count

    return Container(
      height: 200,
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            min(widget.filmDataNew.length, maxCount), // Limit the count
            (index) {
              String imagePath = widget.filmDataNew[index]["images"]["jpg"]
                      ["large_image_url"] ??
                  '';
              String filmName =
                  widget.filmDataNew[index]["title_english"] ?? '';
              String st = widget.filmDataNew[index]["status"] ?? '';
              String description = widget.filmDataNew[index]["synopsis"] ?? '';

              if (imagePath.isNotEmpty &&
                  filmName.isNotEmpty &&
                  st.isNotEmpty &&
                  description.isNotEmpty) {
                return _buildHorizontalListItem(
                  context,
                  imagePath,
                  filmName,
                  st,
                  description,
                );
              } else {
                return Container();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalListItem(BuildContext context, String imagePath,
      String filmName, String st, String description) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    filmInfo: FilmInfo(
                      imagePath: imagePath,
                      filmName: filmName,
                      st: st,
                      description: description,
                    ),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 120,
                width: 80,
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: 90,
          height: 50,
          child: Column(
            children: [
              Text(
                filmName,
                softWrap: true,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinish(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                UniconsLine.check_square,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Builder(
          builder: (context) {
            return Container(
              height: 200,
              padding: EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFinish2(
                      context,
                      'Assets/image/check.png',
                      'Finish',
                      true,
                    ),
                    _buildFinish2(
                      context,
                      'Assets/image/on.png',
                      'On Going',
                      false,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFinish2(BuildContext context, String imagePath, String filmName,
      bool isFinished) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => isFinished
                      ? FinishedAiringPage(filmDataNew: filmdatanew2!)
                      : CurrentlyAiringPage(filmDataNew: filmdatanew2!),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Container(
                height: 120,
                width: 180,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Container(
          width: 90,
          height: 50,
          child: Column(
            children: [
              Text(
                filmName,
                softWrap: true,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalList(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                UniconsLine.list_ui_alt,
                color: Colors.blue,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'List Movies',
                style: TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisExtent: 200,
            crossAxisCount: 3,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            while (index < widget.filmDataNew.length) {
              String imagePath = widget.filmDataNew[index]["images"]["jpg"]
                      ["large_image_url"] ??
                  '';
              String filmName =
                  widget.filmDataNew[index]["title_english"] ?? '';
              String st = widget.filmDataNew[index]["status"] ?? '';
              String synopsis = widget.filmDataNew[index]["synopsis"] ?? '';

              if (imagePath.isNotEmpty &&
                  filmName.isNotEmpty &&
                  st.isNotEmpty &&
                  synopsis.isNotEmpty) {
                return _buildVerticalListItem(
                    context, imagePath, filmName, st, synopsis);
              } else {
                index++;
              }
            }
            return Container();
          },
        ),
      ],
    );
  }

  Widget _buildVerticalListItem(BuildContext context, String imagePath,
      String filmName, String st, String description) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 14.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailPage(
                    filmInfo: FilmInfo(
                      imagePath: imagePath,
                      filmName: filmName,
                      st: st,
                      description: description,
                    ),
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: Container(
                width: 100,
                height: 150,
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 10.0,
        ),
        Column(
          children: [
            Text(
              filmName,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

 Future<void> buildShowDialog(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      // Show CircularProgressIndicator
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );

  // Delay for 3 seconds
  await Future.delayed(Duration(seconds: 1));

  // Dismiss the dialog
  Navigator.of(context, rootNavigator: true).pop();

  // Navigate to the search page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => searchHome(filmDataNew: filmdatanew2!),
    ),
  );
}
}
