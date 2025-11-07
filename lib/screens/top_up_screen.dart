import 'package:flutter/material.dart';

class TopUpScreen extends StatefulWidget {
  const TopUpScreen({super.key});

  @override
  State<TopUpScreen> createState() => _TopUpScreenState();
}

class _TopUpScreenState extends State<TopUpScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // preset quick amounts (in rupiah)
  final List<int> _quickAmounts = [50000, 100000, 200000, 500000];
  int? _selectedQuick; // one of quick amounts selected
  String _selectedMethod = 'Virtual Account';

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _applyQuickAmount(int amount) {
    setState(() {
      _selectedQuick = amount;
      _amountCtrl.text = amount.toString();
    });
  }

  String _formatRupiah(int value) {
    final s = value.toString();
    return s.replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
  }

  int _parseAmount() {
    final raw = _amountCtrl.text.replaceAll('.', '').trim();
    return int.tryParse(raw) ?? 0;
  }

  Future<void> _confirmTopUp() async {
    // validasi
    if (_formKey.currentState == null) return;
    if (!_formKey.currentState!.validate()) return;

    final amount = _parseAmount();
    if (amount <= 0) return;

    // tampilkan dialog konfirmasi
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi Top Up'),
        content: Text('Top up sebesar Rp ${_formatRupiah(amount)} via $_selectedMethod?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: const Text('Lanjut')),
        ],
      ),
    );

    if (ok != true) return;

    // simulasi proses pembayaran (tunggu), pastikan mounted
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    Navigator.of(context).pop(); // tutup progress dialog

    // tampilkan hasil sukses
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Top Up Berhasil'),
        content: Text('Saldo kamu telah bertambah Rp ${_formatRupiah(amount)}'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Selesai'),
          )
        ],
      ),
    );

    // kembali ke layar sebelumnya (opsional)
    if (mounted) Navigator.of(context).pop(true);
  }

  String? _validateAmount(String? v) {
    if (v == null || v.trim().isEmpty) return 'Masukkan nominal';
    final raw = v.replaceAll('.', '').trim();
    final val = int.tryParse(raw);
    if (val == null || val <= 0) return 'Nominal tidak valid';
    if (val < 1000) return 'Minimal top up Rp 1.000';
    return null;
  }

  // simple formatter saat mengetik (menambahkan titik ribuan)
  void _onAmountChanged(String v) {
    final raw = v.replaceAll('.', '').trim();
    if (raw.isEmpty) {
      _selectedQuick = null;
      return;
    }
    final parsed = int.tryParse(raw);
    if (parsed == null) return;
    final formatted = parsed.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]}.');
    if (formatted != v) {
      // update controller tanpa memicu loop
      final sel = _amountCtrl.selection;
      _amountCtrl.value = TextEditingValue(
        text: formatted,
        selection: sel.copyWith(
          baseOffset: formatted.length,
          extentOffset: formatted.length,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Up'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // info saldo / instruksi singkat
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, color: Colors.deepOrange),
                      SizedBox(width: 8),
                      Expanded(child: Text('Pilih nominal, lalu pilih metode pembayaran. Transaksi instan.')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // input nominal
              TextFormField(
                controller: _amountCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Masukkan nominal (Rp)',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                validator: _validateAmount,
                onChanged: _onAmountChanged,
              ),

              const SizedBox(height: 12),

              // quick amount chips
              SizedBox(
                height: 44,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, i) {
                    final val = _quickAmounts[i];
                    final isSelected = _selectedQuick == val;
                    return ChoiceChip(
                      label: Text('Rp ${_formatRupiah(val)}'),
                      selected: isSelected,
                      onSelected: (_) => _applyQuickAmount(val),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: _quickAmounts.length,
                ),
              ),

              const SizedBox(height: 16),

              // metode pembayaran (radio)
              Align(alignment: Alignment.centerLeft, child: Text('Metode Pembayaran', style: Theme.of(context).textTheme.bodyMedium)),
              const SizedBox(height: 8),
              Column(
                children: [
                  RadioListTile<String>(
                    value: 'Virtual Account',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v ?? 'Virtual Account'),
                    title: const Text('Virtual Account'),
                    subtitle: const Text('Transfer bank via VA (instan)'),
                  ),
                  RadioListTile<String>(
                    value: 'E-Wallet',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v ?? 'E-Wallet'),
                    title: const Text('E-Wallet'),
                    subtitle: const Text('QR / deep link ke e-wallet'),
                  ),
                  RadioListTile<String>(
                    value: 'Card (Debit/Credit)',
                    groupValue: _selectedMethod,
                    onChanged: (v) => setState(() => _selectedMethod = v ?? 'Card (Debit/Credit)'),
                    title: const Text('Kartu (Debit/Credit)'),
                    subtitle: const Text('Pembayaran kartu (3D Secure dapat berlaku)'),
                  ),
                ],
              ),

              const Spacer(),

              // tombol konfirmasi
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _confirmTopUp,
                  style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Konfirmasi Top Up', style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
