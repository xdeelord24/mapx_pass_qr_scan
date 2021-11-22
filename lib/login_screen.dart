import 'Animation/FadeAnimation.dart';
import 'package:flutter/material.dart';
// import 'package:mapx_pass/services/mongo_db.dart';
import 'package:mapx_pass/services/read_write.dart';
import 'package:mapx_pass/navigation_home_screen.dart';
import 'dart:io';
import 'dart:async';
import 'package:mapx_pass/services/strapi.dart' as Strapi;

class LoginScreen extends StatefulWidget {
  const LoginScreen(
      {Key? key, required this.animationController, required this.onNextClick})
      : super(key: key);

  final AnimationController animationController;
  final VoidCallback onNextClick;
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  CounterStorage storage = CounterStorage();
  // mongoDbConnection db = mongoDbConnection();
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  File? img;
  String? _data;
  String? imgPath;
  bool _passwordVisible = false;
  bool isLoading = false;
  bool validator = false;
  var userData;
  @override
  initState() {
    super.initState();
    getterStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: FadeAnimation(
                            1,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-1.png'))),
                            )),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.3,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/light-2.png'))),
                            )),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: FadeAnimation(
                            1.5,
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/clock.png'))),
                            )),
                      ),
                      Positioned(
                        child: FadeAnimation(
                            1.6,
                            Container(
                              margin: EdgeInsets.only(top: 50),
                              child: Center(
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      FadeAnimation(
                          1.8,
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromRGBO(143, 148, 251, .2),
                                      blurRadius: 20.0,
                                      offset: Offset(0, 10))
                                ]),
                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  // decoration: BoxDecoration(
                                  //   border: Border(bottom: BorderSide(color: Colors.grey[100]))
                                  // ),
                                  child: TextField(
                                    controller: userController,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "ID Number or Email",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: !_passwordVisible,
                                    decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            // Based on passwordVisible state choose the icon
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Theme.of(context)
                                                .primaryColorDark,
                                          ),
                                          onPressed: () {
                                            // Update the state i.e. toogle the state of passwordVisible variable
                                            setState(() {
                                              _passwordVisible =
                                                  !_passwordVisible;
                                            });
                                          },
                                        ),
                                        border: InputBorder.none,
                                        hintText: "Password",
                                        hintStyle:
                                            TextStyle(color: Colors.grey[400])),
                                  ),
                                )
                              ],
                            ),
                          )),
                      SizedBox(
                        height: 30,
                      ),
                      FadeAnimation(
                          1,
                          InkWell(
                            onTap: _onLogin,
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(143, 148, 251, 1),
                                    Color.fromRGBO(143, 148, 251, .6),
                                  ])),
                              child: Center(
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Login',
                                        style: TextStyle(
                                          color: Color(0xff132137),
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                          )),
                      SizedBox(
                        height: 70,
                      ),
                      FadeAnimation(
                          1.5,
                          Text(
                            "Forgot Password?",
                            style: TextStyle(
                                color: Color.fromRGBO(143, 148, 251, 1)),
                          )),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  _onLogin() async {
    setState(() {
      isLoading = true;
    });
    try {
      validator = await Strapi.StrapiService()
          .loginValidator(userController.text, passwordController.text);
      if (userController.text.isEmpty || passwordController.text.isEmpty) {
        print('EMPTY DAW');
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Alert Message"),
              // Retrieve the text which the user has entered by
              // using the TextEditingController.
              content: Text("Fields are Empty!"),
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
      } else if (validator) {
        img = await Strapi.StrapiService().saveImage(userController.text);
        await saving_auth();
        await savingDepartments();
        print('LOGGED IN');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => NavigationHomeScreen(),
            ),
            (route) => false);
      } else {
        print("ELSE DAW");
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Alert Message"),
              // Retrieve the text which the user has entered by
              // using the TextEditingController.
              content: Text("Credentials not matched!"),
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
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Alert Message"),
              // Retrieve the text which the user has entered by
              // using the TextEditingController.
              content: Text("$e"),
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
          });
    }
  }

  Future<File> saving_auth() async {
    var futureStudents =
        Strapi.StrapiService().findStudentsJson(userController.text);
    return await storage.writeCounter(await futureStudents);
  }

  Future<File> savingDepartments() async {
    var department = Strapi.StrapiService().getDepartments();
    return await storage.writeDataDepartments(await department);
  }

  Future getterStorage() async {
    try {
      await storage.readCounter().then((context) {
        if (context != null)
          setState(() {
            _data = context;
            // print(_data);
          });
      });
    } catch (e) {
      print(e);
    }
  }
}
