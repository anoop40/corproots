import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:corproots/settingsAllFle.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
// A screen that allows users to take a picture using a given camera.
class CameraFile extends StatefulWidget {
  const CameraFile({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

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
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
            print("Image path : " + image.path);
            // If the picture was taken, display it on a new screen.
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
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
  final _documentNameForm = GlobalKey<FormState>();
  final _fileName = new TextEditingController();
  DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: new Padding(
        padding: EdgeInsets.zero,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue[800],
          ),
          onPressed: () {
            AlertDialog alert = AlertDialog(
              content: new Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // CircularProgressIndicator(),
                  // Container(margin: EdgeInsets.only(left: 7),child:Text("Loading..." )),
                  Form(
                    key: _documentNameForm,
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      controller: _fileName,
                      decoration: InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Document heading'),
                    ),
                  ),
                  ElevatedButton(
                    child: const Text('UPLOAD'),
                    onPressed: () async {

                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      if (_documentNameForm.currentState!
                          .validate()) {
                        /*ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Processing Data')),
                                          );
                                          */
                        var serverUrlfinal =
                            "${SettingsAllFle.finalURl}upload-documents";
                        var request = http.MultipartRequest(
                            'POST', Uri.parse(serverUrlfinal))
                          ..fields['userId'] =
                          prefs.getString('userId')!
                          ..fields['documentHeading'] =
                              _fileName.text
                          ..files.add(await http.MultipartFile
                              .fromPath(
                              'userfile',
                             imagePath));
                        var response = await request.send();
                        CoolAlert.show(
                            onConfirmBtnTap: () {
                              Navigator.pushNamed(
                                  context, 'myDocumentsUser');
                            },
                            context: context,
                            type: CoolAlertType.success,
                            text:
                            'File uploaded successfully!');
                      }


                    },
                  ),
                ],
              ),
            );
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
          },
          child: Text('UPLOAD NOW'),
        ),
      ),
      appBar: AppBar(title: const Text('Captured Image')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image.file(File(imagePath)),
            ),
          ],
        ),
      ),
    );
  }
}
