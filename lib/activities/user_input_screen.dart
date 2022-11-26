import 'package:flutter/material.dart';

class UserInputScreen extends StatefulWidget {
  final dynamic postData;

  const UserInputScreen({Key? key, @required this.postData}) : super(key: key);

  @override
  State<UserInputScreen> createState() {
    return _UserInputScreenState();
  }
}

class _UserInputScreenState extends State<UserInputScreen> {
  String notificationData = "";

  @override
  Widget build(BuildContext context) {
    notificationData = widget.postData['CarID'];
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [Text(notificationData)],
            ),
          ),
        ),
      ),
    );
  }
}
