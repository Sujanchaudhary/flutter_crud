
import 'package:flutter/material.dart';
import 'package:mockapi_flutter_crud/apiServices/api_service.dart';

class SinglePage extends StatefulWidget {
  final String id;

  const SinglePage({Key? key, required this.id}) : super(key: key);

  @override
  _SinglePageState createState() => _SinglePageState();
}

class _SinglePageState extends State<SinglePage> {
  ApiService _apiService = ApiService();
  dynamic blogData;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final int id = int.parse(widget.id);

    try {
      final response = await _apiService.fetchDataSingleFromAPI("blog", id);
      if (response.statusCode == 200) {
        setState(() {
          blogData = response
              .data; // Assuming response.data contains the fetched blog data
        });
      } else {
        print('Failed to fetch data from API');
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Single Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (blogData != null)
              Column(
                children: [
                  Image.network(
                    blogData['image'],
                    height: 200, // Adjust height as needed
                    width: 200, // Adjust width as needed
                  ),
                  SizedBox(height: 20), // Add some spacing
                  Text(
                    blogData['title'],
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20), // Add some spacing
                  Text(
                    blogData['description'],
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            if (blogData == null) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
