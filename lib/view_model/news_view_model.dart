import 'package:news_app/models/categories_news_model.dart';
import 'package:news_app/models/news_channel_hedline_model.dart';
import 'package:news_app/repository/news_repository.dart';

class NewsViewModel {
  final _rep = NewsRepository();

  Future<NewsChannelsHedlinesModel> fetchNewChannelHeadlinesApi([String source = 'bbc-news']) async {
    final response = await _rep.fetchNewChannelHeadlinesApi(source);
    return response;
  }
  Future<CategoriesNewsModel> fetchCategoriesNewsApi(String category ) async {
    final response = await _rep.fetchCategoriesNewsApi(category);
    return response;
  }
}