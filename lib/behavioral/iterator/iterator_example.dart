import 'package:flutter/material.dart';

import 'iterator.dart';

class IteratorExample extends StatefulWidget {
  const IteratorExample({super.key});

  @override
  State createState() => _IteratorExampleState();
}

class _IteratorExampleState extends State<IteratorExample> {
  final List<ITreeCollection> treeCollections = [];

  int _selectedTreeCollectionIndex = 0;
  int? _currentNodeIndex = 0;
  bool _isTraversing = false;

  @override
  void initState() {
    super.initState();

    final graph = _buildGraph();
    treeCollections.add(BreadthFirstTreeCollection(graph));
    treeCollections.add(DepthFirstTreeCollection(graph));
  }

  Graph _buildGraph() {
    final graph = Graph();

    graph.addEdge(1, 2);
    graph.addEdge(1, 3);
    graph.addEdge(1, 4);
    graph.addEdge(2, 5);
    graph.addEdge(3, 6);
    graph.addEdge(3, 7);
    graph.addEdge(4, 8);

    return graph;
  }

  void _setSelectedTreeCollectionIndex(int? index) {
    setState(() {
      _selectedTreeCollectionIndex = index!;
    });
  }

  Future _traverseTree() async {
    _toggleIsTraversing();

    final iterator =
        treeCollections[_selectedTreeCollectionIndex].createIterator();

    while (iterator.hasNext()) {
      setState(() {
        _currentNodeIndex = iterator.getNext();
      });
      await Future.delayed(const Duration(seconds: 1));
    }

    _toggleIsTraversing();
  }

  void _toggleIsTraversing() {
    setState(() {
      _isTraversing = !_isTraversing;
    });
  }

  void _reset() {
    setState(() {
      _currentNodeIndex = 0;
    });
  }

  Color _getBackgroundColor(int index) {
    return _currentNodeIndex == index ? Colors.red[200]! : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: <Widget>[
              TreeCollectionSelection(
                treeCollections: treeCollections,
                selectedIndex: _selectedTreeCollectionIndex,
                onChanged:
                    !_isTraversing ? _setSelectedTreeCollectionIndex : null,
              ),
              const SizedBox(height: 32.0),
              Wrap(
                alignment: WrapAlignment.center,
                children: <Widget>[
                  TextButton(
                    onPressed: _currentNodeIndex == 0 ? _traverseTree : null,
                    child: const Text("Traverse"),
                  ),
                  TextButton(
                    onPressed:
                        _isTraversing || _currentNodeIndex == 0 ? null : _reset,
                    child: const Text("Reset"),
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              Box(
                nodeId: 1,
                color: _getBackgroundColor(1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: Box(
                        nodeId: 2,
                        color: _getBackgroundColor(2),
                        child: Box(
                          nodeId: 5,
                          color: _getBackgroundColor(5),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Box(
                        nodeId: 3,
                        color: _getBackgroundColor(3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Expanded(
                              child: Box(
                                nodeId: 6,
                                color: _getBackgroundColor(6),
                              ),
                            ),
                            Expanded(
                              child: Box(
                                nodeId: 7,
                                color: _getBackgroundColor(7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Box(
                        nodeId: 4,
                        color: _getBackgroundColor(4),
                        child: Box(
                          nodeId: 8,
                          color: _getBackgroundColor(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Box extends StatelessWidget {
  const Box({super.key, this.nodeId, this.color, this.child});

  final int? nodeId;
  final Color? color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.0,
      height: 100.0,
      color: color,
      child: Column(
        children: [
          Center(child: Text(nodeId.toString())),
          if (child != null) Expanded(child: child!),
        ],
      ),
    );
  }
}

class TreeCollectionSelection extends StatelessWidget {
  const TreeCollectionSelection({
    super.key,
    required this.treeCollections,
    required this.selectedIndex,
    this.onChanged,
  });

  final List<ITreeCollection> treeCollections;
  final int selectedIndex;
  final ValueChanged<int?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<int>(
      value: selectedIndex,
      items: treeCollections
          .map(
            (treeCollection) => DropdownMenuItem<int>(
              value: treeCollections.indexOf(treeCollection),
              child: Text(treeCollection.getTitle()),
            ),
          )
          .toList(),
      onChanged: onChanged,
    );
  }
}
