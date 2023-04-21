import 'package:flutter/material.dart';
import 'package:flutter_rcim/engine.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              height: 50,
            ),
            TextButton(
              onPressed: () async {
                await EngineManager.instance.init();
              },
              child: const Text('init'),
            ),
            TextButton(
              onPressed: () async {
                await EngineManager.instance.destroy();
              },
              child: const Text('destroy'),
            ),
            TextButton(
              onPressed: () async {
                await EngineManager.instance.connect();
              },
              child: const Text('Connect'),
            ),
            TextButton(
              onPressed: () async {
                await EngineManager.instance.disconnect();
              },
              child: const Text('disConnect'),
            ),
            TextButton(
              onPressed: () async {
                await EngineManager.instance
                    .getSessions(null, DateTime.now().millisecondsSinceEpoch, 50);
              },
              child: const Text('getSessions'),
            ),
          ],
        ),
      ),
    );
  }
}
