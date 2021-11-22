import 'package:flutter/material.dart';
import 'qr_app_theme.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:convert';
import 'dart:math';
import 'package:flutter_qr_bar_scanner/qr_bar_scanner_camera.dart';
import 'package:mapx_pass/services/strapi.dart' as Strapi;
import 'package:mapx_pass/services/read_write.dart' as Storage;

class ScannerQr extends StatefulWidget {
  @override
  _ScannerQrState createState() => _ScannerQrState();
}

class _ScannerQrState extends State<ScannerQr> with TickerProviderStateMixin {
  AnimationController? animationController;

  final TextEditingController? _outputController = TextEditingController();
  String? _result, _data, roomId, studentId;
  var _departmentData;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  String? _qrInfo = 'Scan a QR/Bar code';
  bool _camState = false;
  var userData;

  Future getterStorage() async {
    try {
      await Storage.CounterStorage().readCounter().then((context) {
        if (context != null)
          setState(() {
            _data = context;
            if (_data != null) {
              userData = jsonDecode(_data.toString())[0];
            }
          });
      });

      // await Storage.CounterStorage().readDataDepartments().then((context) {
      //   if (context != null)
      //     setState(() {
      //       _dataDep = context;
      //       if (_dataDep != null) {
      //         _departmentData = jsonDecode(_dataDep.toString());
      //       }
      //     });
      // });
    } catch (e) {
      print(e);
    }
  }

  _qrCallback(String? code) {
    setState(() {
      _camState = false;
      _qrInfo = code;
    });
  }

  _scanCode() {
    setState(() {
      _camState = true;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    getterStorage();
    _scanCode();
    super.initState();
  }

  Future<bool?> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

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
                      _scanCodex(),
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

  Widget _scanCodex() {
    return _camState
        ? Center(
            child: SizedBox(
              height: 500,
              width: 500,
              child: QRBarScannerCamera(
                onError: (context, error) => Text(
                  error.toString(),
                  style: TextStyle(color: Colors.red),
                ),
                qrCodeCallback: (code) {
                  _qrCallback(code);
                  result(code!);
                },
              ),
            ),
          )
        : Center(
            child: Text(
                "Thank you for scanning! Id Number: ${userData['id_number']} Room: $_qrInfo"),
            // child: Text("Thank you for scanning! "+hashing(_qrInfo!,"Oag/FqYnjsiR82vS77A6GQ==")! +" "+ dehashing(hashing(_qrInfo!,"Oag/FqYnjsiR82vS77A6GQ==")!, "Oag/FqYnjsiR82vS77A6GQ==")!),
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
                  'Scan QR Code',
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

  Future<String?> result(String code)async {
    
    roomId = await Strapi.StrapiService().findRoomId(code);
    return Strapi.StrapiService()
        .recordRoom(userData['id'].toString(), roomId!)
        .toString();
  }
}

String? hashing(String text, String salt) {
  final plainText = text;
  final key = encrypt.Key.fromUtf8(salt);
  final iv = encrypt.IV.fromLength(16);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));

  final encrypted = encrypter.encrypt(plainText, iv: iv);
  // final decrypted = encrypter.decrypt(encrypted, iv: iv);

  // print(decrypted); // Lorem ipsum dolor sit amet, consectetur adipiscing elit
  // print(encrypted.base64); // R4PxiU3h8YoIRqVow

  return encrypted.base64;
}

String? dehashing(String text, String salt) {
  final plainText = text;
  final key = encrypt.Key.fromUtf8(salt);
  final iv = encrypt.IV.fromLength(16);

  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final decrypted = encrypter.decrypt64(text, iv: iv);

  // print(decrypted);
  return decrypted;
}

var rand = Random();
var saltBytes = List<int>.generate(32, (_) => rand.nextInt(256));
var salt = base64.encode(saltBytes);
