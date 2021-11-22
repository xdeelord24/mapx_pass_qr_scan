import 'package:mapx_pass/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:mapx_pass/introduction_animation/introduction_animation_screen.dart';
import 'package:mapx_pass/services/read_write.dart';
import 'package:mapx_pass/services/strapi.dart' as Strapi;
import 'dart:convert';
import 'dart:async';
import 'dart:io';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
      this.screenIndex,
      this.iconAnimationController,
      this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;
  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  CounterStorage storage = CounterStorage();
  late Future<Strapi.Students> futureStudents;
  File? img;
  String? _data;
  var userData;
  // Future opener() async {
  //   futureStudents = Strapi.StrapiService().findStudentsObject('151-05491');
  //   // var test = Strapi.StrapiService().findStudentsJson('151-05491');
  //   // print(await test);
  // }

  Future getterStorage() async {
    // Strapi.StrapiService().findRoomId("NC258110Q2");
    //  img = await Strapi.StrapiService().getImage('151-05491');
    // Strapi.StrapiService().recordRoom("1", "1");
    // Strapi.StrapiService().updatePassword("1", "admin");
    //  print(img!.path);
    try {
      await storage.readCounter().then((context) {
        if (context != null)
          setState(() {
            _data = context;
            if (_data != null) {
              userData = jsonDecode(_data.toString())[0];
            }
            // print(_data);
          });
      });
      await storage.readDataProx('${userData['id_number']}').then((context) {
        if (context != null)
          setState(() {
            img = context;
            // print(img!.absolute);
          });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    // opener();
    getterStorage();
    setDrawerListArray();
    super.initState();
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Account,
        labelName: 'Account',
        icon: Icon(Icons.account_box),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: 'Help',
        isAssetsImage: true,
        imageName: 'assets/images/supportIcon.png',
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: 'FeedBack',
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Invite,
        labelName: 'Invite Friend',
        icon: Icon(Icons.group),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: 'Rate the app',
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: 'About Us',
        icon: Icon(Icons.info),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.notWhite.withOpacity(0.5),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 40.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // AnimatedBuilder(
                  //   animation: widget.iconAnimationController!,
                  //   builder: (BuildContext context, Widget? child) {
                  //     return ScaleTransition(
                  //       scale: AlwaysStoppedAnimation<double>(1.0 -
                  //           (widget.iconAnimationController!.value) * 0.2),
                  //       child: RotationTransition(
                  //         turns: AlwaysStoppedAnimation<double>(Tween<double>(
                  //                     begin: 0.0, end: 24.0)
                  //                 .animate(CurvedAnimation(
                  //                     parent: widget.iconAnimationController!,
                  //                     curve: Curves.fastOutSlowIn))
                  //                 .value /
                  //             360),
                  //         child: Container(
                  //           height: 120,
                  //           width: 120,
                  //           decoration: BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             boxShadow: <BoxShadow>[
                  //               BoxShadow(
                  //                   color: AppTheme.grey.withOpacity(0.6),
                  //                   offset: const Offset(2.0, 4.0),
                  //                   blurRadius: 8),
                  //             ],
                  //           ),
                  //           child: ClipRRect(
                  //             borderRadius:
                  //                 const BorderRadius.all(Radius.circular(60.0)),
                  //             child: Image.asset('assets/images/userImage.png'),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),

                  // Center(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(top: 15, left: 4),
                  //     child: FutureBuilder<Strapi.Students>(
                  //       future: futureStudents,
                  //       builder: (context, snapshot) {
                  //         if (snapshot.hasData) {
                  //           return Image.network(
                  //               'http://${Strapi.StrapiService().ip}:1337${snapshot.data!.imageUrl['formats']['thumbnail']['url']}');
                  //         } else if (snapshot.hasError) {
                  //           return Text('${snapshot.error}');
                  //         }
                  //         // By default, show a loading spinner.
                  //         return const CircularProgressIndicator();
                  //       },
                  //     ),
                  //   ),
                  // ),

                  Center(
                    child: Padding(
                        padding: const EdgeInsets.only(top: 15, left: 4),
                        child: img != null
                            ? Image.file(img!.absolute)
                            : CircularProgressIndicator()),
                  ),

                  Padding(
                      padding: const EdgeInsets.only(top: 15, left: 4),
                      child: userData != null
                          ? Text(
                              '${userData['id_number']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.grey,
                                fontSize: 18,
                              ),
                            )
                          : CircularProgressIndicator()),
                  Padding(
                      padding: const EdgeInsets.only(top: 15, left: 4),
                      child: userData != null
                          ? Text(
                              '${userData['fullname']}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppTheme.grey,
                                fontSize: 18,
                              ),
                            )
                          : CircularProgressIndicator()),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 15, left: 4),
                  //   child: FutureBuilder<Strapi.Students>(
                  //     future: futureStudents,
                  //     builder: (context, snapshot) {
                  //       if (snapshot.hasData) {
                  //         return Text(
                  //           snapshot.data!.fullname,
                  //           style: TextStyle(
                  //             fontWeight: FontWeight.w600,
                  //             color: AppTheme.grey,
                  //             fontSize: 18,
                  //           ),
                  //         );
                  //       } else if (snapshot.hasError) {
                  //         return Text('${snapshot.error}');
                  //       }
                  //       // By default, show a loading spinner.
                  //       return const CircularProgressIndicator();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 4,
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: AppTheme.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontFamily: AppTheme.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppTheme.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  onTapped();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onTapped() async {
    await img!.delete();
    await storage.deleteFile();
    await storage.deleteFileDepartments();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => IntroductionAnimationScreen()),
    );
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                          width: 24,
                          height: 24,
                          child: Image.asset(listData.imageName,
                              color: widget.screenIndex == listData.index
                                  ? Colors.blue
                                  : AppTheme.nearlyBlack),
                        )
                      : Icon(listData.icon?.icon,
                          color: widget.screenIndex == listData.index
                              ? Colors.blue
                              : AppTheme.nearlyBlack),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : AppTheme.nearlyBlack,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
                    animation: widget.iconAnimationController!,
                    builder: (BuildContext context, Widget? child) {
                      return Transform(
                        transform: Matrix4.translationValues(
                            (MediaQuery.of(context).size.width * 0.75 - 64) *
                                (1.0 -
                                    widget.iconAnimationController!.value -
                                    1.0),
                            0.0,
                            0.0),
                        child: Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          child: Container(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 64,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.2),
                              borderRadius: new BorderRadius.only(
                                topLeft: Radius.circular(0),
                                topRight: Radius.circular(28),
                                bottomLeft: Radius.circular(0),
                                bottomRight: Radius.circular(28),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  Account,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}
