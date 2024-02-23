import 'package:flutter/material.dart';
import 'package:mockapi_flutter_crud/apiServices/api_service.dart';
import 'package:mockapi_flutter_crud/screens/AddButton.dart';
import 'package:mockapi_flutter_crud/screens/DeleteModal.dart';
import 'package:mockapi_flutter_crud/screens/single.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> blogs = [];
  bool isLoading = true;

  bool isLoadingAfter = false;

  final ApiService _apiService =
      ApiService(); // Create an instance of ApiService

  @override
  void initState() {
    super.initState();
    _fetchDataFromAPI();
  }

  void deleteItem(Map blog) {
    setState(() {
      blogs.remove(blog); // Remove the item from the list
    });
  }

  Future<void> _fetchDataFromAPI() async {
    try {
      final response = await _apiService.fetchDataFromAPI("blog");
      // Handle the response
      if (response.statusCode == 200) {
        // API call was successful, process the data here
        setState(() {
          blogs = response.data;
          isLoading = false;
        });
      } else {
        // API call failed
        print('Failed to fetch data from API');
      }
    } catch (e) {
      // Exception occurred during API call
      print('Exception occurred: $e');
    }
  }

  Future<void> _editDataFromApi(blog, title, description) async {
    try {
      final response = await _apiService.editDataFromAPI(
          "blog", blog['id'], {"title": title, "description": description});
      // Handle the response
      if (response.statusCode == 200) {
        _fetchDataFromAPI();
      } else {
        // API call failed
        print('Failed to fetch data from API');
      }
    } catch (e) {
      // Exception occurred during API call
      print('Exception occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MockAPI CRUD"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs[index];
                final title = blog['title'];
                final image = blog['image'];
                final desc = blog['description'];
                return ListTile(
                  onTap: () => navigateToNextPageWithId(context, blog['id']),
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        image), // Replace 'your_image.png' with your actual image asset path
                  ),
                  title: Text(title),
                  subtitle:
                      Text(desc.length >= 30 ? desc.substring(0, 90) : desc),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return DeleteConfirmationModal(
                                  id: blog,
                                  // Pass the ID of the item to delete
                                  onDelete: (bool isSuccess) {
                                    if (isSuccess) {
                                      // Handle successful deletion
                                      deleteItem(
                                          blog); // Remove the item from the list
                                    } else {
                                      // Handle deletion failure
                                      print('Failed to delete item.');
                                    }
                                  },
                                );
                              },
                            );
                          }),
                      IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => edit(blog))
                    ],
                  ),
                );
              }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var data = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return CustomModal(); // Display the custom modal
            },
          );
          if (data == null) return;

          setState(() {
            blogs.add(data);
          });
        },
        tooltip: 'Add', // Tooltip to show on hover
        child: Icon(Icons.add), // Icon for the button
      ),
    );
  }

  void edit(dynamic blog) {
    TextEditingController title = TextEditingController(text: blog['title']);
    TextEditingController description =
        TextEditingController(text: blog['description']);
    TextEditingController avatar = TextEditingController(text: blog['image']);

    var isEditing = false;
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Edit Blog"),
                TextFormField(
                    controller: title,
                    decoration: InputDecoration(helperText: "Title")),
                TextFormField(
                    controller: avatar,
                    decoration: InputDecoration(helperText: "Image")),
                TextFormField(
                    controller: description,
                    maxLines: 4,
                    decoration: InputDecoration(helperText: "Description")),
                StatefulBuilder(builder: (context, action) {
                  return ElevatedButton(
                      onPressed: () async {
                        action(
                            () {}); // Trigger rebuild to show loading animation
                        isEditing = true;
                        action(() {});
                        await _editDataFromApi(
                            blog, title.text, description.text);
                        isEditing = false;
                        action(() {});
                        setState(() {
                          blog['title'] = title.text;
                          blog['description'] = description.text;
                          blog['image'] = avatar.text;
                        });

                        Navigator.pop(context);
                      },
                      child: isEditing
                          ? SizedBox(
                              width:
                                  20, // Adjust the width as per your requirement
                              height:
                                  20, // Adjust the height as per your requirement
                              child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.red)),
                            )
                          : Text('Submit'));
                })
              ],
            )),
          );
        });
  }

  void navigateToNextPageWithId(BuildContext context, String id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SinglePage(id: id),
      ),
    );
  }
}
