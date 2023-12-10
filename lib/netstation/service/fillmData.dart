import 'dart:convert';
import 'package:http/http.dart';

class FilmDetailService {
  List filmDetailsList = [];

  Future<void> getData() async {
    Response response = await get(Uri.parse("https://api.jikan.moe/v4/anime"));
    
    // Cek apakah respons API tidak kosong dan memiliki data
    if (response.statusCode == 200) {
      Map dataFetch = jsonDecode(response.body);
      
      // Periksa apakah 'data' ada dan tidak kosong
      if (dataFetch.containsKey("data") && dataFetch["data"] != null) {
        filmDetailsList = dataFetch["data"];
      } else {
        print("API tidak mengandung data lengkap.");
      }
    } else {
      print("Gagal mengambil data dari API. Status code: ${response.statusCode}");
    }
  }
}
