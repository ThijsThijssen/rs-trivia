import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class ImageCapture extends StatefulWidget {
  @override
  _ImageCaptureState createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  final _auth = FirebaseAuth.instance;

  File _image;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _image = File(_auth.currentUser.photoURL);
  }

  Future _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: CircleAvatar(
            backgroundImage: FileImage(_image),
            radius: 120.0,
          ),
        ),
        IconButton(icon: Icon(FontAwesomeIcons.userEdit), onPressed: _pickImage)
      ],
    );
  }
}
