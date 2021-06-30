import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:event_bus/event_bus.dart';



@module
abstract class eventBusConfig {

  @singleton
  EventBus get eventBus =>EventBus();
}
