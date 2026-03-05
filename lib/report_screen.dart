
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:myapp/savings_provider.dart';
import 'package:provider/provider.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SavingsProvider>(
        builder: (context, savingsProvider, child) {
          final completedTargets = savingsProvider.targets
              .where((target) => target.currentAmount >= target.totalAmount)
              .toList();

          if (completedTargets.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, size: 100, color: Colors.grey),
                  const SizedBox(height: 24),
                  Text(
                    'Belum Ada Target Selesai',
                    style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Selesaikan target pertamamu untuk melihat laporan.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: completedTargets.length,
            itemBuilder: (context, index) {
              final target = completedTargets[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.green[50],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  leading: const Icon(Icons.check_circle, color: Colors.green, size: 40),
                  title: Text(
                    target.title,
                    style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tercapai pada ${DateFormat.yMMMd().format(target.targetDate)}\nTotal: Rp ${target.totalAmount.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
