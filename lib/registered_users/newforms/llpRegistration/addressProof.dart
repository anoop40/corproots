import 'package:corproots/registered_users/CameraFile.dart';
import 'package:flutter/material.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:flutter/widgets.dart';

import '../../../settingsAllFle.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:camera/camera.dart';

class addressProof extends StatefulWidget {
  final imageLoc;
  addressProof(this.imageLoc, {required Key key}) : super(key: key);
  _addressProof createState() => _addressProof(this.imageLoc);
}

class _addressProof extends State<addressProof> {
  late final imageLoc2;
  final RoundedLoadingButtonController _btnController =
      RoundedLoadingButtonController();
  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();
  late Future str;
  bool _isdisabled = true;
  var currentStatu;
  late File _image;
  var _uploadImagePath;
  var uploadStatus = "not";
  var _imageUploadStat = Container(
    margin: EdgeInsets.only(
      top: 10.00,
    ),
    child: Text("No data"),
  );

  _addressProof(imageLoc);

  _currently_uploaded_img(filePat) {
    setState(
      () {
        _imageUploadStat = Container(
          margin: EdgeInsets.only(
            top: 10,
            bottom: 20,
          ),
          width: MediaQuery.of(context).size.width * 0.9,
          child: Image.file(
            File(filePat),
          ),
        );
        _isdisabled = false;
        _uploadImagePath = filePat;
      },
    );
  }

  Future<String> uploadImage(
      filePat, url, form_assigned_to_clint_table_id) async {
    var uri = Uri.parse(url);

    //request.fields['user'] = userId;
    print("Uri is : " + uri.toString());
    var request = http.MultipartRequest('POST', uri)
      ..fields['form_assigned_to_clint_table_id'] =
          form_assigned_to_clint_table_id
      ..fields['documentType'] = "Address proof"
      ..files.add(await http.MultipartFile.fromPath(
        'userfile',
        filePat,
      ));

    var response = await request.send();
    //print("Response file upload + " + response.toString());

    if (response.statusCode == 200) _btnController.success();
    Timer(Duration(seconds: 1), () async {
      Navigator.pushNamed(context, "rentalAgrement");
    });
    return "true";
  }

  @override
  Widget build(BuildContext context) {
    if (imageLoc2 != "null") {
      _currently_uploaded_img(imageLoc2);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("New LLP Registration"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              child: Image(image: AssetImage('assets_files/address_proof.jpg')),
            ),
            Container(
              child: Text(
                "Address proof",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      FilePickerResult? result = await FilePicker.platform
                          .pickFiles(
                              allowCompression: true,
                              type: FileType.custom,
                              allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf']);

                      if (result != null) {
                        //print("File path is : " + filePat.toString());

                        _currently_uploaded_img(result.files.single.path);
                      } else {
                        print("User cancelled");
                        // User canceled the picker
                      }
                    },
                    icon: Icon(Icons.upload_file, size: 18),
                    label: Text("SELECT FILE"),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: EdgeInsets.only(top: 23),
                  child: Text(
                      "Allowed file types :.jpg , .jpeg , .png , .pdf. Accepted documents are Bank Statement or Telephone Bill or Mobile Bill or Electricity Bill (not older than 2 months)"),
                ),
                Container(
                  margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.02,
                  ),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      WidgetsFlutterBinding.ensureInitialized();
                      final cameras = await availableCameras();
                      final firstCamera = cameras.first;
                      /*
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CameraFile(
                                  camera: firstCamera,
                                  returnUrl: "addressProof",
                                  uploadDocumentType: "PAN Card",
                                )),
                      );

                       */
                    },
                    icon: Icon(Icons.photo_camera_back, size: 18),
                    label: Text("USE YOUR CAMERA"),
                  ),
                ),
                Divider(),
                Container(
                  child: Text(
                    "SELECTED DOCUMENT",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.orange[300],
                    ),
                  ),
                ),
                _imageUploadStat,
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        child: RoundedLoadingButton(
            width: MediaQuery.of(context).size.width,
            curve: Curves.fastOutSlowIn,
            child: Text("NEXT"),
            controller: _btnController,
            borderRadius: 4,
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? form_assigned_to_clint_table_id =
                  prefs.getString('form_assigned_to_clint_table_id');
              if (_isdisabled == true) {
                final snackBar = SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'Please select PAN card copy',
                    ));
                _btnController.reset();

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                File filePat = File(_uploadImagePath);
                String url = "${SettingsAllFle.finalURl}/upload-document";
                await uploadImage(
                  filePat.path,
                  url,
                  form_assigned_to_clint_table_id,
                );
                //print("File path is" + _uploadImagePath);
              }
            }),
      ),
    );
  }
}
