import 'package:flutter/material.dart';
import 'package:studio_management/screens/add_studio_screen.dart';

class AssetListScreen extends StatelessWidget {
  const AssetListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assets'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddStudioScreen()),
              )
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Replace with actual asset list length
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.devices),
              title: Text('Asset ${index + 1}'),
              subtitle: const Text('In Good Condition'),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'edit',
                    child: Text('Edit'),
                  ),
                  const PopupMenuItem(
                    value: 'maintenance',
                    child: Text('Schedule Maintenance'),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text('Delete'),
                  ),
                ],
                onSelected: (value) {
                  // Handle menu item selection
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
