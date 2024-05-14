import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DebugPage extends StatelessWidget {
  final ValueListenable<List<Widget>> notifier;
  final void Function() onClear;

  const DebugPage({super.key, required this.notifier, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        title: const Text('Logs', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            onPressed: onClear,
            icon: const Icon(Icons.delete, color: Colors.white),
          ),
        ],
      ),
      body: _buildTerminal(context),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildTerminal(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.black,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: Colors.white,
        ),
        child: ValBuilder(
          listenable: notifier,
          builder: (widgets) {
            return ListView.builder(
              itemCount: widgets.length,
              itemBuilder: (context, index) {
                return widgets[index];
              },
            );
          },
        ),
      ),
    );
  }
}