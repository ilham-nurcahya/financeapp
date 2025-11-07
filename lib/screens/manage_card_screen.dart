import 'package:flutter/material.dart';

class ManageCardScreen extends StatelessWidget {
  const ManageCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // debug log untuk memastikan build terpanggil
    // (hapus nanti bila sudah ok)
    // ignore: avoid_print
    print('>> ManageCardScreen build()');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Cards'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            // debug print
            // ignore: avoid_print
            print('>> ManageCardScreen: back pressed');
            Navigator.of(context).pop();
          },
        ),
      ),
      // warna background kontras supaya tidak "kosong"
      backgroundColor: const Color(0xFFEFF6FF),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.credit_card, size: 64, color: Colors.blueAccent),
              const SizedBox(height: 12),
              const Text('Manage your cards', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('List, add or remove cards from here', textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // quick test: pop kembali
                  // ignore: avoid_print
                  print('>> ManageCardScreen: pressing "Back to Home"');
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Back to Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
