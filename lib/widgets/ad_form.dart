import 'package:flutter/material.dart';

class AdForm extends StatefulWidget {
  const AdForm({super.key});

  @override
  _AdFormState createState() => _AdFormState();
}

class _AdFormState extends State<AdForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Title'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Description'),
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Price'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text('Post Ad'),
          ),
        ],
      ),
    );
  }
}
