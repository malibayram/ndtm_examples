import 'package:go_router/go_router.dart';

import '../behavioral/page_index.dart';
import '../creational/page_index.dart';
import '../main.dart';
import '../structural/page_index.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => MyHomePage(
        title: state.queryParams['type'] ?? "",
      ),
    ),
    GoRoute(
      path: '/behavioral',
      builder: (context, state) => const BehavioralPatternsPage(),
      routes: [
        GoRoute(
          path: 'mediator',
          builder: (context, state) => const MediatorExample(),
        ),
        GoRoute(
          path: 'visitor',
          builder: (context, state) => const VisitorExample(),
        ),
        GoRoute(
          path: 'template-method',
          builder: (context, state) => const TemplateMethodExample(),
        ),
        GoRoute(
          path: 'state',
          builder: (context, state) => const StateExample(),
        ),
        GoRoute(
          path: 'strategy',
          builder: (context, state) => const StrategyExample(),
        ),
        GoRoute(
          path: 'observer',
          builder: (context, state) => const ObserverExample(),
        ),
        GoRoute(
          path: 'memento',
          builder: (context, state) => const MementoExample(),
        ),
        GoRoute(
          path: 'iterator',
          builder: (context, state) => const IteratorExample(),
        ),
        GoRoute(
          path: 'command',
          builder: (context, state) => const CommandExample(),
        ),
        GoRoute(
          path: 'chain-of-responsibility',
          builder: (context, state) => const ChainOfResponsibilityExample(),
        ),
      ],
    ),
    GoRoute(
      path: '/behavioral/:type',
      builder: (context, state) => MyHomePage(
        title: state.queryParams['type'] ?? state.params['type'] ?? "",
      ),
    ),
    GoRoute(
      path: '/structural',
      builder: (context, state) => const StructuralPatternsPage(),
      routes: [
        GoRoute(
          path: 'proxy',
          builder: (context, state) => const ProxyExample(),
        ),
        GoRoute(
          path: 'flyweight',
          builder: (context, state) => const FlyweightExample(),
        ),
        GoRoute(
          path: 'facade',
          builder: (context, state) => const FacadeExample(),
        ),
        GoRoute(
          path: 'decorator',
          builder: (context, state) => const DecoratorExample(),
        ),
        GoRoute(
          path: 'composite',
          builder: (context, state) => const CompositeExample(),
        ),
        GoRoute(
          path: 'bridge',
          builder: (context, state) => const BridgeExample(),
        ),
        GoRoute(
          path: 'adapter',
          builder: (context, state) => const AdapterExample(),
        ),
      ],
    ),
    GoRoute(
      path: '/structural/:type',
      builder: (context, state) => MyHomePage(
        title: state.queryParams['type'] ?? state.params['type'] ?? "",
      ),
    ),
    GoRoute(
      path: '/creational',
      builder: (context, state) => const CreationalPatternsPage(),
      routes: [
        GoRoute(
          path: 'singleton',
          builder: (context, state) => const SingletonExample(),
        ),
        GoRoute(
          path: 'prototype',
          builder: (context, state) => const PrototypeExample(),
        ),
        GoRoute(
          path: 'builder',
          builder: (context, state) => const BuilderExample(),
        ),
        GoRoute(
          path: 'factory-method',
          builder: (context, state) => const FactoryMethodExample(),
        ),
        GoRoute(
          path: 'abstract-factory',
          builder: (context, state) => const AbstractFactoryExample(),
        ),
      ],
    ),
    GoRoute(
      path: '/creational/:type',
      builder: (context, state) => MyHomePage(
        title: state.queryParams['type'] ?? state.params['type'] ?? "",
      ),
    ),
  ],
);
