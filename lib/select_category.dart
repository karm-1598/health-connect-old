import 'package:flutter/material.dart';
import 'package:health_connect2/routes/app_navigator.dart';

class select_category extends StatefulWidget {
  const select_category({super.key});

  @override
  State<select_category> createState() => _select_categoryState();
}

class _select_categoryState extends State<select_category> {
  final List<String> services = <String>[
    'Doctor',
    'Nurse',
    'Lab',
    'Physiotherapist'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Category',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(4, 63, 140, 1),
        elevation: 5,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          child: ListView.builder(
            itemCount: services.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8, // Add shadow for better visuals
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  tileColor: const Color.fromRGBO(196, 241, 228, 1),
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue[100],
                    child: Icon(
                      _getIconForService(services[index]),
                      color: const Color.fromRGBO(4, 63, 140, 1),
                    ),
                  ),
                  title: Text(
                    services[index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                  onTap: () {
                    _navigateToService(index);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  IconData _getIconForService(String service) {
    switch (service) {
      case 'Doctor':
        return Icons.medical_services;
      case 'Nurse':
        return Icons.local_hospital;
      case 'Lab':
        return Icons.science;
      case 'Physiotherapist':
        return Icons.fitness_center;
      default:
        return Icons.help_outline;
    }
  }

  void _navigateToService(int index) {
    switch (services[index]) {
      case 'Doctor':
        goto.openDocResgistration();
        break;
      case 'Nurse':
        goto.openNurseRegistration();
        break;
      case 'Lab':
        goto.openLabRegistration();
        break;
      case 'Physiotherapist':
        goto.openPhysioRegistration();
        break;
    }
  }
}
