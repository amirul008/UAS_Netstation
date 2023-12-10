import 'package:flutter/material.dart';
import 'package:uas_net/netstation/FillmInfo.dart';
import 'package:uas_net/netstation/detailPage.dart';

class CurrentlyAiringPage extends StatefulWidget {
  final List<dynamic> filmDataNew;

  CurrentlyAiringPage({Key? key, required this.filmDataNew}) : super(key: key);

  @override
  State<CurrentlyAiringPage> createState() => _CurrentlyAiringPageState();
}

class _CurrentlyAiringPageState extends State<CurrentlyAiringPage> {
  @override
  Widget build(BuildContext context) {
    // Cast widget.filmDataNew to List<Map<String, dynamic>>
    List<Map<String, dynamic>> finishedAiringFilms =
        (widget.filmDataNew.cast<Map<String, dynamic>>()).where((filmData) =>
            filmData["status"] == "Currently Airing").toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Currently Airing'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var index = 0; index < finishedAiringFilms.length; index++)
              _buildListItem(
                context,
                finishedAiringFilms[index],
                index + 1,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, Map<String, dynamic> filmData, int number) {
    if (filmData["images"]["jpg"]["large_image_url"] != null &&
        filmData["title_english"] != null &&
        filmData["status"] != null &&
        filmData["synopsis"] != null) {
      return ListV(
        context,
        number,
        filmData["images"]["jpg"]["large_image_url"],
        filmData["title_english"],
        filmData["status"],
        filmData["synopsis"],
      );
    } else {
      return Container();
    }
  }

  Widget ListV(BuildContext context, int number, String imagePath,
      String filmName, String st, String description) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              child: Text(
                '$number.',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 10),
            ClipRRect(
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
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  child: Text(
                    filmName,
                    softWrap: true,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
