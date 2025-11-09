import 'package:flutter/material.dart';

class AdCard extends StatelessWidget {
  const AdCard({super.key});

  // Ad model will be passed here

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        width: 150,
        child: Column(
          children: <Widget>[
            Container(
              height: 100,
              color: Colors.grey[400],
              child: const Center(child: Text('Ad Image')),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Ad Title'),
            ),
          ],
        ),
      ),
    );
  }
}
