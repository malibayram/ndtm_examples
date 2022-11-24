import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

enum LogLevel {
  Debug,
  Info,
  Error,
}

extension LogLevelExtensions on LogLevel {
  bool operator <=(LogLevel logLevel) => index <= logLevel.index;
}

class LogMessage {
  final LogLevel logLevel;
  final String message;

  const LogMessage({required this.logLevel, required this.message});

  String get _logLevelString =>
      logLevel.toString().split('.').last.toUpperCase();

  Color _getLogEntryColor() {
    switch (logLevel) {
      case LogLevel.Debug:
        return Colors.grey;
      case LogLevel.Info:
        return Colors.blue;
      case LogLevel.Error:
        return Colors.red;
      default:
        throw Exception("Log level '$logLevel' is not supported.");
    }
  }

  Widget getFormattedMessage() {
    return Text(
      '$_logLevelString: $message',
      style: TextStyle(
        color: _getLogEntryColor(),
      ),
      textAlign: TextAlign.justify,
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}

class LogBloc {
  final _logs = <LogMessage>[];
  final _logStream = StreamController<List<LogMessage>>();

  StreamSink<List<LogMessage>> get _inLogStream => _logStream.sink;
  Stream<List<LogMessage>> get outLogStream => _logStream.stream;

  void log(LogMessage logMessage) {
    _logs.add(logMessage);
    _inLogStream.add(UnmodifiableListView(_logs));
  }

  void dispose() {
    _logStream.close();
  }
}

class ExternalLoggingService {
  final LogBloc logBloc;

  ExternalLoggingService(this.logBloc);

  void logMessage(LogLevel logLevel, String message) {
    final logMessage = LogMessage(logLevel: logLevel, message: message);

    // Send log message to the external logging service

    // Log message
    logBloc.log(logMessage);
  }
}

class MailService {
  final LogBloc logBloc;

  MailService(this.logBloc);

  void sendErrorMail(LogLevel logLevel, String message) {
    final logMessage = LogMessage(logLevel: logLevel, message: message);

    // Send error mail

    // Log message
    logBloc.log(logMessage);
  }
}

abstract class LoggerBase {
  @protected
  final LogLevel logLevel;
  final LoggerBase? _nextLogger;

  const LoggerBase({
    required this.logLevel,
    LoggerBase? nextLogger,
  }) : _nextLogger = nextLogger;

  void logMessage(LogLevel level, String message) {
    if (logLevel <= level) {
      log(message);
    }

    _nextLogger?.logMessage(level, message);
  }

  void logDebug(String message) => logMessage(LogLevel.Debug, message);
  void logInfo(String message) => logMessage(LogLevel.Info, message);
  void logError(String message) => logMessage(LogLevel.Error, message);

  void log(String message);
}

class DebugLogger extends LoggerBase {
  final LogBloc logBloc;

  const DebugLogger(
    this.logBloc, {
    super.nextLogger,
  }) : super(logLevel: LogLevel.Debug);

  @override
  void log(String message) {
    final logMessage = LogMessage(logLevel: logLevel, message: message);

    logBloc.log(logMessage);
  }
}

class InfoLogger extends LoggerBase {
  late ExternalLoggingService externalLoggingService;

  InfoLogger(
    LogBloc logBloc, {
    super.nextLogger,
  })  : externalLoggingService = ExternalLoggingService(logBloc),
        super(logLevel: LogLevel.Info);

  @override
  void log(String message) {
    externalLoggingService.logMessage(logLevel, message);
  }
}

class ErrorLogger extends LoggerBase {
  late MailService mailService;

  ErrorLogger(
    LogBloc logBloc, {
    super.nextLogger,
  })  : mailService = MailService(logBloc),
        super(logLevel: LogLevel.Error);

  @override
  void log(String message) {
    mailService.sendErrorMail(logLevel, message);
  }
}
