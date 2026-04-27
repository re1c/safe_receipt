import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/auth_provider.dart';
import '../../providers/receipt_provider.dart';
import '../receipt/receipt_form.dart';
import 'dart:io';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ReceiptProvider>(context, listen: false).loadReceipts(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final receiptProvider = Provider.of<ReceiptProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vault'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
          ),
        ],
      ),
      body: receiptProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : receiptProvider.receipts.isEmpty
              ? _buildEmptyState(theme)
              : _buildReceiptList(receiptProvider),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReceiptForm()),
        ),
        label: const Text('Add Receipt'),
        icon: const Icon(Icons.add_a_photo),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 100, color: theme.disabledColor),
          const SizedBox(height: 16),
          Text(
            'No receipts yet',
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.disabledColor),
          ),
          const SizedBox(height: 8),
          const Text('Tap the button below to digitize your first receipt.'),
        ],
      ),
    );
  }

  Widget _buildReceiptList(ReceiptProvider provider) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: provider.receipts.length,
      itemBuilder: (context, index) {
        final receipt = provider.receipts[index];
        final isExpiringSoon = receipt.expiryDate.difference(DateTime.now()).inDays < 30;

        return Card(
          margin: const EdgeInsets.bottom(16),
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(receipt.imagePath),
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            title: Text(
              receipt.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(receipt.shop),
                Text(
                  'Expires: ${DateFormat('dd MMM yyyy').format(receipt.expiryDate)}',
                  style: TextStyle(
                    color: isExpiringSoon ? Colors.orange : Colors.grey,
                    fontWeight: isExpiringSoon ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$${receipt.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                if (receipt.isSynced)
                  const Icon(Icons.cloud_done, color: Colors.green, size: 16)
                else
                  const Icon(Icons.cloud_off, color: Colors.grey, size: 16),
              ],
            ),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ReceiptForm(receipt: receipt)),
            ),
          ),
        );
      },
    );
  }
}
