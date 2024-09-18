import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/client.dart';
import 'package:food_order_ui/services/client_api.dart';

class ClientEditView extends StatefulWidget {
  final Client client;

  ClientEditView({required this.client});

  @override
  _ClientEditViewState createState() => _ClientEditViewState();
}

class _ClientEditViewState extends State<ClientEditView> {
  final _formKey = GlobalKey<FormState>();
  late String firstName;
  late String lastName;
  late String email;

  @override
  void initState() {
    super.initState();
    firstName = widget.client.firstName;
    lastName = widget.client.lastName;
    email = widget.client.email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Client'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: firstName,
                decoration: InputDecoration(labelText: 'First Name'),
                onSaved: (value) => firstName = value!,
              ),
              TextFormField(
                initialValue: lastName,
                decoration: InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => lastName = value!,
              ),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Client updatedClient = Client(
                      id: widget.client.id,
                      firstName: firstName,
                      lastName: lastName,
                      email: email,
                    );
                    await ClientApi.updateClient(widget.client.id, updatedClient);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
