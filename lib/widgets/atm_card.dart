import 'package:flutter/material.dart';

class AtmCard extends StatelessWidget {
  final String bankName;
  final String cardNumber;
  final String balance;
  final Color color1;
  final Color color2;

  const AtmCard({
    super.key,
    required this.bankName,
    required this.cardNumber,
    required this.balance,
    required this.color1,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(colors: [color1, color2], begin: Alignment.topLeft, end: Alignment.bottomRight),
        boxShadow: [
          BoxShadow(color: color2.withOpacity(0.28), blurRadius: 14, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // row atas: bank name + logo placeholder
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(bankName,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              // logo placeholder (bisa diganti asset)
              Container(
                width: 48,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Icon(Icons.account_balance, color: Colors.white, size: 18)),
              ),
            ],
          ),

          const Spacer(),

          // chip & card number
          Row(
            children: [
              // chip
              Container(
                width: 44,
                height: 30,
                decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(6)),
                child: const Icon(Icons.memory, color: Colors.white70, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(cardNumber, style: const TextStyle(color: Colors.white70, fontSize: 16, letterSpacing: 1.2)),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // balance
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Balance', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text(balance, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ]),
              // card type
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: const [
                  Icon(Icons.credit_card, color: Colors.white70, size: 22),
                  SizedBox(height: 6),
                  Text('Debit', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
