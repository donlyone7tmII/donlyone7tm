import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
      home: Scaffold(
        body: EmptyStateList(
          imageAssetName: 'images/empty.png', 
          title: 'Oops.....there is nothing here', 
          description: "Tap '+' button to add a new Subscription",
        ),
      )
  ));
}

class EmptyStateList extends StatelessWidget {
  final String imageAssetName;
  final String title;
  final String description;

  const EmptyStateList({super.key, 
    required this.imageAssetName, 
    required this.title, 
    required this.description});

   @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display the image asset
          Image.asset(
            imageAssetName,
            width: 100,
            height: 100,
          ),
          const SizedBox(height: 16), // Spacing between image and title
          // Title text
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8), // Spacing between title and description
          // Description text
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}