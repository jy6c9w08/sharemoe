import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@module
abstract class LoggerConfig {
  @lazySingleton
  Logger get logger => Logger();
}
