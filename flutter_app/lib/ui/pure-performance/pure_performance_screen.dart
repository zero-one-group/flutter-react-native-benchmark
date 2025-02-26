import 'package:flutter/material.dart';
import 'package:flutter_app/ui/pure-performance/pure_performance_viewmodel.dart';
import 'package:provider/provider.dart';

class PurePerformanceScreen extends StatelessWidget {
  const PurePerformanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pure Performance Test'),
      ),
      body: const ListItems(),
    );
  }
}

class ListItems extends StatefulWidget {
  const ListItems({super.key});

  @override
  State<ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends State<ListItems> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (mounted) {
        context.read<PurePerformanceViewModel>().getItems();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PurePerformanceViewModel, List<dynamic>>(
      selector: (_, viewModel) => viewModel.items,
      builder: (context, items, _) {
        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (_, index) => ListTile(title: Text(items[index].name)),
        );
      },
    );
  }
}
