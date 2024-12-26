import 'package:flutter/material.dart';
import 'package:localisationfutter/screens/User/UserCases.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> _userRequests = [];

  void _addUserRequest(Map<String, String> request) {
    setState(() {
      _userRequests.add(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () async {
              // Naviguer vers UserCasesScreen et attendre les résultats
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserCasesScreen(),
                ),
              );
              if (result != null) {
                // Si une demande est retournée, l'ajouter à la liste
                _addUserRequest(result);
              }
            },
            child: const Text(
              'BOOK AN AMBULANCE',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: _userRequests.length,
              itemBuilder: (context, index) {
                final request = _userRequests[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: request['status'] == 'PENDING'
                        ? Colors.yellow
                        : Colors.green,
                    child: Text(
                      request['status']!.substring(0, 1),
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                  title: Text(request['type']!),
                  subtitle: Text(
                      'Name: ${request['name']}\nPhone: ${request['phone']}\nAddress: ${request['address']}\nDate: ${request['date']}'),
                  trailing: Text(
                    request['status']!,
                    style: TextStyle(
                      color: request['status'] == 'PENDING'
                          ? Colors.yellow
                          : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
