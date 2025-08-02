
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_hedline_model.dart';

class NewsRepository {
  Future<NewsChannelsHedlinesModel> fetchNewChannelHeadlinesApi([String source = 'bbc-news']) async {
    String url =
        'https://newsapi.org/v2/top-headlines?sources=$source&apiKey=d33cccfad25d42abaf1171fd69726cfe';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('Fetching news from source: $source');
      print('API URL: $url');
      print('Response status: ${response.statusCode}');
    }
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (kDebugMode) {
        print('Articles found: ${body['articles']?.length ?? 0}');
      }
      return NewsChannelsHedlinesModel.fromJson(body);
    } else {
      if (kDebugMode) {
        print('Error response: ${response.body}');
      }
      throw Exception('Error fetching news: ${response.statusCode} - ${response.body}');
    }
  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category) async {
    String url =
        'https://newsapi.org/v2/everything?q=$category&apiKey=d33cccfad25d42abaf1171fd69726cfe';

    final response = await http.get(Uri.parse(url));
    if (kDebugMode) {
      print('Fetching news from source: $category');
      print('API URL: $url');
      print('Response status: ${response.statusCode}');
    }
    
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (kDebugMode) {
        print('Articles found: ${body['articles']?.length ?? 0}');
      }
      return CategoriesNewsModel.fromJson(body);
    } else {
      if (kDebugMode) {
        print('Error response: ${response.body}');
      }
      throw Exception('Error fetching news: ${response.statusCode} - ${response.body}');
    }
  }
}