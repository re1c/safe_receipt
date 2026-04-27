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
  String _searchQuery = '';
  final _searchController = TextEditingController();
  final Set<String> _selectedIds = {};

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<ReceiptProvider>(context, listen: false).loadReceipts(),
    );
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final receiptProvider = Provider.of<ReceiptProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final theme = Theme.of(context);
    
    final displayedReceipts = receiptProvider.searchReceipts(_searchQuery);

    return Scaffold(
      appBar: AppBar(
        title: _selectedIds.isEmpty 
          ? const Text('SafeReceipt Vault')
          : Text('${_selectedIds.length} Selected'),
        leading: _selectedIds.isEmpty ? null : IconButton(
          icon: const Icon(Icons.close),
          onPressed: _clearSelection,
        ),
        actions: [
          if (_selectedIds.isEmpty)
            IconButton(
              icon: const Icon(Icons.logout_rounded),
              onPressed: () => _showLogoutDialog(context, authProvider),
            )
          else
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _showDeleteMultipleDialog(context, receiptProvider),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SearchBar(
              controller: _searchController,
              hintText: 'Search receipts or shops...',
              leading: const Icon(Icons.search),
              onChanged: (value) => setState(() => _searchQuery = value),
              trailing: [
                if (_searchQuery.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      setState(() => _searchQuery = '');
                    },
                  ),
              ],
            ),
          ),
          Expanded(
            child: receiptProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : displayedReceipts.isEmpty
                    ? _buildEmptyState(theme)
                    : _buildReceiptList(displayedReceipts, theme),
          ),
        ],
      ),
      floatingActionButton: _selectedIds.isEmpty ? FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ReceiptForm()),
        ),
        label: const Text('Digitize Receipt'),
        icon: const Icon(Icons.camera_rounded),
      ) : null,
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider auth) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              auth.signOut();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showDeleteMultipleDialog(BuildContext context, ReceiptProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Selected'),
        content: Text('Are you sure you want to delete ${_selectedIds.length} items?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final idsToDelete = _selectedIds.toList();
              _clearSelection();
              await provider.deleteMultipleReceipts(idsToDelete);
            },
            child: const Text('Delete All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.inventory_2_rounded : Icons.search_off_rounded,
            size: 80,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty ? 'Your vault is empty' : 'No matches found',
            style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.outline),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptList(List displayedReceipts, ThemeData theme) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: displayedReceipts.length,
      itemBuilder: (context, index) {
        final receipt = displayedReceipts[index];
        final isSelected = _selectedIds.contains(receipt.id);
        final daysToExpiry = receipt.expiryDate.difference(DateTime.now()).inDays;
        final isExpiringSoon = daysToExpiry < 30;
        final isExpired = daysToExpiry < 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: isSelected 
              ? BorderSide(color: theme.colorScheme.primary, width: 2)
              : BorderSide.none,
          ),
          color: isSelected ? theme.colorScheme.primaryContainer.withValues(alpha: 0.1) : null,
          child: InkWell(
            onLongPress: () => _toggleSelection(receipt.id),
            onTap: () {
              if (_selectedIds.isNotEmpty) {
                _toggleSelection(receipt.id);
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReceiptForm(receipt: receipt)),
                );
              }
            },
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Hero(
                      tag: 'img-${receipt.id}',
                      child: Image.file(
                        File(receipt.imagePath),
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 100,
                          height: 100,
                          color: theme.colorScheme.surfaceContainerHighest,
                          child: const Icon(Icons.broken_image_rounded),
                        ),
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 100,
                        height: 100,
                        color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        child: const Icon(Icons.check_circle, color: Colors.white, size: 32),
                      ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                receipt.title,
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              '\$${receipt.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Text(receipt.shop, style: theme.textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              isExpired ? Icons.error_outline : Icons.timer_outlined,
                              size: 14,
                              color: isExpired ? Colors.red : (isExpiringSoon ? Colors.orange : Colors.green),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isExpired 
                                ? 'Expired' 
                                : 'Expires: ${DateFormat('dd MMM yy').format(receipt.expiryDate)}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: isExpired ? Colors.red : (isExpiringSoon ? Colors.orange : Colors.grey),
                                fontWeight: isExpiringSoon ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            const Spacer(),
                            if (!receipt.isSynced)
                              const Tooltip(
                                message: 'Waiting for sync...',
                                child: Icon(Icons.sync_problem_rounded, size: 16, color: Colors.orange),
                              )
                            else
                              const Icon(Icons.cloud_done_rounded, size: 16, color: Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
