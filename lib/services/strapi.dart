import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:async/async.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class StrapiService {
  String ip = '192.168.85.203';
  String token =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjM3MzE0Njk2LCJleHAiOjE2Mzk5MDY2OTZ9.U9tI7TInAzp4zN9ky_-UN4aiyA3JQJ6PqcVJ8OTNIFI';

  Map<String, String> headers = {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
    'Authorization':
        'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNjM3MzE0Njk2LCJleHAiOjE2Mzk5MDY2OTZ9.U9tI7TInAzp4zN9ky_-UN4aiyA3JQJ6PqcVJ8OTNIFI',
  };
  getterStudents() async {
    var response =
        await http.get(Uri.parse('http://$ip:1337/students'), headers: headers);
    return response;
  }

  saveImage(String id_number) async {
    var response = await http.get(
        Uri.parse('http://$ip:1337/students?id_number=$id_number'),
        headers: headers);
    // Get the image name
    final imageName = basename('http://$ip:1337/students?id_number=$id_number');
    // Get the document directory path
    final appDir = await pathProvider.getApplicationDocumentsDirectory();
    // This is the saved image path
    // You can use it to display the saved image later.
    final localPath = join(appDir.path, imageName);
    var response2 = await http.get(
        Uri.parse(
            'http://$ip:1337${jsonDecode(response.body)[0]['profPic']['formats']['thumbnail']['url']}'),
        headers: headers);
    // print('http://$ip:1337${jsonDecode(response.body)[0]['profPic']['url']}');
    // Downloading
    final imageFile = File(localPath);
    await imageFile.writeAsBytes(response2.bodyBytes);
    print('Downloaded! ${imageFile.path}');
    return imageFile;
  }

  updatePassword(String id, String password) async {
    try {
      var response = await http.put(Uri.parse('http://$ip:1337/students/$id'),
          headers: headers, body: jsonEncode({'password': password}));
    } catch (e) {
      print("updatePassword Error! -> $e");
    }
  }

  recordRoom(String id, String room) async {
    try {
      var response = await http.post(Uri.parse('http://$ip:1337/visit-records'),
          headers: headers, body: jsonEncode({'student': id, 'room': room}));
      var updateStudRoom = await http.put(
          Uri.parse('http://$ip:1337/students/$id'),
          headers: headers,
          body: jsonEncode({'room': room}));
    } catch (e) {
      print("recordRoom Error! -> $e");
    }
  }

  uploadImg(String profPicId) async {
    var response = await http.put(
        Uri.parse('http://$ip:1337/upload/files/$profPicId'),
        headers: headers,
        body: jsonEncode({'password': profPicId}));
  }

  upload(File imageFile) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();

    // var response = await http.post(Uri.parse('http://$ip:1337/upload'),
    //   headers: headers,
    //   );

    var request =
        new http.MultipartRequest("POST", Uri.parse('http://$ip:1337/upload'));
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));
    //contentType: new MediaType('image', 'png'));

    request.files.add(multipartFile);
    var response2 = await request.send();
    print(response2.statusCode);
    response2.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  Future<String?> findRoomId(String code) async {
    final response = await http
        .get(Uri.parse('http://$ip:1337/rooms?code=$code'), headers: headers);
    print(jsonDecode(response.body)[0]["id"]);
    if (response.statusCode == 200) {
      if (jsonDecode(response.body).length != 0)
        return jsonDecode(response.body)[0]["id"].toString();
      return null;
    } else {
      return null;
    }
  }

  Future<bool> loginValidator(String id_number, String password) async {
    final response = await http.get(
        Uri.parse(
            'http://$ip:1337/students?id_number=$id_number&password=$password'),
        headers: headers);
    // print(jsonDecode(response.body).length);
    // print('http://$ip:1337/students?id_number=$id_number&password=$password');
    if (response.statusCode == 200) {
      if (jsonDecode(response.body).length != 0) return true;
      return false;
    } else {
      return false;
      // throw Exception('Failed to load Students');
    }
  }

  Future<Students> findStudentsObject(String id_number) async {
    final response = await http.get(
        Uri.parse('http://$ip:1337/students?id_number=$id_number'),
        headers: headers);
    // print(jsonDecode(response.body)[0]);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Students.fromJson(jsonDecode(response.body)[0]);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Students');
    }
  }

  Future<String> findStudentsJson(String id_number) async {
    final response = await http.get(
        Uri.parse('http://$ip:1337/students?id_number=$id_number'),
        headers: headers);
    // print(jsonDecode(response.body));
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return response.body;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Students');
    }
  }

  Future<String> getDepartments() async {
    final response = await http.get(Uri.parse('http://$ip:1337/departments'),
        headers: headers);
    if (response.statusCode == 200) {
      print(response.body);
      return response.body;
    } else {
      throw Exception('Failed to load Students');
    }
  }
}

class Students {
  final String id_number;
  final String fullname;
  final String address;
  final String contact;
  final Map<String, dynamic> imageUrl;

  Students({
    required this.id_number,
    required this.fullname,
    required this.address,
    required this.contact,
    required this.imageUrl,
  });

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      id_number: json['id_number'],
      fullname: json['fullname'],
      address: json['address'],
      contact: json['contact'],
      imageUrl: json['profPic'],
    );
  }
  Map toJson() => {
        'id_number': id_number,
        'fullname': fullname,
        'address': address,
        'contact': contact,
        'profPic': imageUrl,
      };
}

class Departments {
  final String name;
  final String img;

  Departments({
    required this.name,
    required this.img,
  });

  factory Departments.fromJson(Map<String, dynamic> json) {
    return Departments(
      name: json['name'],
      img: json['img'][0]['url'],
    );
  }

  Map toJson() => {
        'name': name,
        'img': img,
      };
}
