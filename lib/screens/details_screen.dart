import 'dart:io';

import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen(
      this.image1, this.name, this.email, this.place, this.phoneNumber,
      {Key? key})
      : super(key: key);
  final String image1;
  final String name;
  final String email;
  final String place;
  final String phoneNumber;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: 120,
              child: Image.file(
                File(image1),
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 100,
            ),
            Row(
              children: [
                Text(
                  "Name :",
                  style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis),
                ),
                Text(" $name",
                    style: const TextStyle(fontSize: 30),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              children: [
                Text(
                  "Gmail :",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(" $email",
                    style: const TextStyle(fontSize: 30),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              children: [
                Text(
                  "Number :",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(" $phoneNumber",
                    style: const TextStyle(fontSize: 30),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
            Row(
              children: [
                Text(
                  "Place :",
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(" $place",
                    style: const TextStyle(fontSize: 30),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
