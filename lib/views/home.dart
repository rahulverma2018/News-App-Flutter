import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news_flutter/helper/data.dart';
import 'package:news_flutter/helper/news.dart';
import 'package:news_flutter/models/article_model.dart';
import 'package:news_flutter/models/category_model.dart';
import 'package:news_flutter/views/article_view.dart';
import 'package:news_flutter/views/category_news.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = <CategoryModel>[];
  List<ArticleModel> articles = <ArticleModel>[];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass = new News();
    newsClass.getnews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Flutter", style: TextStyle(color: Colors.black87)),
            Text(
              "News",
              style: TextStyle(color: Colors.deepOrange),
            )
          ],
        ),
        elevation: 0.0,
        backgroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Column(children: <Widget>[
                  //----------------------------Categories News-------------------------
                  Container(
                    height: 70,
                    child: ListView.builder(
                        itemCount: categories.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CategoryTile(
                            imageUrl: categories[index].imageUrl,
                            categoryName: categories[index].categoryName,
                          );
                        }),
                  ),
                  //-----------------------------BlogType News--------------------------
                  Container(
                    padding: EdgeInsets.only(top: 16),
                    child: ListView.builder(
                        itemCount: articles.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return BlogTile(
                            urlToImage: articles[index].urlToImage,
                            title: articles[index].title,
                            desc: articles[index].description,
                            url: articles[index].url,
                          );
                        }),
                  ),
                ]),
              ),
            ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTile({this.imageUrl, this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryNews(
              category: categoryName.toLowerCase(),
            ),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(right: 13),
        child: Stack(
          children: <Widget>[
            ClipRect(
              child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: 120,
                  height: 70,
                  fit: BoxFit.cover),
            ),
            Container(
              alignment: Alignment.center,
              width: 120,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(7),
                color: Colors.black26,
              ),
              child: Text(categoryName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            )
          ],
        ),
      ),
    );
  }
}

class BlogTile extends StatelessWidget {
  late final String urlToImage, title, desc, url;
  BlogTile(
      {required this.urlToImage,
      required this.title,
      required this.desc,
      required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleView(blogUrl: url),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 15),
        child: Column(
          children: <Widget>[
            ClipRRect(
              child: Image.network(urlToImage),
              borderRadius: BorderRadius.circular(6),
            ),
            SizedBox(
              height: 8,
            ),
            Text(title,
                style: TextStyle(
                    fontSize: 17,
                    color: Colors.black,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: 6),
            Text(
              desc,
              style: TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
