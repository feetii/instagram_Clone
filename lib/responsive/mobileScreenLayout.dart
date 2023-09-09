import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram_clone/models/user.dart' as model;
import 'package:instagram_clone/providers/user_provider.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:instagram_clone/utils/globale_variables.dart';
import 'package:provider/provider.dart';

import '../screens/add_post_Screen.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;
  void navigationTap(int  page){
pageController.jumpToPage(page);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageController=PageController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    pageController.dispose();
  }
  void onPageChenged(int page){
    setState(() {
      _page = page;
    });
  }
  Widget build(BuildContext context) {
    model.User user = Provider.of<UserProvider>(context).getUser;

    return (user!=null) ? Scaffold(
      body:PageView(
        children:homeScreenItems,
        physics: NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChenged,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _page == 0 ? primaryColor : secondaryColor,
              ),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: _page == 1 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),

          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle,
                  color: _page == 2 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite,
                  color: _page == 3 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
          BottomNavigationBarItem(
              icon: Icon(Icons.person,
                  color: _page == 4 ? primaryColor : secondaryColor),
              label: '',
              backgroundColor: primaryColor),
        ],
        onTap: navigationTap,
      ),
    ):Center(child: CircularProgressIndicator(),);
  }
}
