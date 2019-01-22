import 'dart:async';

import 'package:bloc_demo/bloc/bloc_provider.dart';
import 'package:flutter/material.dart';

class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'bloc demo',
      theme: new ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider<IncrementBloc>(
        bloc: IncrementBloc(),
        child: CounterPage(),
      ),
    );
  }
}

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IncrementBloc bloc = BlocProvider.of<IncrementBloc>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Stream version of the Counter APP'),
      ),
      body: StreamBuilder<int>(
        stream: bloc.outCounter,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
          return Text('You hit me : ${snapshot.data} times');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          bloc.incrementCounter.add(null);
        },
        child: const Icon(Icons.airplanemode_active),
      ),
    );
  }
}

class IncrementBloc implements BlocBase {
  int _counter;

  StreamController<int> _counterController = StreamController<int>();

  StreamSink<int> get _inAdd => _counterController.sink;

  Stream<int> get outCounter => _counterController.stream;

  StreamController _actionController = StreamController();

  StreamSink get incrementCounter => _actionController.sink;

  IncrementBloc() {
    _counter = 0;
    _actionController.stream.listen(_handleLogic);
  }

  @override
  void dispose() {
    _counterController.close();
    _actionController.close();
  }

  void _handleLogic(data) {
    _counter++;
    _inAdd.add(_counter);
  }
}
