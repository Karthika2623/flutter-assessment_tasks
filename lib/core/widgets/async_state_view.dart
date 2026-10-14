import 'package:flutter/material.dart';

class AsyncStateView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final bool isEmpty;
  const AsyncStateView({super.key, required this.message, required this.onRetry, this.isEmpty = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 76, height: 76,
            decoration: BoxDecoration(color: const Color(0xFFE9E4FF), borderRadius: BorderRadius.circular(24)),
            child: Icon(isEmpty ? Icons.search_off_rounded : Icons.wifi_off_rounded, color: const Color(0xFF6C4DFF), size: 34),
          ),
          const SizedBox(height: 18),
          Text(isEmpty ? 'Nothing found' : 'Something went wrong', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF6F6B86), height: 1.5)),
          const SizedBox(height: 18),
          FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Try again')),
        ]),
      ),
    );
  }
}
