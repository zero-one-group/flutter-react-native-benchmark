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
  late final Animation<Color?> _cardColorTweenEven;
  late final Animation<Color?> _cardColorTweenOdd;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _cardColorTweenEven = ColorTween(
      begin: const Color(0xFFFF6969),
      end: const Color(0xFF6987FF),
    ).animate(_controller);

    _cardColorTweenOdd = ColorTween(
      begin: const Color(0xFF6987FF),
      end: const Color(0xFFFF6969),
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
          child: Consumer<InputResponsivenessViewModel>(
            builder: (context, viewModel, _) {
              if (viewModel.animationEnabled) {
                _controller.repeat();
              } else {
                _controller.stop();
              }
              return RotationTransition(
                turns: _controller,
                child: Image.asset('images/rotating-image.png'),
              );
            },
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
                      viewModel.shouldShowGrid ? 'Show List' : 'Hide List',
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
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              mainAxisSpacing: 4.0,
                              crossAxisSpacing: 4.0,
                            ),
                        itemCount: viewModel.items.length,
                        itemBuilder: (context, index) {
                          final isEven = index % 2 == 0;
                          return AnimatedBuilder(
                            key: ValueKey(viewModel.items[index].id),
                            animation: _controller,
                            builder: (context, _) {
                              return Card(
                                color:
                                    viewModel.animationEnabled
                                        ? (isEven
                                            ? _cardColorTweenEven.value
                                            : _cardColorTweenOdd.value)
                                        : (isEven
                                            ? const Color(0xFFFF6969)
                                            : const Color(0xFF6987FF)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
