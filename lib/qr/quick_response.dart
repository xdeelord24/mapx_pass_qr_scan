import 'dart:ui';
import 'package:flutter/material.dart';
import 'qr_app_theme.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:mapx_pass/app_theme.dart';
import 'package:mapx_pass/services/read_write.dart' as storage;
import 'package:mapx_pass/services/mongo_db.dart' as mongo;
import 'package:mapx_pass/globals.dart' as Global;
import 'package:mapx_pass/services/strapi.dart' as Strapi;

class QuickResponse extends StatefulWidget {
  @override
  _QuickResponse createState() => _QuickResponse();
}

class _QuickResponse extends State<QuickResponse>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  final ScrollController _scrollController = ScrollController();

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  String? _data;
  File? img;
  var userData;

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
      await storage.CounterStorage()
          .readDataProx('${userData['id_number']}')
          .then((context) {
        if (context != null)
          setState(() {
            img = context;
          });
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
                  child: Column(
                    children: <Widget>[
                      getAppBarUI(),
                      SizedBox(
                        height: 30.0,
                      ),

                      // Center(
                      //   child: Padding(
                      //       padding: const EdgeInsets.only(top: 15, left: 4),
                      //       child: userData != null
                      //           ? Image.network(
                      //               'http://${Strapi.StrapiService().ip}:1337${userData['profPic']['formats']['thumbnail']['url']}')
                      //           : CircularProgressIndicator()),
                      // ),

                      Center(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 15, left: 4),
                            child: img != null
                                ? Image.file(img!.absolute)
                                : CircularProgressIndicator()),
                      ),

                      // Container(
                      //   height: 180,
                      //   width: 180,
                      //   decoration: BoxDecoration(
                      //     shape: BoxShape.circle,
                      //     boxShadow: <BoxShadow>[
                      //       BoxShadow(
                      //           color: AppTheme.grey.withOpacity(0.6),
                      //           offset: const Offset(2.0, 4.0),
                      //           blurRadius: 8),
                      //     ],
                      //   ),
                      //   child: ClipRRect(
                      //     borderRadius:
                      //         const BorderRadius.all(Radius.circular(60.0)),
                      //     child: Image.asset('assets/images/userImage.png'),
                      //   ),
                      // ),
                      SizedBox(
                        height: 30.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8, left: 4),
                        child: textId(),
                      ),
                      getQRCode(),
                    ],
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
    return userData != null ? Text(
      "${userData['id_number']!.toString()}",
      style: TextStyle(
        fontWeight: FontWeight.w600,
        color: AppTheme.grey,
        fontSize: 20,
      ),
    ) : CircularProgressIndicator();
  }

  Widget getQRCode() {
    var generatedText;
    if (userData != null)
      generatedText = "${userData['id_number']!.toString()}";
    generatedText = "";
    final hash = hashing(generatedText, salt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 30.0,
        ),
        Container(
          alignment: Alignment.center,
          child: QrImage(
            data: "$generatedText",
            version: QrVersions.auto,
            size: 300.0,
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        // TextButton(
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        //   child: Text('Done'),
        // ),
      ],
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
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'My QR Code',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            // Container(
            //   width: AppBar().preferredSize.height + 40,
            //   height: AppBar().preferredSize.height,
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: <Widget>[
            //       Material(
            //         color: Colors.transparent,
            //         child: InkWell(
            //           borderRadius: const BorderRadius.all(
            //             Radius.circular(32.0),
            //           ),
            //           onTap: () {},
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Icon(Icons.favorite_border),
            //           ),
            //         ),
            //       ),
            //       Material(
            //         color: Colors.transparent,
            //         child: InkWell(
            //           borderRadius: const BorderRadius.all(
            //             Radius.circular(32.0),
            //           ),
            //           onTap: () {},
            //           child: Padding(
            //             padding: const EdgeInsets.all(8.0),
            //             child: Icon(FontAwesomeIcons.mapMarkerAlt),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // )
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
