import 'package:flutter/material.dart';
import 'package:uas_net/netstation/FillmInfo.dart';
import 'package:uas_net/netstation/detailPage.dart';

class TopPage extends StatefulWidget {
  final List? filmDataNew;

  TopPage({Key? key, required this.filmDataNew}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('List Top Movies'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.filmDataNew != null)
              for (var index = 0; index < widget.filmDataNew!.length; index++)
                _buildListItem(context, widget.filmDataNew![index], index + 1)
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(
      BuildContext context, Map<String, dynamic> filmData, int number) {
    // Check if the required data exists and is not empty
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
      // Skip item if required data is empty
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
            // Angka urutan
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
