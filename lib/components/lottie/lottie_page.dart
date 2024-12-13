import 'package:flutter/material.dart';

class Lottiepage extends StatefulWidget {
  const Lottiepage({super.key});

  @override
  State<Lottiepage> createState() => _LottiepageState();
}

class _LottiepageState extends State<Lottiepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          // gradient: LinearGradient(
          //   colors: [
          //     Color(0xFFFFDE4D),
          //     Color(0xFFFFB22C),
          //     Color.fromARGB(199, 248, 85, 4),
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        child: Center(
          child: Image.network(
            'https://cdn.evhomes.tech/44552d81-3c4e-4ec8-8935-ece01307d09a-NINE%20SQUARE%20new%20logo%20final%20%C3%A0%C2%A5%C2%A7.png?token=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJmaWxlbmFtZSI6IjQ0NTUyZDgxLTNjNGUtNGVjOC04OTM1LWVjZTAxMzA3ZDA5YS1OSU5FIFNRVUFSRSBuZXcgbG9nbyBmaW5hbCDDoMKlwqcucG5nIiwiaWF0IjoxNzMzODM5Mjc4fQ.smkSbBADThX6PSljaD46catKx-dWbvNqKNBgpn0s2ek',
            width: 200,
            height: 300,
          ),
        ),
      ),
    );
  }
}
