// Package imports:
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

// Project imports:
import 'get_it_config.config.dart';

final GetIt getIt = GetIt.asNewInstance();

@InjectableInit(
  initializerName: r'$initGetIt', // default
  preferRelativeImports: true, // default
  asExtension: false, // default
)
Future configureDependencies() => $initGetIt(getIt);
