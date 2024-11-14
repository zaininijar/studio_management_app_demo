import 'package:flutter/material.dart';

class StudioListScreen extends StatelessWidget {
  const StudioListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Studios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to add studio screen
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 10, // Replace with actual studio list length
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: const Icon(Icons.music_note),
              title: Text('Studio ${index + 1}'),
              subtitle: const Text('₱500/hour'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Navigate to studio details
              },
            ),
          );
        },
      ),
    );
  }
}