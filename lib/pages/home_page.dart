import 'package:centranews/pages/bookmarks_page.dart';
import 'package:centranews/pages/discover_page.dart';
import 'package:centranews/pages/news_page.dart';
import 'package:centranews/widgets/custom_home_navigation_bar.dart';
import 'package:centranews/widgets/home_app_bar.dart';
import 'package:centranews/widgets/home_drawer.dart';
import 'package:centranews/widgets/home_end_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  final List<Widget> _pages = [
    const NewsPage(),
    const DiscoverPage(),
    const BookmarksPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: HomeAppBar(),
      drawer: HomeDrawer(),
      endDrawer: HomeEndDrawer(),
      body: IndexedStack(index: currentPageIndex, children: _pages),
      bottomNavigationBar: CustomHomeNavigationBar(
        setCurrentPageIndex: setCurrentPageIndex,
        currentPageIndex: currentPageIndex,
      ),
    );
  }

  void setCurrentPageIndex(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }
}
