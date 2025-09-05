import 'dart:convert';
import 'dart:developer';

import 'package:newsapp/constants/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/model/newsmodel.dart';

class Newsservices {
  final String apiKey = api;
  Future<NewsModel> getNews(String keyword) async {
    final url = Uri.parse("https://newsapi.org/v2/everything?q=$keyword&apiKey=$apiKey");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      log("Response body: ${response.body}");
      return NewsModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load news");
    }
  }
}