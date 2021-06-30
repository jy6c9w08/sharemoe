import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:event_bus/event_bus.dart';

final EventBus eventBus = EventBus();

@module
abstract class eventBusConfig {

  @singleton
  EventBus get eventBus =>eventBus;
}
