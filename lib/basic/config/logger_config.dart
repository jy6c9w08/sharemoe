// Package imports:
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

final Logger logger= Logger();

@module
abstract class LoggerConfig {

  @singleton
  Logger get loggers =>logger;
}
