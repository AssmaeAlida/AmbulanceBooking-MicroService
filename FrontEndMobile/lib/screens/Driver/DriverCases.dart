import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DriverCasesScreen(),
    );
  }
}

class DriverCasesScreen extends StatefulWidget {
  @override
  _DriverCasesScreenState createState() => _DriverCasesScreenState();
}

class _DriverCasesScreenState extends State<DriverCasesScreen> {
  // Liste des statuts disponibles
  final List<String> statuses = ["Pending", "Completed", "Canceled"];
  String selectedStatus = "Pending";

  // Exemple de données de cas
  final List<Map<String, String>> allCases = [
    {
      "name": "Henson Marin",
      "phone": "432 213 190700",
      "address": "Hot Marian",
      "type": "Medical",
      "date": "31/10/2023 - 19:00",
      "quantity": "Minor",
      "status": "Completed"
    },
    {
      "name": "Henson Marin",
      "phone": "432 213 190700",
      "address": "Hot Marian",
      "type": "Other",
      "date": "31/10/2023 - 19:07",
      "quantity": "Minor",
      "status": "Canceled"
    },
    {
      "name": "Marcel Marsh",
      "phone": "432 315 190990",
      "address": "Hot Marian",
      "type": "Other",
      "date": "10/10/2023 - 15:00",
      "quantity": "Minor",
      "status": "Canceled"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Cases"),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          // Menu déroulant pour sélectionner le statut
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue!;
                });
              },
              items: statuses.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(
                    status,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              }).toList(),
            ),
          ),

          // Liste des cas filtrée par statut sélectionné
          Expanded(
            child: ListView(
              children: allCases
                  .where((caseItem) => caseItem['status'] == selectedStatus)
                  .map((caseItem) => DriverCaseCard(caseItem: caseItem))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class DriverCaseCard extends StatelessWidget {
  final Map<String, String> caseItem;

  const DriverCaseCard({Key? key, required this.caseItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name: ${caseItem['name']}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 5),
            Text("Phone: ${caseItem['phone']}"),
            Text("Address: ${caseItem['address']}"),
            Text("Type: ${caseItem['type']}"),
            Text("Date: ${caseItem['date']}"),
            Text("Quantity: ${caseItem['quantity']}"),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: getStatusColor(caseItem['status']!),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  caseItem['status']!.toUpperCase(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Méthode pour définir la couleur en fonction du statut
  Color getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return Colors.green;
      case "Canceled":
        return Colors.red;
      case "Pending":
      default:
        return Colors.orange;
    }
  }
}
