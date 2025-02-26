import 'package:flutter/material.dart';
import 'package:flutter_app/ui/input-responsiveness/input_responsiveness_screen.dart';
import 'package:flutter_app/ui/pure-performance/pure_performance_screen.dart';
import 'package:flutter_app/ui/resource-intensive/resource_intensive_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'images/zog-logo.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 16),
            const Text('Performance Test'),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _Button(
              title: 'Pure UI Performance Test',
              onPressed: () => _navigateToScreen(
                context,
                const PurePerformanceScreen(),
              ),
            ),
            const SizedBox(height: 16),
            _Button(
              title: 'Resource Intensive Test', 
              onPressed: () => _navigateToScreen(
                context,
                const ResourceIntensiveScreen(),
              ),
            ),
            const SizedBox(height: 16),
            _Button(
              title: 'Input Responsiveness Test',
              onPressed: () => _navigateToScreen(
                context,
                const InputResponsivenessScreen(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.title,
    required this.onPressed,
  });

  final String title;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
