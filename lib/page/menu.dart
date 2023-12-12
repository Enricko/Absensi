import 'package:absensi/page/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'history.dart';
import 'home.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  var _bottomNavIndex = 0;
  final navigation = <Widget>[HomeScreen(),History(),Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigation[_bottomNavIndex],
      bottomNavigationBar:
      // Material(
      //   color: Colors.white,
      //   child: TabBar(
      //     indicator: TopIndicator(),
      //     tabs: const <Widget>[
      //       Tab(icon: Icon(Icons.home_outlined), text: 'Reward'),
      //       Tab(icon: Icon(Icons.home_outlined), text: 'Reward'),
      //       Tab(icon: Icon(Icons.home_outlined), text: 'Reward'),
      //     ],
      //   ),
      // ),
      BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        onTap: (index) => setState(() => _bottomNavIndex = index),
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/Home.svg",
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
  Widget bottomTabBar(){
    return new TabBarView(

      children:[
        new Container(
          color: Colors.yellow,
        ),
        new Container(
          color: Colors.orange,
        ),
        new Container(
          color: Colors.lightGreen,
        ),
        new Container(
          color: Colors.red,
        )
      ],
    );
  }
}
class TopIndicator extends Decoration {
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _TopIndicatorBox();
  }
}

class _TopIndicatorBox extends BoxPainter {
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    Paint _paint = Paint()
      ..color = Colors.lightBlue
      ..strokeWidth = 5
      ..isAntiAlias = true;

    canvas.drawLine(offset, Offset(cfg.size!.width + offset.dx, 0), _paint);
  }
}