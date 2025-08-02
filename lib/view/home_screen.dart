import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/models/news_channel_hedline_model.dart';
import 'package:news_app/view/categories_screen.dart';
import 'package:news_app/view/news_details_screen.dart';
import 'package:news_app/view_model/news_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum FilterList {
  bbcNews,
  independent,
  reuters,
  cnn,
  alJazeera,
  financialTimes,
}

class _HomeScreenState extends State<HomeScreen> {
  NewsViewModel newsViewModel = NewsViewModel();

  FilterList? selectedMenu;

  final format = DateFormat('MMMM dd, yyyy');

  String name = 'bbc-news';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width * 1;
    final height = MediaQuery.sizeOf(context).height * 1;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CategoriesScreen()),
            );
          },
          icon: Padding(
            padding: const EdgeInsets.only(top: 5.0, left: 5.0, bottom: 5.0),
            child: Image.asset('images/category_icon.png'),
          ),
        ),
        title: Text(
          'News',
          style: GoogleFonts.notoSerifArmenian(
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        actions: [
          PopupMenuButton<FilterList>(
            initialValue: selectedMenu,
            icon: Icon(Icons.more_vert, color: Colors.black),
            onSelected: (FilterList item) {
              // Update the name based on selection
              switch (item) {
                case FilterList.bbcNews:
                  name = 'bbc-news';
                  break;
                case FilterList.alJazeera:
                  name = 'al-jazeera-english';
                  break;
                case FilterList.cnn:
                  name = 'cnn';
                  break;
                case FilterList.independent:
                  name = 'independent';
                  break;
                case FilterList.reuters:
                  name = 'reuters';
                  break;
                case FilterList.financialTimes:
                  name = 'financial-times';
                  break;
              }

              setState(() {
                selectedMenu = item;
              });
            },
            itemBuilder:
                (context) => <PopupMenuEntry<FilterList>>[
                  PopupMenuItem<FilterList>(
                    value: FilterList.bbcNews,
                    child: Text('BBC News'),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.alJazeera,
                    child: Text('Al Jazeera'),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.cnn,
                    child: Text('CNN'),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.independent,
                    child: Text('Independent'),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.reuters,
                    child: Text('Reuters'),
                  ),
                  PopupMenuItem<FilterList>(
                    value: FilterList.financialTimes,
                    child: Text('Financial Times'),
                  ),
                ],
          ),
        ],
        centerTitle: true,
      ),
      body: ListView(
        children: [
          // Headlines Section
          SizedBox(
            height: height * 0.55,
            width: width,
            child: FutureBuilder<NewsChannelsHedlinesModel>(
              // Pass the name parameter to make the future dependent on the selected source
              future: newsViewModel.fetchNewChannelHeadlinesApi(name),
              // Add key to force rebuild when name changes
              key: ValueKey(name),
              builder: (BuildContext context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: SpinKitCircle(size: 50, color: Colors.blue.shade400),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 60, color: Colors.red),
                        SizedBox(height: 16),
                        Text(
                          'Error loading news',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Please try again',
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data?.articles == null ||
                    snapshot.data!.articles!.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 60,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'No news available',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                } else {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.articles!.length,
                    itemBuilder: (context, index) {
                      final article = snapshot.data!.articles![index];
                      DateTime dateTime = DateTime.parse(
                        article.publishedAt.toString(),
                      );
                      return InkWell(
                        onTap: () {
                          // Navigate to news detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => NewsDetailsScreen(
                                    newsImage: snapshot.data!.articles![index].urlToImage.toString(),
                                    newsTitle: snapshot.data!.articles![index].title.toString(),
                                    newsDate: snapshot.data!.articles![index].publishedAt.toString(),
                                    author: snapshot.data!.articles![index].author.toString(),
                                    description: snapshot.data!.articles![index].description.toString(),
                                    content: snapshot.data!.articles![index].content.toString(),
                                    source: snapshot.data!.articles![index].source!.name.toString(),
                                  ),
                            ),
                          );
                        },
                        child: SizedBox(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  height: height * 0.60,
                                  width: width * 0.9,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: height * 0.01,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          article.urlToImage?.toString() ?? '',
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) =>
                                              Container(child: spinKit2),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            color: Colors.grey.shade200,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.image_not_supported,
                                                  color: Colors.grey,
                                                  size: 50,
                                                ),
                                                Text(
                                                  'No Image',
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 20,
                                  child: Card(
                                    elevation: 5,
                                    color: Colors.white.withOpacity(0.9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Container(
                                      alignment: Alignment.bottomCenter,
                                      height: height * 0.22,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            width: width * 0.7,
                                            child: Text(
                                              article.title?.toString() ??
                                                  'No Title',
                                              maxLines: 4,
                                              overflow: TextOverflow.ellipsis,
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          Container(
                                            padding: EdgeInsets.all(8),
                                            width: width * 0.7,
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    article.source?.name
                                                            ?.toString() ??
                                                        'Unknown Source',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 8),
                                                Text(
                                                  format.format(dateTime),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),

          // Section Header for General News
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Latest News',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigate to see all news
                    _navigateToAllNews();
                  },
                  child: Text(
                    'See All',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // General News List
          FutureBuilder<NewsChannelsHedlinesModel>(
            future: newsViewModel.fetchNewChannelHeadlinesApi('cnn'),
            key: ValueKey('General'),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 200,
                  child: Center(
                    child: SpinKitFadingCircle(
                      color: Colors.blue.shade400,
                      size: 50,
                    ),
                  ),
                );
              } else if (snapshot.hasError) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                        SizedBox(height: 8),
                        Text(
                          'Error loading general news',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        ElevatedButton(
                          onPressed: () => setState(() {}),
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              } else if (!snapshot.hasData ||
                  snapshot.data?.articles == null ||
                  snapshot.data!.articles!.isEmpty) {
                return Container(
                  height: 200,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 40,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No general news available',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount:
                      snapshot.data!.articles!.length > 10
                          ? 10
                          : snapshot
                              .data!
                              .articles!
                              .length, // Limit to 10 items
                  itemBuilder: (context, index) {
                    final article = snapshot.data!.articles![index];
                    DateTime dateTime = DateTime.parse(
                      article.publishedAt.toString(),
                    );

                    return InkWell(
                      onTap: () {
                        _navigateToNewsDetail(article);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    width: 80,
                                    height: 80,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          article.urlToImage?.toString() ?? '',
                                      fit: BoxFit.cover,
                                      placeholder:
                                          (context, url) => Container(
                                            color: Colors.grey.shade200,
                                            child: SpinKitFadingCircle(
                                              color: Colors.blue.shade400,
                                              size: 20,
                                            ),
                                          ),
                                      errorWidget:
                                          (context, url, error) => Container(
                                            color: Colors.grey.shade200,
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                              size: 30,
                                            ),
                                          ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),

                                // Content
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title?.toString() ?? 'No Title',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        article.description?.toString() ??
                                            'No description available',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_time,
                                            size: 14,
                                            color: Colors.grey.shade500,
                                          ),
                                          SizedBox(width: 4),
                                          Expanded(
                                            child: Text(
                                              format.format(dateTime),
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: Colors.grey.shade500,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            article.source?.name?.toString() ??
                                                'Unknown',
                                            style: GoogleFonts.poppins(
                                              fontSize: 11,
                                              color: Colors.blue.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),

          // Bottom padding
          SizedBox(height: 20),
        ],
      ),
    );
  }

  // Navigation methods
  void _navigateToNewsDetail(dynamic article) {
    // TODO: Navigate to news detail screen
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => NewsDetailScreen(article: article),
    //   ),
    // );
    print('Navigate to news detail: ${article.title}');
  }

  void _navigateToAllNews() {
    // TODO: Navigate to all news screen
    print('Navigate to all news');
  }
}

const spinKit2 = SpinKitFadingCircle(color: Colors.amber, size: 50);
