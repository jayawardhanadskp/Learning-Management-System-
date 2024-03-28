import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LectureSchedules extends StatefulWidget {
  const LectureSchedules({Key? key}) : super(key: key);

  @override
  _LectureSchedulesState createState() => _LectureSchedulesState();
}

class _LectureSchedulesState extends State<LectureSchedules> {
  List<Map<String, dynamic>> lectureSchedules = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('LectureSchedule').get();
    List<Map<String, dynamic>> schedules = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      lectureSchedules = schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lecture Schedules'),
      ),
      body: ListView.builder(
        itemCount: lectureSchedules.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Icon(Icons.schedule),
              title: Text(lectureSchedules[index]['title'] ?? ''),
              subtitle: Text(
                  '${lectureSchedules[index]['date'] ?? ''} | ${lectureSchedules[index]['time'] ?? ''}'),
              onTap: () {
                // Add your action for opening the lecture schedule details here
              },
            ),
          );
        },
      ),
    );
  }
}