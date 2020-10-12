import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_task/Model/auth.dart';
import 'package:flutter_task/Screens/SignUp.dart';
import 'package:flutter_task/Screens/image_from_camera.dart';
import 'package:flutter_task/utils/size_config.dart';

class sign_in extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  sign_in({this.auth, this.onSignedIn});

  @override
  _sign_inState createState() => _sign_inState();
}

class _sign_inState extends State<sign_in> {
  BaseAuth auth;
  final formKey = new GlobalKey<FormState>();
  String _email, _password;
  var _isLoading = false;

  // to show message in error statu
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("تأكيد العملية"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text("موافق"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else {
      _showErrorDialog("تأكد من بياناتك");
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
                .signInWithEmailAndPassword(email: _email, password: _password))
            .user;
        if (user.uid != null) {
          Navigator.of(context).pushReplacement(
              new MaterialPageRoute(builder: (context) => TakeImage()));
        }
        widget.onSignedIn;
      } catch (error) {
        String errorMessage;
        if (error.toString().contains('EMAIL_NOT_FOUND')) {
          errorMessage = 'Could not find a user with that email.';
        }
        errorMessage = "يرجي التأكد من البريد وكلمة السر";
        _showErrorDialog(errorMessage);
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  void validateOfempty(String str) {
    _showErrorDialog("سجل بياناتك للدخول");
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeConfig().init(constraints, orientation);
        return Scaffold(
          backgroundColor: Colors.white,
          body: Form(
            key: formKey,
            //color: Colors.white,
            child: ListView(
              children: <Widget>[
                Card(
                  margin: EdgeInsets.all(0.0),
                  color: Color(0xff21d493),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0))),
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: SizeConfig.getResponsiveWidth(300.0),
                          height: SizeConfig.getResponsiveHeight(120.0),
                          child: Image.asset('assets/images/sign-in.png'),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.getResponsiveHeight(15.0),
                      right: SizeConfig.getResponsiveWidth(25.0),
                      left: SizeConfig.getResponsiveWidth(25.0)),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30.0),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _email = value,
                      //controller: EmailController,
                      decoration: new InputDecoration(
                        //labelText: translations.text("loginPage.textFieldUserName"),
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.green,
                        ),
                        labelText: "البريد الالكتروني",
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.getResponsiveHeight(15.0),
                      right: SizeConfig.getResponsiveWidth(25.0),
                      left: SizeConfig.getResponsiveWidth(25.0)),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(30.0),
                    child: TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
//                      validator: (value) {
//                        if (value.isEmpty || value.length < 5) {
//                          return 'Password is too short!';
//                        }
//                      },
                      onSaved: (value) => _password = value,
                      //controller: _textFieldController,
                      decoration: new InputDecoration(
                        //labelText: translations.text("loginPage.textFieldUserName"),
                        prefixIcon: Icon(
                          Icons.lock,
                          color: Colors.green,
                        ),
                        labelText: "كلمة السر",
                        enabledBorder: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: const BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: Colors.green),
                        ),
                      ),
                    ),
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
                    : Container(
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
//        height: _height / 20,
                            width: SizeConfig.getResponsiveWidth(90.0),
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              "تسجيل دخول",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.getResponsiveHeight(15.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.getResponsiveHeight(10.0),
                      bottom: SizeConfig.getResponsiveHeight(10.0)),
                  alignment: Alignment.center,
                  child: Text(
                    "أو",
                    style: TextStyle(
                        fontSize: SizeConfig.getResponsiveHeight(12.0),
                        color: Color(0xff21d493)),
                  ),
                ),
                Container(
                  width: 200.0,
                  margin: EdgeInsets.only(
                      top: SizeConfig.getResponsiveHeight(10.0),
                      left: 35.0,
                      right: 35.0),
                  child: new FlatButton(
                    padding: EdgeInsets.all(7.0),
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(5.0)),
                    color: Colors.white,
                    child: new Text(
                      "ليس لديك حساب",
                      style: TextStyle(
                          fontSize: SizeConfig.getResponsiveHeight(12),
                          color: Color(0xff21d493)),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => new SignUp(
                                auth: widget.auth,
                                onSignedIn: widget.onSignedIn,
                              )));
                    },
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
