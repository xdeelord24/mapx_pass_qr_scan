// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'dart:math';
// import 'package:encrypt/encrypt.dart';
// import 'package:mapx_pass/globals.dart' as Global;


// // var db = Db("mongodb://10.0.2.2:27017/mapx_data"); //IOS && ANDROID IP TEST
// var db = Db("mongodb://192.168.0.107/mapx_data");
// // var db = Db("mongodb://localhost/mapx_data");
// // var db = Db("mongodb://0.tcp.ap.ngrok.io:20720/mapx_data");
// // var db = Db("mongodb://192.168.1.11/mapx_data");
// var collection = db.collection("students");

// // ignore: camel_case_types
// class mongoDbConnection {
//   Future<bool> checkConnection() async {
//     await db.open().timeout(Duration(seconds: 1), onTimeout: () {
//       return;
//     });
//     if (db.isConnected) {
//       await db.close();
//       return true;
//     } else
//       return false;
//   }

//   Future<Map<String, dynamic>?> getDataMap(String username) async {
//     await db.open();
//     var results = await collection.findOne(where.eq('email', '$username'));
//     if (results == null)
//       results = await collection.findOne(where.eq('id_number', '$username'));
//     await db.close();
//     Global.fullname = results?['fullname'];
//     Global.id_number = results?['id_number'];
//     return results;
//   }

//   Future<bool> checkerUser(String username) async {
//     await db.open();
//     var results = await collection.findOne(where.eq('username', '$username'));
//     await db.close();
//     // print(results?['username']);
//     if (results?['username'] != null){
//       return true;}
//     else
//       return false;
//   }

//   Future<bool> checkerEmail(String email) async {
//     await db.open();
//     var results = await collection.findOne(where.eq('email', '$email'));
//     print(results?['email']);
//     await db.close();
//     if (results != null)
//       return true;
//     else
//       return false;
//   }

//   Future<bool> checkerEmailAndPass(String string, String pwd) async {
//     await db.open();
//     var results;
//     bool emailValid = RegExp(
//             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//         .hasMatch(string.toLowerCase());
//     bool idValid = RegExp(
//             r"^[0-9]{1,3}-[0-9]{1,5}")
//         .hasMatch(string.toLowerCase());
//     if (emailValid)
//       results = await collection.findOne(where.eq('email', '$string'));
//     else if(idValid)
//       results = await collection.findOne(where.eq('id_number', '$string'));
//     else 
//       results = await collection.findOne(where.eq('username', '$string'));
//     await db.close();
//     if (results != null) {
//       var salt = results?['salt'];
//       var pass = hashPassword(pwd, salt);
//       if (pass == results?['pwd'])
//         return true;
//       else
//         return false;
//     } else
//       return false;
//   }
  
//   // Future<bool> checkerEmailAndPass(String string, String pwd) async {
//   //   await db.open();
//   //   var results;
//   //   bool emailValid = RegExp(
//   //           r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//   //       .hasMatch(string.toLowerCase());
//   //   if (emailValid)
//   //     results = await collection.findOne(where.eq('email', '$string'));
//   //   else
//   //     results = await collection.findOne(where.eq('username', '$string'));
//   //   await db.close();
//   //   if (results != null) {
//   //     var salt = results?['salt'];
//   //     var pass = hashPassword(pwd, salt);
//   //     if (pass == results?['pwd'])
//   //       return true;
//   //     else
//   //       return false;
//   //   } else
//   //     return false;
//   // }

//   void insertUser(String id_number, String pwd, String fullname, String email,
//       String age, String gender, String address, String contact) async {
//     await db.open();
// // Checker
//     var checkerUsername = await collection.findOne(
//         where.eq('id_number', id_number.toLowerCase()).fields(['id_number']));
//     var checkerEmail = await collection
//         .findOne(where.eq('email', email.toLowerCase()).fields(['email']));
//     if (checkerUsername != null) {
//       print('Username is not Available: ' + checkerUsername.values.last);
//       return;
//     }
//     if (checkerEmail != null) {
//       print('Email is not Available: ' + checkerEmail.values.last);
//       return;
//     }
// // Generate SALT
//     var rand = Random();
//     var saltBytes = List<int>.generate(32, (_) => rand.nextInt(256));
//     var salt = base64.encode(saltBytes);
// // Hash combining with salt
//     var hashedPassword = hashPassword(pwd, salt);
//     await collection.save(
//       {
//         'id_number': id_number.toLowerCase(),
//         'fullname': fullname.toUpperCase(),
//         'email': email.toLowerCase(),
//         'contact': contact,
//         'age': age,
//         'gender': gender,
//         'address': address,
//         'pwd': hashedPassword,
//         'salt': salt,
//         'qr_code': []
//       },
//     );
//     await db.close();
//   }


