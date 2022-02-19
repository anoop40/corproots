import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../settingsAllFle.dart';

class pdfView extends StatefulWidget {
  _pdfView createState() => _pdfView();
}

class _pdfView extends State<pdfView> {
  @override
  Widget build(BuildContext context) {
    final Object? rcvdData =
        ModalRoute.of(context)!.settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Container(
        child: SfPdfViewer.network(
         //'${SettingsAllFle.finalURl}/uploads/${rcvdData['fileName']}',
          '${SettingsAllFle.finalURl}/uploads/123',
            canShowScrollHead : true,
          canShowScrollStatus: true,
          enableDoubleTapZooming: true,
          enableTextSelection: true,
          initialZoomLevel: 1,

        ),
      ),
    );
  }
}
