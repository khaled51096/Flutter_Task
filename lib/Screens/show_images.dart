import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task/Screens/Utility.dart';
import 'package:flutter_task/constant/images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowImages extends StatefulWidget {
  const ShowImages({Key key}) : super(key: key);
  @override
  _ShowImagesState createState() => _ShowImagesState();
}

class _ShowImagesState extends State<ShowImages> {
  ///- for Profile Image From SharedPerference
  Future<File> imageFile;
  final prefs = SharedPreferences.getInstance();
  Image imageFromSharedPreferences;
  List<Image> imagesFromSharedPreferences;
  loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((img) {
      if (null == img) {
        return (Container(
            height: 93.0,
            width: 112.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(180.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: CircleAvatar(
                  backgroundImage:
                      AssetImage("assets/images/profile_side_menu.png"),
                  //radius: SizeConfig.getResponsiveHeight(40),
                  backgroundColor: Colors.transparent,
                ),
              ),
            )));
      }
      setState(() {
        imageFromSharedPreferences = Utility.imageFromBase64String(img);
      });
    });
  }

  pickImageFromGallery(ImageSource source) {
    setState(() {
      // ignore: deprecated_member_use
      imageFile = ImagePicker.pickImage(source: source);
    });
    imageFromSharedPreferences = null;
  }

  Widget imageFromGallery() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            null != snapshot.data) {
          Utility.saveImageToPreferences(
              Utility.base64String(snapshot.data.readAsBytesSync()));
          return Image.file(
            snapshot.data,
          );
        } else if (null != snapshot.error) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return Container(
              height: 93.0,
              width: 112.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(Images.mainTitleProfileUser),
                    //radius: SizeConfig.getResponsiveHeight(40),
                    backgroundColor: Colors.transparent,
                  ),
                ),
              ));
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    loadImageFromPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display the Picture'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: imageFromSharedPreferences != null
                          ? imageFromSharedPreferences
                          : Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
              Container(
                  height: 85,
                  width: 100,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(180.0),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Icon(Icons.photo),
                    ),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
