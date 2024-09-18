import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/client.dart';
import 'package:food_order_ui/services/client_api.dart';
import 'client_edit_view.dart';

class ClientDetailView extends StatelessWidget {
  final Client client;

  ClientDetailView({required this.client});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Client Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${client.firstName} ${client.lastName}'),
            Text('Email: ${client.email}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClientEditView(client: client),
                  ),
                );
              },
              child: Text('Edit'),
            ),
            ElevatedButton(
              onPressed: () async {
                try {
                  await ClientApi.deleteClient(client.id);
                  Navigator.pop(context, true);
                } catch (error) {
                  print('Delete Error: $error');
                }
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}
