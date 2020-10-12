import 'dart:io';

import 'package:flutter_task/Screens/image_from_camera.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task/Model/auth.dart';
import 'package:flutter_task/Screens/sign_in.dart';
import 'package:flutter_task/utils/size_config.dart';
import 'package:flutter_task/Animation/FadeAnimation.dart';

class SignUp extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  SignUp({this.auth, this.onSignedIn});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = new GlobalKey<FormState>();
  String username, email, password, confirmPassword, phone;
  var _isLoading = false;
  String userId;

  FirebaseDatabase _database = FirebaseDatabase.instance;

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void validateAndSubmit() async {
    setState(() {
      _isLoading = true;
    });

    if (validateAndSave()) {
      try {
        FirebaseUser user = (await FirebaseAuth.instance
                .createUserWithEmailAndPassword(
                    email: email, password: password))
            .user;
        if (user.uid != null) {
          ////- from move to another screen
          //// update new customer informations mu adding Phone number
          _database.reference().child("customers").child(user.uid).set({
            "email": email,
            "name": username,
          });

          await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: email, password: password);

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => TakeImage()));
        }
        //widget.onSignedIn;
      } on SocketException catch (e) {
        print('SocketException-> $e');
        // errorToast('please_check_your_connection');
      } catch (e) {
        print('RegisterScreenState#_submit UnknownError-> $e');
        // errorToast('server_error');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _passtextFieldController =
        TextEditingController();

    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          body: Container(
            color: Colors.white,
            child: ListView(
              children: <Widget>[
                Stack(children: <Widget>[
                  Opacity(
                    opacity: 0.5,
                    child: ClipPath(
                      //clipper: CustomShapeClipper2(),
                      child: Container(
                        height: SizeConfig.getResponsiveHeight(100),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xff21d493), Colors.green],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.getResponsiveHeight(30.0)),
                    height: SizeConfig.getResponsiveHeight(90),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            spreadRadius: 0.0,
                            color: Colors.black26,
                            offset: Offset(1.0, 10.0),
                            blurRadius: 20.0),
                      ],
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ]),
                Form(
                  key: formKey,
                  child: new ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      FadeAnimation(
                        1.7,
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 25, left: 25),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty || value.length < 4) {
                                return "ادخل اسم مستخدم صحيح";
                              }
                            },
                            onSaved: (value) => username = value,
                            //controller: _textFieldController,

                            decoration: new InputDecoration(
                              labelText: "اسم المستخدم",

                              prefixIcon: Icon(
                                Icons.person,
                                color: Colors.green,
                              ),
                              //labelText: AppLocalizations.of(context).categoryNameFruite,
                              enabledBorder: const OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0)),
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                      FadeAnimation(
                          1.8,
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 25, left: 25),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return "يرجي ادخال البريد بطريقة صحيحة";
                                }
                              },
                              onSaved: (value) => email = value,
                              decoration: new InputDecoration(
                                labelText: "البريد الالكتروني",

                                prefixIcon: Icon(
                                  Icons.email,
                                  color: Colors.green,
                                ),
                                //labelText: AppLocalizations.of(context).categoryNameFruite,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                          )),
                      FadeAnimation(
                          2.0,
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 25, left: 25),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty || value.length < 6) {
                                  return "يجب أن يكون أكبر من 6 أرقام";
                                }
                              },
                              onSaved: (value) => password = value,
                              controller: _passtextFieldController,
                              decoration: new InputDecoration(
                                labelText: "كلمة السر",

                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.green,
                                ),
                                //labelText: AppLocalizations.of(context).categoryNameFruite,
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                          )),
                      FadeAnimation(
                          2.1,
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 20.0, right: 25, left: 25),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty) return 'Empty';
                                if (value != _passtextFieldController.text)
                                  return "كلمة السر غير متطابقة";
                              },
                              onSaved: (value) => confirmPassword = value,
                              //controller: _textFieldController,

                              decoration: new InputDecoration(
                                labelText: "تأكيد كلمة السر",
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.green,
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: const BorderSide(
                                    color: Colors.grey,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15.0)),
                                  borderSide: BorderSide(color: Colors.blue),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
                _isLoading
                    ? Center(
                        child: SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 3.0,
                            valueColor: AlwaysStoppedAnimation(Colors.green),
                          ),
                        ),
                      )
                    : FadeAnimation(
                        2.2,
                        Container(
                          margin: EdgeInsets.only(
                              top: SizeConfig.getResponsiveHeight(20.0),
                              right: SizeConfig.getResponsiveWidth(50.0),
                              left: SizeConfig.getResponsiveWidth(50.0)),
                          child: RaisedButton(
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0)),
                            onPressed: () {
                              validateAndSubmit();
                            },
                            textColor: Colors.white,
                            color: Colors.white,
                            padding: EdgeInsets.all(0.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff21d493),
                                  borderRadius: new BorderRadius.all(
                                      Radius.circular(40.0))),
                              alignment: Alignment.center,
                              width: SizeConfig.getResponsiveWidth(90.0),
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                "تأكيد",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: SizeConfig.getResponsiveWidth(10.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 15,
                ),
                FadeAnimation(
                  2.3,
                  Container(
                    width: 200.0,
                    color: Colors.white70,
                    margin: EdgeInsets.only(
                        left: SizeConfig.getResponsiveWidth(35.0),
                        right: SizeConfig.getResponsiveWidth(35.0)),
                    child: new FlatButton(
                      padding: EdgeInsets.all(7.0),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(5.0)),
                      color: Colors.white,
                      child: new FlatButton(
                        child: Text(
                          "لديك حساب بالفعل",
                          style: TextStyle(
                              fontSize: SizeConfig.getResponsiveHeight(10),
                              color: Color(0xff21d493)),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).push(new MaterialPageRoute(
                            builder: (Context) => new sign_in(
                                  auth: widget.auth,
                                  onSignedIn: widget.onSignedIn,
                                )));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
    });
  }
}
