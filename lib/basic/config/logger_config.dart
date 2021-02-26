import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

Logger logger= Logger();

@module
abstract class LoggerConfig {
  @lazySingleton
  Logger get logger =>logger;
}
