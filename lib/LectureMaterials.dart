import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LectureMaterials extends StatefulWidget {
  const LectureMaterials({Key? key}) : super(key: key);

  @override
  _LectureMaterialsState createState() => _LectureMaterialsState();
}

class _LectureMaterialsState extends State<LectureMaterials> {
  List<Map<String, dynamic>> lectureMaterials = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('lecture_materials').get();
    List<Map<String, dynamic>> materials = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      lectureMaterials = materials;
    });
  }

  Future<String> getDownloadUrl(String gsUrl) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.refFromURL(gsUrl);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<File> _downloadPDF(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/$filename');
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

  Future<void> openPdf(String gsUrl) async {
    setState(() {
      _isLoading = true;
    });

    final downloadUrl = await getDownloadUrl(gsUrl);
    final filename = gsUrl.split('/').last;
    final file = await _downloadPDF(downloadUrl, filename);
    setState(() {
      _isLoading = false;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text("PDF Viewer")),
          body: PDFView(
            filePath: file.path,
            enableSwipe: true,
            swipeHorizontal: true,
            autoSpacing: false,
            pageFling: false,
            onError: (error) {
              print(error.toString());
            },
            onPageError: (page, error) {
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {},
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 40.0),
          Text(
            'Lecture Materials',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20.0),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: lectureMaterials.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Icon(Icons.book),
                          title: Text(lectureMaterials[index]['title']),
                          onTap: () {
                            openPdf(lectureMaterials[index]['url']);
                          },
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
