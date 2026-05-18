import 'package:flutter/material.dart';

class FancyLoginScreen extends StatefulWidget {
  const FancyLoginScreen({super.key});

  @override
  State<FancyLoginScreen> createState() => _FancyLoginScreenState();
}

class _FancyLoginScreenState extends State<FancyLoginScreen> {
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: pressed ? 250 : 200,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () {
                setState(() => pressed = !pressed);
              },
              child: const Text(
                "Entrar",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
