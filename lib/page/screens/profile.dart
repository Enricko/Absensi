import 'package:absensi/page/auth/login.dart';
import 'package:absensi/page/screens/edit_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
              children:[
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/Background.png',
                    // Replace with your image asset path
                    fit: BoxFit.cover, // Use BoxFit.cover to fill the container
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 58),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Ghaluh Wizard",style: TextStyle(color: Colors.white)),
                          Text("Karyawan",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w300)),
                        ],
                      ),
                      CircleAvatar()
                    ],
                  ),
                )
              ]
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 27),
            child: Column(
              children: [
                // hasil extract widget
                TileProfile(
                  ontap: (){
                    Navigator.push(context,MaterialPageRoute(builder: (ctx)=> EditProfile()));
                  },
                  url: 'assets/icon_person.svg',
                  title: 'Edit Profile',
                ),
                TileProfile(
                  url: 'assets/icon_email.svg',
                  title: 'Edit Email',
                ),
                TileProfile(
                  url: 'assets/icon_password.svg',
                  title: 'Edit Password',
                ),
                TileProfile(
                  url: 'assets/icon_call.svg',
                  title: 'Ganti Nomor Telepon',
                ),
                TileProfile(
                  ontap: ()async{
                    await auth.signOut();
                    Navigator.pushReplacement(context,MaterialPageRoute(builder: (ctx)=> LoginPage()));
                  },
                  url: 'assets/icon_logout.svg',
                  title: 'Log Out',
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class TileProfile extends StatelessWidget {
  final String url;
  final String title;
  final VoidCallback? ontap;

  const TileProfile({
    super.key,
    required this.url,
    required this.title,  this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          tileColor: Color(0x80d7d7d7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: SvgPicture.asset(url),
          title: Text(
            title,
            style: TextStyle(color: Colors.black38, fontSize: 13),
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_sharp,
            size: 13,
            color: Colors.blue,
          ),
          onTap: ontap,
        ),
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
