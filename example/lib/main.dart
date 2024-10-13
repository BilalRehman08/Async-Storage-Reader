import 'package:async_storage_reader/async_storage_reader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AsyncStorageReaderTestUI(),
    );
  }
}

class AsyncStorageReaderTestUI extends StatefulWidget {
  const AsyncStorageReaderTestUI({super.key});

  @override
  State<AsyncStorageReaderTestUI> createState() =>
      _AsyncStorageReaderTestUIState();
}

class _AsyncStorageReaderTestUIState extends State<AsyncStorageReaderTestUI> {
  final _keyController = TextEditingController();
  final _valueController = TextEditingController();
  String _result = '';

  // Instance of AsyncStorageReader, initialized once
  late final AsyncStorageReader _storageReader;

  @override
  void initState() {
    super.initState();

    // Initialize AsyncStorageReader
    _storageReader = AsyncStorageReader();
  }

  void _setResult(String result) {
    setState(() {
      _result = result;
    });
  }

  Future<void> _getItem() async {
    final key = _keyController.text;
    if (key.isEmpty) {
      _setResult('Please enter a key');
      return;
    }
    final value = await _storageReader.getItem(key);
    _setResult('Get Item Result: $value');
  }

  Future<void> _getAllItems() async {
    final items = await _storageReader.getAllItems();
    if (items.isEmpty) {
      _setResult('No items found in storage.');
    } else {
      _setResult(
          'Get All Items Result:\n${items.entries.map((e) => '${e.key}: ${e.value}').join('\n')}');
    }
  }

  Future<void> _removeItem() async {
    final key = _keyController.text;
    if (key.isEmpty) {
      _setResult('Please enter a key');
      return;
    }
    final success = await _storageReader.removeItem(key);
    _setResult('Remove Item Result: ${success ? 'Success' : 'Failed'}');
  }

  Future<void> _clear() async {
    final success = await _storageReader.clear();
    _setResult('Clear Result: ${success ? 'Success' : 'Failed'}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AsyncStorageReader Test'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _keyController,
              decoration: const InputDecoration(labelText: 'Key'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Value'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getItem,
              child: const Text('Get Item'),
            ),
            ElevatedButton(
              onPressed: _getAllItems,
              child: const Text('Get All Items'),
            ),
            ElevatedButton(
              onPressed: _removeItem,
              child: const Text('Remove Item'),
            ),
            ElevatedButton(
              onPressed: _clear,
              child: const Text('Clear All'),
            ),
            const SizedBox(height: 16),
            const Text('Result:'),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4),
              ),
              child: SelectableText(
                  _result), // Changed to SelectableText for easy copying
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _keyController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
