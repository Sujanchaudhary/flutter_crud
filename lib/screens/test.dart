import 'package:flutter/material.dart';
import 'package:mockapi_flutter_crud/apiServices/api_service.dart';
import 'package:mockapi_flutter_crud/apiServices/test_service.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  List<dynamic> blogs = [];

  test_service _testService = test_service();

  Future<void> getData() async {
    final response = await _testService.getDataFromApi('/blogs');
    if(response.statusCode == 200) {
      
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Test')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListView.builder(
                  itemCount: blogs.length,
                  itemBuilder: (context, index) {
                    final blog = blogs[index];
                    return ListTile(
                      title: Text('${blog['title']}'),
                      subtitle: Text('Author: ${blog['author']}'),

                    );
                  })
            ],
          ),
        ));
  }
}
