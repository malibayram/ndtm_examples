import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'chain_of_responsibility.dart';

class ChainOfResponsibilityExample extends StatefulWidget {
  const ChainOfResponsibilityExample({super.key});

  @override
  State createState() => _ChainOfResponsibilityExampleState();
}

class _ChainOfResponsibilityExampleState
    extends State<ChainOfResponsibilityExample> {
  final LogBloc logBloc = LogBloc();

  late final LoggerBase logger;

  @override
  void initState() {
    super.initState();

    logger = DebugLogger(
      logBloc,
      nextLogger: InfoLogger(
        logBloc,
        nextLogger: ErrorLogger(logBloc),
      ),
    );
  }

  @override
  void dispose() {
    logBloc.dispose();
    super.dispose();
  }

  String get randomLog => faker.lorem.sentence();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: <Widget>[
              TextButton(
                onPressed: () => logger.logDebug(randomLog),
                child: const Text("Log Debug"),
              ),
              TextButton(
                onPressed: () => logger.logInfo(randomLog),
                child: const Text("Log Info"),
              ),
              TextButton(
                onPressed: () => logger.logError(randomLog),
                child: const Text("Log Error"),
              ),
              const Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: StreamBuilder<List<LogMessage>>(
                      initialData: const [],
                      stream: logBloc.outLogStream,
                      builder: (context, snapshot) {
                        final logMessages = snapshot.data ?? const [];

                        return Column(
                          children: [
                            for (final logMessage in logMessages)
                              logMessage.getFormattedMessage(),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
