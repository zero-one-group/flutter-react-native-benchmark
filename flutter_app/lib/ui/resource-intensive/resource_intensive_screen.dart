import 'package:flutter/material.dart';

class ResourceIntensiveScreen extends StatelessWidget {
  const ResourceIntensiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resource Intensive Test'),
      ),
      body: const Placeholder(),
    );
  }
}