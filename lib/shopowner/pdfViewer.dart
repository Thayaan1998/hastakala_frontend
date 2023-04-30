import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp/config.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


class PdfViewer extends StatefulWidget {
  const PdfViewer({Key? key}) : super(key: key);

  @override
  PdfViewerState createState() {
    return PdfViewerState();
  }
}

class PdfViewerState extends State<PdfViewer> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('View Cv'),
          //automaticallyImplyLeading: false,
        ),
        body:SfPdfViewer.network(
            Config.cvUrl,
            canShowPaginationDialog: true));
  }
}
