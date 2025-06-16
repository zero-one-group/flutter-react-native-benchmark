import 'package:flutter/material.dart';
import 'package:flutter_app/ui/resource-intensive/resource_intensive_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

class ResourceIntensiveScreen extends StatelessWidget {
  const ResourceIntensiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Resource Intensive Test')),
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
  late final Animation<Color?> _borderColorTween;

  bool get isAnimationEnabled => true;

  static const _imageSize = 200.0;
  static const _gridDelegateParams = SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 1.0,
    mainAxisSpacing: 4.0,
    crossAxisSpacing: 4.0,
  );

  @override
  void initState() {
    super.initState();
    _setupAnimation();

    // Use addPostFrameCallback instead of Future.microtask for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ResourceIntensiveViewModel>().getItems();
      }
    });
  }

  void _setupAnimation() {
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

    _borderColorTween = ColorTween(
      begin: const Color(0xFFF50000),
      end: const Color(0xFF00F535),
    ).animate(_controller);

    if (isAnimationEnabled) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Positioned(
          left: (size.width - _imageSize) / 2,
          top: (size.height - _imageSize) / 2 - 50,
          width: _imageSize,
          height: _imageSize,
          child:
              isAnimationEnabled
                  ? RotationTransition(
                    turns: _controller,
                    child: Image.asset('images/rotating-image.png'),
                  )
                  : Image.asset('images/rotating-image.png'),
        ),
        Positioned.fill(
          child: Selector<ResourceIntensiveViewModel, List<dynamic>>(
            selector: (_, viewModel) => viewModel.items,
            builder: (context, items, _) {
              return ReorderableGridView.builder(
                onReorder: (oldIndex, newIndex) {
                  context.read<ResourceIntensiveViewModel>().reorderItems(
                    oldIndex,
                    newIndex,
                  );
                },
                gridDelegate: _gridDelegateParams,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final isEven = index % 2 == 0;

                  if (isAnimationEnabled) {
                    return AnimatedBuilder(
                      key: ValueKey(items[index].id),
                      animation: _controller,
                      builder: (context, _) {
                        return Card(
                          color:
                              isEven
                                  ? _cardColorTweenEven.value
                                  : _cardColorTweenOdd.value,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color: _borderColorTween.value!,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    );
                  } else {
                    return Card(
                      key: ValueKey(items[index].id),
                      color: Colors.red,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.blue, width: 2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    );
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
