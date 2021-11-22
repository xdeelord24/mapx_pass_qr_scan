import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';

class CounterStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    if (directory == null) {
      print("DIRECTORY IS NULL!!");
    }

    // print(directory);
    return directory.path;
  }

  Future<int> deleteFile() async {
    try {
      final file = await _localFile;
      final fileDepartment = await _localFileDepartments;
      final fileProx = await _localprox;

      await file.delete();
      await fileDepartment.delete();
      await fileProx.delete();
    } catch (e) {
      return 0;
    }
    return 0;
  }

  Future<int> deleteFileDepartments() async {
    try {
      final fileDepartment = await _localFileDepartments;
      await fileDepartment.delete();
    } catch (e) {
      return 0;
    }
    return 0;
  }

  Future<int> deleteFileProx() async {
    try {
      final fileProx = await _localprox;

      await fileProx.delete();
    } catch (e) {
      return 0;
    }
    return 0;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> get _localFileDepartments async {
    final path = await _localPath;
    return File('$path/departments.txt');
  }

  Future<File> get _localFileImgDepartments async {
    final path = await _localPath;
    return File('$path/img.jpg');
  }

  Future<File> get _localprox async {
    final path = await _localPath;
    return File('$path/prox.txt');
  }
  

  Future<String?> readCounter() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }


  Future<String?> readDataDepartments() async {
    try {
      final file = await _localFileDepartments;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<File?> readDataProx(String dir) async {
    final path = await _localPath;
    try {
      final file = await File('$path/students?id_number=$dir');
      return file;
    } catch (e) {
      // If encountering an error, return 0
      return null;
    }
  }

  Future<File> writeCounter(String data) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString('$data');
  }

  Future<File> writeDataDepartments(String data) async {
    final file = await _localFileDepartments;

    // Write the file
    return file.writeAsString('$data');
  }

  Future<File> writeDataProx(String data) async {
    final file = await _localprox;

    // Write the file
    return file.writeAsString('$data');
  }
}
