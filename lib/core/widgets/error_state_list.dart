import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
      home: Scaffold(
        body: ErrorStateList(
          imageAssetName: 'images/error.png', 
          errorMessage: 'No Internet Connection, Please Try Again!', 
          onRetry: () {
            debugPrint("Reload the Page");
          },
        ),
      )
  )
  );
}

class ErrorStateList extends StatelessWidget {
  final String imageAssetName;
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorStateList(
    {super.key, 
    required this.imageAssetName, 
    required this.errorMessage, 
    required this.onRetry}
);

   @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imageAssetName,
            width: 100,
            height: 100,
          ),
          const SizedBox(
            height: 16,
          ),
          const Text("Something went wrong"),
          const SizedBox(
            height: 16,
          ),
          Text(errorMessage,
           textAlign: TextAlign.center,
          ),
          OutlinedButton(
            onPressed: onRetry,
             child: const Text('Try Again!'),
          ),
          const Text("or"),
          TextButton(onPressed: () {}, child: const Text('Contact Support')),
        ],
      ),
      ),
    );
  }
}