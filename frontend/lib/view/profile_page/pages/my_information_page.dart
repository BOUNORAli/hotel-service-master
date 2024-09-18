import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_order_ui/services/api_service.dart';

class MyInformationPage extends StatefulWidget {
  const MyInformationPage({Key? key}) : super(key: key);

  @override
  _MyInformationPageState createState() => _MyInformationPageState();
}

class _MyInformationPageState extends State<MyInformationPage> {
  String firstName = 'N/A';
  String lastName = 'N/A';
  String email = 'N/A';
  bool isEditing = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('access_token');

      if (token != null) {
        var userData = await ApiService.fetchUserData(token);
        setState(() {
          firstName = userData['firstname'] ?? 'N/A';
          lastName = userData['lastname'] ?? 'N/A';
          email = userData['email'] ?? 'N/A';

          _firstNameController.text = firstName;
          _lastNameController.text = lastName;
        });
      }
    } catch (e) {
      print('Error loading user information: $e');
    }
  }

  Future<void> _saveName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('access_token');

    if (token != null) {
      ApiService apiService = ApiService();
      bool success = await apiService.updateUserName(_firstNameController.text, _lastNameController.text);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Name updated successfully')));
        setState(() {
          firstName = _firstNameController.text;
          lastName = _lastNameController.text;
          isEditing = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update name.')));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: User token not found.')));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(Icons.person, size: 50, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),


            if (!isEditing) ...[
              Text(
                '$firstName $lastName',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                email,
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 20),


              ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    isEditing = true;
                  });
                },
                icon: const Icon(Icons.edit),
                label: const Text('Edit Name'),
              ),
            ],


            if (isEditing) ...[
              TextField(
                controller: _firstNameController,
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: _saveName,
                    child: const Text('Save'),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
