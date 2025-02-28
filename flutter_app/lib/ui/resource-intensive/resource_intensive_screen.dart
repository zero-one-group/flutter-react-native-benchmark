import 'package:flutter/material.dart';
import 'package:flutter_app/ui/resource-intensive/resource_intensive_viewmodel.dart';
import 'package:provider/provider.dart';

class ResourceIntensiveScreen extends StatelessWidget {
  const ResourceIntensiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resource Intensive Test')),
      body: const BodyContent(),
    );
  }
}

class BodyContent extends StatefulWidget {
  const BodyContent({super.key});

  @override
  State<BodyContent> createState() => _BodyContentState();
}

class _BodyContentState extends State<BodyContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Color?> _cardColorTween;
  late final Animation<Color?> _borderColorTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _cardColorTween = ColorTween(
      begin: const Color(0xFFFF6969),
      end: const Color(0xFF6987FF),
    ).animate(_controller);

    _borderColorTween = ColorTween(
      begin: const Color(0xFFF50000),
      end: const Color(0xFF00F535),
    ).animate(_controller);

    // Use addPostFrameCallback instead of Future.microtask for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ResourceIntensiveViewModel>().getItems();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    const imageSize = 200.0;
    
    return Stack(
      children: [
        Positioned(
          left: (size.width - imageSize) / 2,
          top: (size.height - imageSize) / 2 - 50,
          width: imageSize,
          height: imageSize,
          child: RotationTransition(
            turns: _controller,
            child: Image.asset('images/rotating-image.jpg'),
          ),
        ),
        Positioned.fill(
          child: Consumer<ResourceIntensiveViewModel>(
            builder: (context, viewModel, _) {
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                ),
                itemCount: viewModel.items.length,
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _controller,
                    builder: (context, _) {
                      return Card(
                        color: _cardColorTween.value,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: _borderColorTween.value!,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            viewModel.items[index].name,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