//   void insert(String username, String pwd, String fullname, String email,
//       String age, String gender, String address, String contact) async {
//     await db.open();
// // Checker
//     var checkerUsername = await collection.findOne(
//         where.eq('username', username.toLowerCase()).fields(['username']));
//     var checkerEmail = await collection
//         .findOne(where.eq('email', email.toLowerCase()).fields(['email']));
//     if (checkerUsername != null) {
//       print('Username is not Available: ' + checkerUsername.values.last);
//       return;
//     }
//     if (checkerEmail != null) {
//       print('Email is not Available: ' + checkerEmail.values.last);
//       return;
//     }
// // Generate SALT
//     var rand = Random();
//     var saltBytes = List<int>.generate(32, (_) => rand.nextInt(256));
//     var salt = base64.encode(saltBytes);
// // Hash combining with salt
//     var hashedPassword = hashPassword(pwd, salt);
//     await collection.save(
//       {
//         'username': username.toLowerCase(),
//         'fullname': fullname,
//         'email': email,
//         'contact': contact,
//         'age': age,
//         'gender': gender,
//         'address': address,
//         'pwd': hashedPassword,
//         'salt': salt,
//         'qr_code': []
//       },
//     );
//     await db.close();
//   }

//   Future<void> insertdata(String username, String from, String destination,
//       String purpose, String code, dateTime, String temperature) async {
//     await db.open();
//     await collection.update({
//       "username": "$username",
//     }, {
//       "\$push": {
//         "qr_code": {
//           "code": "$code",
//           "address_from": "$from",
//           "destination": "$destination",
//           "purpose": "$purpose",
//           "dateTime": "$dateTime",
//           "archive": "false"
//         }
//       }
//     });
//     await db.close();
//   }

//   Future<void> updatedata(Map<String, dynamic> json, String username) async {
//     await db.open();
//     var v1;
//     bool emailValid = RegExp(
//             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//         .hasMatch(username.toLowerCase());
//     if (emailValid)
//       v1 = await collection.findOne({"email": "$username"});
//     else
//       v1 = await collection.findOne({"username": "$username"});
//     // print("${v1['qr_code'].toString().length} < ${json['qr_code'].toString().length}");
//     if (v1['qr_code'].toString().length < json['qr_code'].toString().length) {
//       v1['qr_code'] = json['qr_code'];
//       await collection.save(v1);
//       print("SUCCESSFULLY SAVED!");
//     }
//     await db.close();
//   }

//   Future<void> updateinfo(
//       String username, String fullname, String contact, String address) async {
//     await db.open();
//     var v1;
//     bool emailValid = RegExp(
//             r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//         .hasMatch(username.toLowerCase());
//     if (emailValid)
//       v1 = await collection.findOne({"email": "$username"});
//     else
//       v1 = await collection.findOne({"username": "$username"});
//     print(v1['email']);
//     if (v1 != null) {
//       if (fullname != null) v1['fullname'] = "$fullname";
//       if (contact != null) v1['contact'] = "$contact";
//       if (address != null) v1['address'] = "$address";
//       await collection.save(v1);
//       print("SUCCESSFULLY SAVED!");
//     }
//     await db.close();
//   }

//   void archive(String username) async {
//     await db.open();
//     await collection.remove(where.eq("username", username.toLowerCase()));
//     await db.close();
//   }

//   String state() {
//     print(db.state.toString());
//     return db.state.toString();
//   }

//   void updateAdd(String username, String code) async {
//     await db.open();
//     var v1 = await collection.findOne({"username": username.toLowerCase()});
//     v1?["qr_code"] = code;
//     // await collection.save(v1);
//     await db.close();
//   }

//   hashPassword(String password, String salt) {
//     var key = utf8.encode(password);
//     var bytes = utf8.encode(salt);
//     var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
//     var digest = hmacSha256.convert(bytes);
//     return digest.toString();
//   }

//   void decrypt(String json) async {
//     final plainText = json;

//     final key = Key.fromLength(32);
//     final iv = IV.fromLength(16);
//     final encrypter = Encrypter(AES(key));

//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     final decrypted = encrypter.decrypt(encrypted, iv: iv);

//     // print(decrypted);
//     // print(decrypted.length);
//     // print(encrypted.bytes);
//     // print(encrypted.base16);
//     // print(encrypted.base64);
//   }
// }
