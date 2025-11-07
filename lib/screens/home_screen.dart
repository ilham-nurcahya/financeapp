import 'package:flutter/material.dart';
import '../widgets/atm_card.dart';
import '../widgets/transaction_item.dart';
import '../models/transaction.dart';
import '../widgets/grid_menu_item.dart';
import 'top_up_screen.dart';
import 'manage_card_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions = [
      TransactionModel('Coffee Shop', -35000, 'Food', icon: Icons.coffee),
      TransactionModel('Grab Ride', -25000, 'Travel', icon: Icons.directions_car),
      TransactionModel('Gym Membership', -150000, 'Health', icon: Icons.fitness_center),
      TransactionModel('Movie Ticket', -60000, 'Event', icon: Icons.movie),
      TransactionModel('Salary', 5000000, 'Income', icon: Icons.wallet),
    ];

    // ringkasan total (skeleton demo)
    final totalBalance = 12350000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finance Mate'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // placeholder untuk refresh data
          await Future.delayed(const Duration(milliseconds: 600));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting + Total Balance Card
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Good Morning,', style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 4),
                        Text('Ilham 👋', style: Theme.of(context).textTheme.titleLarge),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.deepOrange.withAlpha((0.1 * 255).round()),
                    child: const Icon(Icons.person, color: Colors.deepOrange),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Total balance card
              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Colors.deepOrange.shade200, Colors.deepOrange]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepOrange.withAlpha((0.2 * 255).round()),
                              blurRadius: 8,
                              offset: const Offset(0, 6),
                            )
                          ],
                        ),
                        child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Balance', style: TextStyle(fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 4),
                            Text('Rp ${_formatCurrency(totalBalance)}',
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),

                      // Top Up button -> buka TopUpScreen
                      TextButton.icon(
                        onPressed: () async {
                          final result = await Navigator.push<bool>(
                            context,
                            MaterialPageRoute(builder: (_) => const TopUpScreen()),
                          );
                          // jika TopUpScreen mengembalikan true => sukses
                          if (result == true) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(content: Text('Top up berhasil. Saldo diperbarui.')));
                            }
                            // TODO: panggil state management / reload saldo nyata di sini
                          }
                        },
                        icon: const Icon(Icons.add, size: 18),
                        label: const Text('Top Up'),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // My Cards title + Manage button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Cards', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      // debug: kamu bisa tambahkan print() jika butuh tracing
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ManageCardScreen()),
                      );
                    },
                    child: const Text('Manage', style: TextStyle(fontSize: 14)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ATM Cards horizontal
              SizedBox(
                height: 190,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    SizedBox(width: 2),
                    AtmCard(
                      bankName: 'Bank A',
                      cardNumber: '**** 2345',
                      balance: 'Rp12.500.000',
                      color1: Color(0xFF3A8DFF),
                      color2: Color(0xFF004CFF),
                    ),
                    AtmCard(
                      bankName: 'Bank B',
                      cardNumber: '**** 8765',
                      balance: 'Rp5.350.000',
                      color1: Color(0xFFFF8C00),
                      color2: Color(0xFFFF2E00),
                    ),
                    AtmCard(
                      bankName: 'Bank C',
                      cardNumber: '**** 4321',
                      balance: 'Rp3.800.000',
                      color1: Color(0xFF00C6FF),
                      color2: Color(0xFF0072FF),
                    ),
                    AtmCard(
                      bankName: 'Bank D',
                      cardNumber: '**** 9987',
                      balance: 'Rp20.000.000',
                      color1: Color(0xFF8E2DE2),
                      color2: Color(0xFF4A00E0),
                    ),
                    SizedBox(width: 8),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Grid menu modern
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  GridMenuItem(icon: Icons.send_to_mobile, label: 'Transfer'),
                  GridMenuItem(icon: Icons.payment, label: 'Bills'),
                  GridMenuItem(icon: Icons.qr_code, label: 'Scan'),
                  GridMenuItem(icon: Icons.savings, label: 'Savings'),
                  GridMenuItem(icon: Icons.fastfood, label: 'Food'),
                  GridMenuItem(icon: Icons.travel_explore, label: 'Travel'),
                  GridMenuItem(icon: Icons.health_and_safety, label: 'Health'),
                  GridMenuItem(icon: Icons.more_horiz, label: 'More'),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Transactions
              const Text('Recent Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: transactions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  return TransactionItem(transaction: transactions[index]);
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // helper format rupiah sederhana
  static String _formatCurrency(int value) {
    final abs = value.abs();
    final str = abs.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
    return str;
  }
}
