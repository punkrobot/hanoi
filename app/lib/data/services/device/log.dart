import 'package:logger/logger.dart';

class Log {
  static late Logger logger;

  static init() {
    logger = Logger(
      filter: null,
      printer: PrettyPrinter(
        methodCount: 0,
        lineLength: 80,
        colors: true,
        printEmojis: false,
      ),
      output: null,
    );
  }

  static v(String message) {
    logger.t(message);
  }

  static d(String message) {
    logger.d(message);
  }

  static w(String message, {dynamic ex, StackTrace? stacktrace}) {
    logger.w(message, error: ex, stackTrace: stacktrace);
  }

  static e(String message, {dynamic ex, StackTrace? stacktrace}) {
    logger.e(message, error: ex, stackTrace: stacktrace);
  }
}
