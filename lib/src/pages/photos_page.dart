import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photos'),
        backwardsCompatibility: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  Image.asset('images/img1.jpg', fit: BoxFit.cover),
                  SizedBox(height: 16),
                  Image.asset('images/img2.jpg', fit: BoxFit.cover),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
