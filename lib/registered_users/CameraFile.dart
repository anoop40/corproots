import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:corproots/registered_users/myDocumentsUser.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../settingsAllFle.dart';

// A screen that allows users to take a picture using a given camera.
class CameraFile extends StatefulWidget {
  final CameraDescription camera;
  final uploadDocumentType;
  final returnUrl;

  const CameraFile({
    required Key key,
    required this.camera,
    this.returnUrl,
    this.uploadDocumentType,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<CameraFile> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('Take a picture')),

      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Attempt to take a picture and get the file `image`
            // where it was saved.
            final image = await _controller.takePicture();

            // If the picture was taken, display it on a new screen.
            /*
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                  uploadDocumentType: widget.uploadDocumentType,
                ),
              ),
            );
            */
            if (widget.returnUrl == "PancardUpload2") {
              /*
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PancardUpload2(image.path),
                ),
              );

               */
            }
            if (widget.returnUrl == "passportPhotoUpload") {
              /*
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => passportPhotoUpload(image.path),
                ),
              );

               */
            }
            if (widget.returnUrl == "addressProof") {
              /*
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => addressProof(image.path),
                ),
              );

               */
            }
            if (widget.returnUrl == "rentalAgrement") {
              /*
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => rentalAgrement(image.path),
                ),
              );

               */
            }
            if (widget.returnUrl == "electricityUtilityBill") {
              /*
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => electricityUtilityBill(image.path),
                ),
              );

               */
            }
            if (widget.returnUrl == "myProfileUser") {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('profilePic', image.path);
              /*
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyProfileUser(),
                ),
              );

               */
            }
            if (widget.returnUrl == "myDocumentsUser") {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('documentCameraPick', image.path);
              /*
              return Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyDocumentsUser(),
                ),
              );

               */
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final uploadDocumentType;

  DisplayPictureScreen({required Key key, required this.imagePath, this.uploadDocumentType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<String> uploadImage(
        filePat, url, form_assigned_to_clint_table_id, uploadDocType) async {
      var uri = Uri.parse(url);

      //request.fields['user'] = userId;
      print("Uri is : " + uri.toString());
      var request = http.MultipartRequest('POST', uri)
        ..fields['form_assigned_to_clint_table_id'] =
            form_assigned_to_clint_table_id
        ..fields['documentType'] = uploadDocType
        ..files.add(await http.MultipartFile.fromPath(
          'userfile',
          filePat,
        ));

      var response = await request.send();
      print("Response file upload + " + response.toString());

      if (response.statusCode == 200) Navigator.pop(context);
      _btnController.success();
      Timer(Duration(seconds: 1), () async {
        Navigator.pushNamed(context, "passportPhotoUpload");
      });
      return "1";
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Scanned File')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      //body: Image.file(File(imagePath)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.file(File(imagePath)),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: RoundedLoadingButton(
            width: MediaQuery.of(context).size.width,
            curve: Curves.fastOutSlowIn,
            child: Text("USE THIS IMAGE"),
            controller: _btnController,
            borderRadius: 4,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? form_assigned_to_clint_table_id =
                  prefs.getString('form_assigned_to_clint_table_id');

              File filePatT = File(imagePath);
              //print("File path is : " + filePat.toString());
              String url = "${SettingsAllFle.finalURl}/upload-document";
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (BuildContext context) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  });
              await uploadImage(filePatT.path, url,
                  form_assigned_to_clint_table_id, this.uploadDocumentType);
            }),
      ),
    );
  }
}
