import 'package:flutter/material.dart';
import 'package:flutter_app/ui/input-responsiveness/input_responsiveness_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class InputResponsivenessScreen extends StatelessWidget {
  const InputResponsivenessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Responsiveness Test')),
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
        context.read<InputResponsivenessViewModel>().getItems();
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
          child: Consumer<InputResponsivenessViewModel>(
            builder: (context, viewModel, _) {
              return Column(
                children: [
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color(
                          viewModel.shouldShowGrid ? 0xFF2D02FF : 0xFFFF0202,
                        ),
                      ),
                    ),
                    onPressed: () {
                      viewModel.toggleGrid();
                    },
                    child: Text(
                      viewModel.shouldShowGrid ? 'show list' : 'hide list',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  if (viewModel.shouldShowGrid)
                    Expanded(
                      child: ReorderableGridView.builder(
                        onReorder: (oldIndex, newIndex) {
                          viewModel.reorderItems(oldIndex, newIndex);
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                        itemCount: viewModel.items.length,
                        itemBuilder: (context, index) {
                          return AnimatedBuilder(
                            key: ValueKey(viewModel.items[index].id),
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
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
