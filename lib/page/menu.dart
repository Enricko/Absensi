import 'package:absensi/page/screens/history.dart';
import 'package:absensi/page/screens/home.dart';
import 'package:absensi/page/screens/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key, this.indexPage = 0}) : super(key: key);
  final int indexPage;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var _bottomNavIndex = 0;
  final navigation = <Widget>[HomeScreen(), History(), Profile()];

  @override
  void initState() {
    setState(() {
      _bottomNavIndex = widget.indexPage;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigation[_bottomNavIndex],
      bottomNavigationBar:
          //Navigation Bar
          BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Home.svg",
              //ketika Icon di klik , maka icon akan berubah menjadi biru
              color: _bottomNavIndex == 0 ? Colors.blue : Colors.black38,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Search.svg",
              color: _bottomNavIndex == 1 ? Colors.blue : Colors.black38,
            ),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Profile.svg",
              color: _bottomNavIndex == 2 ? Colors.blue : Colors.black38,
            ),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.blue, // Change the color of the selected item
        unselectedItemColor: Colors.grey, // Change the color of unselected items
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
    );
  }
}
