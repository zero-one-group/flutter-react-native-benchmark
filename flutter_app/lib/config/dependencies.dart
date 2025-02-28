import 'package:flutter_app/data/repositories/item_repository.dart';
import 'package:flutter_app/data/services/local_data_service.dart';
import 'package:flutter_app/domain/item_usecase.dart';
import 'package:flutter_app/ui/pure-performance/pure_performance_viewmodel.dart';
import 'package:flutter_app/ui/resource-intensive/resource_intensive_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providersLocal {
  return [
    // Services
    Provider<LocalDataService>(create: (_) => LocalDataService()),

    // Repositories
    Provider<ItemRepository>(
      create:
          (context) => ItemRepository(
            localDataService: context.read<LocalDataService>(),
          ),
    ),

    // Usecases
    Provider<ItemUsecase>(
      create:
          (context) =>
              ItemUsecase(itemRepository: context.read<ItemRepository>()),
    ),

    // ViewModels
    ChangeNotifierProvider<PurePerformanceViewModel>(
      create:
          (context) => PurePerformanceViewModel(
            itemUsecase: context.read<ItemUsecase>(),
          ),
    ),
    ChangeNotifierProvider<ResourceIntensiveViewModel>(
      create:
          (context) => ResourceIntensiveViewModel(
            itemUsecase: context.read<ItemUsecase>(),
          ),
    ),
  ];
}
