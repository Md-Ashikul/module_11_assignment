import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
    home: PhotoList(),
  ));
}

class PhotoList extends StatefulWidget {
  @override
  _PhotoListState createState() => _PhotoListState();
}

class _PhotoListState extends State<PhotoList> {
  late List data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load photos');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Gallery App'),
      ),
      body: data != null
          ? ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: Image.network(data[index]['thumbnailUrl']),
            title: Text(data[index]['title']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(photo: data[index]),
                ),
              );
            },
          );
        },
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic photo;

  DetailScreen({@required this.photo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Details"),
      ),
      body: Column(
        children: [
          Image.network(photo['url']),
          const SizedBox(
            height: 4,
          ),
          Text("Title:"+photo['title']),
          Text('ID: ${photo['id'].toString()}'),
        ],
      ),
    );
  }
}