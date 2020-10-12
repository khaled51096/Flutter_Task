import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task/Screens/Utility.dart';
import 'package:flutter_task/Screens/show_images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_task/constant/images.dart';

class TakeImage extends StatefulWidget {
  @override
  _TakeImageState createState() => _TakeImageState();
}

class _TakeImageState extends State<TakeImage> {
  ///- for Profile Image From SharedPerference
  Future<File> imageFile;
  Image imageFromSharedPreferences;
  loadImageFromPreferences() {
    Utility.getImageFromPreferences().then((img) {
      if (null == img) {
        return (Container(
            height: 193.0,
            width: 212.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(180.0),
              child: FittedBox(
                fit: BoxFit.cover,
                child: CircleAvatar(
                  child: Icon(Icons.add_a_photo),
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
              height: 193.0,
              width: 212.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(180.0),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: CircleAvatar(
                    child: Icon(Icons.add_a_photo),
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
    loadImageFromPreferences();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Image'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20),
        child: Stack(
          children: <Widget>[
            GestureDetector(
              onTap: () {
                pickImageFromGallery(ImageSource.camera);
                //imageFromSharedPreferences = null;
                setState(() {});
              },
              child: Center(
                child: (imageFromSharedPreferences == null)
                    ? Container(
                        height: 185,
                        width: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(180.0),
                          child: FittedBox(
                            fit: BoxFit.fill,
                            child: imageFromGallery(),
                          ),
                        ))
                    : Container(
                        height: 185,
                        width:200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(180.0),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: imageFromSharedPreferences,
                          ),
                        )),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShowImages(),
            ),
          );
        },
        tooltip: 'Pick Image',
        child: new Icon(
          Icons.photo_library,
        ),
      ),
    );
  }
}
