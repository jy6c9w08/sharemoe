import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

final Logger logger= Logger();

@module
abstract class LoggerConfig {
/*
  @preResolve
  @singleton
  Future<Logger> get loggers =>Future.value(logger);
*/

  @singleton
  Logger get loggers =>logger;
}
