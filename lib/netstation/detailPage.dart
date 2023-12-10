import 'package:flutter/material.dart';
import 'package:uas_net/netstation/FillmInfo.dart';

class DetailPage extends StatelessWidget {
  final FilmInfo filmInfo;

  DetailPage({required this.filmInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Page'),
        backgroundColor: Colors.blue,
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          Center(
            child: Image.network(
              filmInfo.imagePath,
              width: 800.0,
              height: 300.0,
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            'Nama Film: ${filmInfo.filmName}',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.0),
          Text(
            'Stat: ',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 10.0),
          Text(
            filmInfo.st,
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 20.0),
          Text(
            'Deskripsi Film:',
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10.0),
          Text(
            filmInfo.description,
            style: TextStyle(
              fontSize: 16,
            ),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 20.0),
        ],
      ),
    );
  }
}
