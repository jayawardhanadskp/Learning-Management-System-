import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Marks extends StatefulWidget {
  const Marks({Key? key}) : super(key: key);

  @override
  _MarksState createState() => _MarksState();
}

class _MarksState extends State<Marks> {
  List<Map<String, dynamic>> marksData = [];

  @override
  void initState() {
    super.initState();
    fetchMarksData();
  }

  Future<void> fetchMarksData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await firestore.collection('marks').get();
    List<Map<String, dynamic>> data = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

    setState(() {
      marksData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
 appBar: AppBar(
        title: Text('Marks'),
      ),
      body: Column(
        children: [
        
          Expanded(
            child: ListView.builder(
              itemCount: marksData.length,
              itemBuilder: (BuildContext context, int index) {
                int score = marksData[index]['score'] ?? 0;
                bool isHighScore = score >= 80;
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: isHighScore
                          ? LinearGradient(
                              colors: [Colors.green.shade400, Colors.green.shade200],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          marksData[index]['subject'] ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isHighScore ? Colors.white : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Score: $score',
                          style: TextStyle(
                            fontSize: 16,
                            color: isHighScore ? Colors.white : Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Instructor: ${marksData[index]['instructor'] ?? ''}',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: isHighScore ? Colors.white : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
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
