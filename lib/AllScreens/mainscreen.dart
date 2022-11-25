import 'package:apm_ambulance_app/tabsPages/ICEpage.dart';
import 'package:apm_ambulance_app/tabsPages/homeTabPage.dart';
import 'package:apm_ambulance_app/tabsPages/profilePage.dart';
import 'package:apm_ambulance_app/tabsPages/ratingTabPage.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String idScreen = "mainScreen";
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  int selectedIndex = 0;

  void onItemClicked(int index) {
   setState(() {
      selectedIndex = index;
    tabController.index = selectedIndex;
   });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: tabController,
        // ignore: prefer_const_literals_to_create_immutables
        children: [
          HomeTabPage(),
          IcePage(),
          ProfileTabPage(),
          RatingTabPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        // ignore: prefer_const_literals_to_create_immutables
        items: <BottomNavigationBarItem>[
          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
            // ignore: prefer_const_constructors
            icon: Icon(Icons.home,size: 40.0,),
            label: "Home",
          ),

          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
            // ignore: prefer_const_constructors
            icon: Icon(Icons.emergency,size: 40.0,),
            label: "ICE",
          ),

          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
            // ignore: prefer_const_constructors
            icon: Icon(Icons.star ,size: 40.0),
            label: "Rating",
            
          ),

          // ignore: prefer_const_constructors
          BottomNavigationBarItem(
            // ignore: prefer_const_constructors
            icon: Icon(Icons.person,size: 40.0,),
            label: "Profile",
          ),
        ],
        unselectedItemColor: Colors.black54,
        selectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 15.0),
        showUnselectedLabels: true,
        currentIndex: selectedIndex,
        onTap: onItemClicked,
      ),
    );
  }
}
