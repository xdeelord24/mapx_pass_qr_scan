import 'package:flutter/material.dart';
import 'package:mapx_pass/services/read_write.dart';
import 'dart:async';
import 'package:mapx_pass/services/strapi.dart' as Strapi;
// import 'package:mapx_pass/services/mongo_db.dart';
// mongoDbConnection mongo = mongoDbConnection();

  String? fullname;
  String? user;
  String? id_number;
  bool? data;
class PublicData extends StatefulWidget {
  const PublicData({
    Key? key,
    required this.id_number,
  }) : super(key: key);

  final String? id_number;

  @override
  _PublicDataState createState() => _PublicDataState();
}

class _PublicDataState extends State<PublicData> {
  // late Future<Strapi.Students> futureStudents =
  //     Strapi.StrapiService().findStudents(widget.id_number!);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Strapi.Students>(
      future: null,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          setState(() {
            fullname = snapshot.data!.fullname;
            id_number = snapshot.data!.id_number;
          });
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
  // Future opener() async {
  //   try {
  //     await storage.readCounter().then((context) {
  //       _dataInternal = context!;
  //         var distributor = jsonDecode(_dataInternal!.toString());
  //         user = distributor['username'];
  //         _data = mongo.checkerUser('${user!}');
  //       print("OUTPUT: ${{_data}}");
  //       // return data!;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

