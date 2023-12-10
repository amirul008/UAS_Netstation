import 'package:flutter/material.dart';
import 'package:uas_net/netstation/FillmInfo.dart';
import 'package:uas_net/netstation/detailPage.dart';
import 'package:uas_net/netstation/service/fillmData.dart';

class searchHome extends StatefulWidget {
  final List filmDataNew;

  searchHome({Key? key, required this.filmDataNew}) : super(key: key);
  @override
  _searchHomeState createState() => _searchHomeState();
}

class _searchHomeState extends State<searchHome> {
  late List? filmdatanew2;
  String _searchQuery = '';
  List<Map<String, dynamic>> _searchResults = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Cari'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                // Update nilai pencarian saat bidang pencarian berubah
                setState(() {
                  _searchQuery = value;
                  _searchResults = _performSearch();
                });
              },
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

List<Map<String, dynamic>> _performSearch() {
  // Perform the search logic based on your requirements.
  // In this example, it searches for films with titles containing the search query.
  String trimmedQuery = _searchQuery.toLowerCase().trim();
  return widget.filmDataNew
      .where((dynamic filmData) =>
          (filmData as Map<String, dynamic>)["title_english"]
              .toString()
              .toLowerCase()
              .contains(trimmedQuery))
      .toList()
      .cast<Map<String, dynamic>>();
}


  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> filmData = _searchResults[index];
        int number = index + 1;

        return _buildListItem(context, filmData, number);
      },
    );
  }

  Widget _buildListItem(
      BuildContext context, Map<String, dynamic> filmData, int number) {
    // Your existing _buildListItem logic
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
    // Your existing ListV logic
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
