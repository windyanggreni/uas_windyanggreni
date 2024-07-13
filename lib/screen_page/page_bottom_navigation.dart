import 'package:flutter/material.dart';
import 'package:uas_windyanggreni/screen_page/page_list_berita.dart';
import 'package:uas_windyanggreni/screen_page/page_list_mahasiswa.dart';
import 'package:uas_windyanggreni/screen_page/page_profil_user.dart';


class PageBottomNavigationBar extends StatefulWidget {
  const PageBottomNavigationBar({Key? key}) : super(key: key);

  @override
  State<PageBottomNavigationBar> createState() => _PageBottomNavigationBarState();
}

class _PageBottomNavigationBarState extends State<PageBottomNavigationBar> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        controller: tabController,
        children: [
          PageListBerita(),
          PageUtama(),
          PageProfileUser(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: TabBar(
          controller: tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          tabs: [
            Tab(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.article),
                    ),
                    Text("List Berita"),
                  ],
                ),
              ),
            ),
            Tab(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 4),
                      child: Icon(Icons.article),
                    ),
                    Text("List Mahasiswa"),
                  ],
                ),
              ),
            ),
            Tab(
            child: SingleChildScrollView(// Custom layout for Tab
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 4),  // Control spacing between icon and text
                    child: Icon(Icons.person),
                  ),
                  Text("Profil User"),
                ],
              ),
            ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
}
