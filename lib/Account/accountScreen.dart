import 'dart:ui';
import 'package:flutter/material.dart';
import 'qr_app_theme.dart';
import 'package:mapx_pass/navigation_home_screen.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
import 'package:mapx_pass/app_theme.dart';
import 'package:mapx_pass/services/read_write.dart' as storage;
import 'package:mapx_pass/services/strapi.dart' as Strapi;

class AccountScreen extends StatefulWidget {
  @override
  _AccountScreen createState() => _AccountScreen();
}

class _AccountScreen extends State<AccountScreen>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  String? _data;
  bool confirmation = false;
  var userData;
  bool isLoading = false;
  String? currentPass, newPass, conPass;

  Future getterStorage() async {
    
    try {
      await storage.CounterStorage().readCounter().then((context) {
        if (context != null)
          setState(() {
            _data = context;
          });
        if (_data != null) {
          userData = jsonDecode(_data.toString())[0];
        }
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getterStorage();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    super.initState();
  }

  // Future<bool> getData() async {
  //   await Future<dynamic>.delayed(const Duration(milliseconds: 200));
  //   return true;
  // }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  _onLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      confirmation = await Strapi.StrapiService()
          .loginValidator(userData['id_number'], currentPass!);
      if (confirmation) {
        if (newPass == conPass) {
          Strapi.StrapiService()
              .updatePassword(userData['id'].toString(), newPass!);
              // Strapi.StrapiService().recordRoom('1', '1');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NavigationHomeScreen()),
          );
        } else {
          return showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Alert Message"),
                // Retrieve the text which the user has entered by
                // using the TextEditingController.
                content: Text("New password confirmation is not matched!"),
                actions: <Widget>[
                  new TextButton(
                    child: new Text('OK'),
                    onPressed: () {
                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                  )
                ],
              );
            },
          );
        }
      } else {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Alert Message"),
              // Retrieve the text which the user has entered by
              // using the TextEditingController.
              content: Text("Wrong Password!"),
              actions: <Widget>[
                new TextButton(
                  child: new Text('OK'),
                  onPressed: () {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: HotelAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            child: Stack(
              children: <Widget>[
                InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        getAppBarUI(),
                        SizedBox(
                          height: 30.0,
                        ),
                        Center(
                          child: Padding(
                              padding: const EdgeInsets.only(top: 15, left: 4),
                              child: userData != null
                                  ? Image.network(
                                      'http://${Strapi.StrapiService().ip}:1337${userData['profPic']['formats']['thumbnail']['url']}')
                                  : CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, left: 4),
                          child: textId(),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        userData != null ? Text(
                          "${userData['fullname'].toString()}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppTheme.grey,
                            fontSize: 20,
                          ),
                        ) : CircularProgressIndicator(),
                        SizedBox(
                          height: 30.0,
                        ),
                        Text("Change Password"),
                        Divider(),
                        _buildComposer("Current Password", "currentPass"),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildComposer("New Password", "newPass"),
                        SizedBox(
                          height: 30.0,
                        ),
                        _buildComposer("Confirm Password", "conPass"),
                        SizedBox(
                          height: 30.0,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
                              width: 140,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(4.0)),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: const Offset(4, 4),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: _onLogin,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        'Change Password',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textId() {
    return userData!=null ? Text(
      "${userData['id_number'].toString()}",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppTheme.grey,
        fontSize: 20,
      )
    ) : CircularProgressIndicator();
  }

  Widget _buildComposer(String displayText, String variable) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(2.0),
            constraints: const BoxConstraints(minHeight: 40, maxHeight: 60),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String txt) {
                  if (variable == "currentPass")
                    setState(() {
                      currentPass = txt;
                    });
                  if (variable == "newPass")
                    setState(() {
                      newPass = txt;
                    });
                  if (variable == "conPass")
                    setState(() {
                      conPass = txt;
                    });
                },
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: displayText),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: HotelAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + -40,
              height: AppBar().preferredSize.height,
            ),
            Expanded(
              child: Center(
                child: Text(
                  'My Account',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

hashing(String text, String salt) {
  var key = utf8.encode(text);
  var bytes = utf8.encode(salt);
  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);
  return digest.toString();
}

dehashing(String text, String salt) {
  var key = utf8.encode(text);
  var bytes = utf8.encode(salt);
  var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
  var digest = hmacSha256.convert(bytes);
  return digest.toString();
}

var rand = Random();
var saltBytes = List<int>.generate(32, (_) => rand.nextInt(256));
var salt = base64.encode(saltBytes);
