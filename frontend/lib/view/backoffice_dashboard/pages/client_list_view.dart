import 'package:flutter/material.dart';
import 'package:food_order_ui/configuration/client.dart';
import 'package:food_order_ui/services/client_api.dart';
import 'client_detail_view.dart';

class ClientListView extends StatefulWidget {
  @override
  _ClientListViewState createState() => _ClientListViewState();
}

class _ClientListViewState extends State<ClientListView> {
  late Future<List<Client>> futureClients;

  @override
  void initState() {
    super.initState();
    futureClients = ClientApi.getClients();
  }

  void _refreshClients() {
    setState(() {
      futureClients = ClientApi.getClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clients'),
      ),
      body: FutureBuilder<List<Client>>(
        future: futureClients,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('Snapshot Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No clients found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final client = snapshot.data![index];
                print('Client: ${client.firstName} ${client.lastName}');
                return ListTile(
                  title: Text('${client.firstName} ${client.lastName}'),
                  subtitle: Text(client.email),
                  onTap: () async {
                    bool? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientDetailView(client: client),
                      ),
                    );
                    if (result == true) {
                      _refreshClients();
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
