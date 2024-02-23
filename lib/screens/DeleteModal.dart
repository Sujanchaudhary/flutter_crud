import 'package:flutter/material.dart';
import 'package:mockapi_flutter_crud/apiServices/api_service.dart';

class DeleteConfirmationModal extends StatefulWidget {
  final dynamic id;
  final Function(bool) onDelete;

  DeleteConfirmationModal({required this.id, required this.onDelete});

  @override
  _DeleteConfirmationModalState createState() =>
      _DeleteConfirmationModalState();
}

class _DeleteConfirmationModalState extends State<DeleteConfirmationModal> {
  bool isDeleting = false;
  var isSelectedId;

  final ApiService _apiService = ApiService();

  Future<void> _deleteDataFromApi(String id) async {
    print(id);

    try {
      final response =
          await _apiService.deleteDataFromAPI("blog", int.parse(id));

      print(response.data);
      if (response.statusCode == 200) {
        // API call was successful, process the data here
        // Assuming you have a way to update the UI after deleting data
        setState(() {
          isDeleting = false;
        });
        widget.onDelete(true); // Notify the caller that deletion was successful
      } else {
        // API call failed
        print('Failed to delete data from API');
        widget.onDelete(false); // Notify the caller that deletion failed
      }
    } catch (e) {
      // Exception occurred during API call
      print('Exception occurred: $e');
      widget.onDelete(false); // Notify the caller that deletion failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Confirm Delete'),
      content:
          Text('Are you sure you want to delete item ${widget.id['title']}?'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {

            setState(() {});
            await _deleteDataFromApi(widget.id['id']);
            setState(() {});

            Navigator.pop(context); // Close the dialog
          },
          child: Text(
            'Delete',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
