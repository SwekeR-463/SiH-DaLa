import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

final dbref = FirebaseDatabase.instance.ref();

class ESPTestPage extends StatefulWidget {
  const ESPTestPage({super.key});

  @override
  State<ESPTestPage> createState() => _ESPTestPageState();
}

class _ESPTestPageState extends State<ESPTestPage> {
  int ledStatus = 0;
  bool isLoading = false;

  getLEDStatus() async {
    await dbref.child("LED_STATUS").once().then((DatabaseEvent event) {
      DataSnapshot snapshot = event.snapshot;
      ledStatus = snapshot.value as int;
      print(ledStatus);
    });

    setState(() {
      isLoading = false;
    });
  }

  buttonPressed() {
    ledStatus == 0
        ? dbref.child('LED_STATUS').set(1)
        : dbref.child('LED_STATUS').set(0);
    if (ledStatus == 0) {
      setState(() {
        ledStatus = 1;
      });
    } else {
      setState(() {
        ledStatus = 0;
      });
    }
  }

  @override
  void initState() {
    isLoading = true;
    getLEDStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'IOT App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: const OvalBorder(),
                    padding: const EdgeInsets.all(64)),
                child: Text(
                  (ledStatus == 1) ? 'On' : 'Off',
                  style: const TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  buttonPressed();
                },
              ),
      ),
    );
  }
}
