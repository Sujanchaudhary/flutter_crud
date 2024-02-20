import 'package:flutter/material.dart';
import 'package:mockapi_flutter_crud/apiServices/api_service.dart';

class CustomModal extends StatefulWidget {
  @override
  State<CustomModal> createState() => _CustomModalState();
}

class _CustomModalState extends State<CustomModal> {
  final ApiService _apiService = ApiService();

  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController avatarController = TextEditingController();

  bool isLoading = false;

  Future<dynamic> _addData(title, description, avatarUrl) async {
    try {
      final response = await _apiService.addDataToAPI("blog",
          {"title": title, "description": description, "image": avatarUrl});

      return response.data;
    } catch (e) {
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Add Data',
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: titleController,
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextFormField(
            controller: avatarController,
            decoration: InputDecoration(labelText: 'Avatar'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              isLoading = true;
              setState(() {});
              await Future.delayed(Duration(seconds: 2));
              String title = titleController.text;
              String description = descriptionController.text;
              String avatarUrl = avatarController.text;
              // Implement adding functionality here
              var data = _addData(title, description, avatarUrl);
              isLoading = false;
              setState(() {});
              Navigator.pop(context, data); // Close the modal after adding data
            },
            child: isLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
                : Text('Add'),
          ),
        ],
      ),
    );
  }
}
