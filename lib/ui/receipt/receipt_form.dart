import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/receipt_model.dart';
import '../../providers/receipt_provider.dart';
import '../../providers/auth_provider.dart';

class ReceiptForm extends StatefulWidget {
  final ReceiptModel? receipt;

  const ReceiptForm({super.key, this.receipt});

  @override
  State<ReceiptForm> createState() => _ReceiptFormState();
}

class _ReceiptFormState extends State<ReceiptForm> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _shopController = TextEditingController();
  final _priceController = TextEditingController();
  
  DateTime _purchaseDate = DateTime.now();
  DateTime _expiryDate = DateTime.now().add(const Duration(days: 365));
  String? _imagePath;
  String _category = 'General';

  final List<String> _categories = ['General', 'Electronics', 'Appliances', 'Fashion', 'Others'];

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      _titleController.text = widget.receipt!.title;
      _shopController.text = widget.receipt!.shop;
      _priceController.text = widget.receipt!.price.toString();
      _purchaseDate = widget.receipt!.purchaseDate;
      _expiryDate = widget.receipt!.expiryDate;
      _imagePath = widget.receipt!.imagePath;
      _category = widget.receipt!.category;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => _imagePath = pickedFile.path);
    }
  }

  void _save() async {
    if (!_formKey.currentState!.validate() || _imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and capture receipt')),
      );
      return;
    }

    final provider = Provider.of<ReceiptProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    final newReceipt = ReceiptModel(
      id: widget.receipt?.id ?? const Uuid().v4(),
      userId: auth.user?.uid ?? '',
      title: _titleController.text,
      shop: _shopController.text,
      price: double.parse(_priceController.text),
      purchaseDate: _purchaseDate,
      expiryDate: _expiryDate,
      category: _category,
      imagePath: _imagePath!,
      isSynced: false,
    );

    if (widget.receipt == null) {
      await provider.addReceipt(newReceipt);
    } else {
      await provider.updateReceipt(newReceipt);
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receipt == null ? 'Add Receipt' : 'Edit Receipt'),
        actions: [
          if (widget.receipt != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                Provider.of<ReceiptProvider>(context, listen: false)
                    .deleteReceipt(widget.receipt!.id);
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: _imagePath == null
                      ? const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                            Text('Capture Receipt Photo'),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(File(_imagePath!), fit: BoxFit.cover),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Item Name'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _shopController,
                decoration: const InputDecoration(labelText: 'Store/Shop'),
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (val) => val!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Warranty Expiry Date'),
                subtitle: Text(DateFormat('dd MMMM yyyy').format(_expiryDate)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _expiryDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 3650)),
                  );
                  if (picked != null) setState(() => _expiryDate = picked);
                },
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save to Vault'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
