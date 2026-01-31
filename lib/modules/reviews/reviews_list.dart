import 'package:flutter/material.dart';

class ReviewsList extends StatelessWidget {
  const ReviewsList({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ListTile(
          title: Text('Great Service'),
          subtitle: Text('Very helpful agent...'),
          trailing: Icon(Icons.star, color: Colors.amber),
        ),
        // More items
      ],
    );
  }
}
