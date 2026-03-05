
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/report_screen.dart';
import 'package:myapp/savings_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Miki Menabung' : 'Laporan Tabungan', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                context.go('/add_target');
              },
            ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const <Widget>[
          DashboardView(),
          ReportScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Laporan',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        onTap: _onItemTapped,
        selectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.poppins(),
      ),
    );
  }
}

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  void _showDepositDialog(BuildContext context, SavingsTarget target) {
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final savingsProvider = Provider.of<SavingsProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Setor ke "${target.title}"'),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Jumlah (Rp)'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Jumlah tidak boleh kosong';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Masukkan nominal yang valid';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final amount = double.parse(amountController.text);
                  await savingsProvider.makeDeposit(target.id, amount);
                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                }
              },
              child: const Text('Setor'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, SavingsTarget target) {
    final savingsProvider = Provider.of<SavingsProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: Text('Apakah Anda yakin ingin menghapus target "${target.title}"?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () async {
                await savingsProvider.removeTarget(target.id);
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }


  Widget _buildSummaryCard(List<SavingsTarget> targets) {
    final totalSavings = targets.fold<double>(0, (sum, item) => sum + item.currentAmount);
    final totalTargets = targets.length;

    return Card(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                Text(
                  'Total Tabungan',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${NumberFormat.decimalPattern('id').format(totalSavings)}',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Container(
              height: 50,
              width: 1,
              color: Colors.grey[300],
            ),
            Column(
              children: [
                Text(
                  'Jumlah Target',
                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                Text(
                  totalTargets.toString(),
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SavingsProvider>(
      builder: (context, savingsProvider, child) {
        if (savingsProvider.targets.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.savings_outlined, size: 100, color: Colors.grey),
                const SizedBox(height: 24),
                Text(
                  'Belum ada target',
                  style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ayo buat target pertamamu!',
                  style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: () {
                    context.go('/add_target');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Buat Target'),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: savingsProvider.targets.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildSummaryCard(savingsProvider.targets);
              }
              final target = savingsProvider.targets[index - 1];
              final progress = target.totalAmount > 0 ? target.currentAmount / target.totalAmount : 0.0;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        target.title,
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Terkumpul Rp ${NumberFormat.decimalPattern('id').format(target.currentAmount)} dari Rp ${NumberFormat.decimalPattern('id').format(target.totalAmount)}',
                        style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Target: ${DateFormat.yMMMd().format(target.targetDate)}',
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        value: progress.isNaN ? 0.0 : progress,
                        minHeight: 12,
                        borderRadius: BorderRadius.circular(6),
                        backgroundColor: Colors.grey[300],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          progress >= 1.0 ? Colors.green : (progress > 0.4 ? Colors.orange : Colors.blue),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              progress >= 1.0 ? 'Tercapai!' : 'Saran Harian: Rp ${NumberFormat.decimalPattern('id').format(target.suggestedDailySaving)}',
                              style: GoogleFonts.poppins(fontSize: 14, color: progress >= 1.0 ? Colors.green : Colors.grey[600], fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (progress >= 1.0)
                            ElevatedButton.icon(
                              onPressed: () => _showDeleteConfirmationDialog(context, target),
                              icon: const Icon(Icons.close),
                              label: const Text('Hapus'),
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            )
                          else
                            ElevatedButton(
                              onPressed: () {
                                _showDepositDialog(context, target);
                              },
                              child: const Text('Setor'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
