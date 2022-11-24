import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';
import 'utils/dynamic_link_injection_container.dart';
import 'utils/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  usePathUrlStrategy();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Dart & Flutter Design Patterns',
      theme: ThemeData(primarySwatch: Colors.blue),
      routerConfig: router,
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    _counter++;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(dynamicLinkNotifierProvider.notifier).getInitialLink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(dynamicLinkNotifierProvider, (_, newPath) {
      if (newPath != null) {
        context.push(newPath);
        ref.read(dynamicLinkNotifierProvider.notifier).clear();
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.push("/behavioral");
              },
              child: const Text('Go to behavioral patterns'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.push("/structural");
              },
              child: const Text('Go to structural patterns'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                context.push("/creational");
              },
              child: const Text('Go to creational patterns'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
