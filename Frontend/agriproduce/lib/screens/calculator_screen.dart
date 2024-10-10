import 'package:agriproduce/data_models/commodity_model.dart';
import 'package:agriproduce/data_models/supplier_model.dart';
import 'package:agriproduce/data_models/transaction_model.dart';
import 'package:agriproduce/state_management/commodity_provider.dart';
import 'package:agriproduce/state_management/supplier_provider.dart';
import 'package:agriproduce/constant/number_to_words.dart';
import 'package:agriproduce/state_management/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CalculatorScreen extends ConsumerStatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final TextEditingController _weightController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _selectedUnit = 'Metric tonne';
  Commodity? _selectedCommodity;
  Supplier? _selectedSupplier;
  double _totalPrice = 0.0;
  String _priceInWords = '';
  DateTime _transactionDate = DateTime.now();

  final List<String> _units = ['Metric tonne', 'Tare', 'Polythene', 'Jute'];

  final Map<String, double> _unitWeights = {
    'Metric tonne': 1000.0,
    'Polythene': 1027.0,
    'Tare': 1014.0,
    'Jute': 1040.0,
  };

  @override
  void initState() {
    super.initState();
    ref.read(commodityNotifierProvider.notifier).fetchCommodities(ref);
    ref.read(supplierNotifierProvider.notifier).fetchSuppliers(ref);
    _weightController.addListener(_calculateTotalPrice);
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  void _calculateTotalPrice() {
    if (_weightController.text.isNotEmpty && _selectedCommodity != null) {
      double weight = double.tryParse(_weightController.text) ?? 0;
      double unitWeight = _unitWeights[_selectedUnit] ?? 1000.0;
      _totalPrice = (weight / unitWeight) * (_selectedCommodity?.rate ?? 0);
      _priceInWords = convertNumberToWords(_totalPrice);
      setState(() {});
    } else {
      setState(() {
        _totalPrice = 0.0;
        _priceInWords = '';
      });
    }
  }

  void _showSaveTransactionDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Save Transaction'),
          content: const Text('Do you want to save this transaction?'),
          actions: [
            TextButton(
              onPressed: () {
                if (_formKey.currentState?.validate() == true) {
                  final transaction = Transaction(
                    weight: double.tryParse(_weightController.text) ?? 0,
                    unit: _selectedUnit,
                    price: _totalPrice,
                    commodityName: _selectedCommodity?.name ?? '',
                    supplierName: _selectedSupplier?.name ?? '',
                    transactionDate: _transactionDate,
                  );

                  // Add the transaction
                  ref
                      .read(transactionProvider.notifier)
                      .addTransaction(ref, transaction);

                  // Show success feedback using SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Transaction saved successfully!'),
                      duration: const Duration(seconds: 2),
                    ),
                  );

                  // Close the dialog and reset fields
                  Navigator.of(context).pop();
                  _resetFields();
                  // Optionally navigate to another screen
                  Navigator.pushReplacementNamed(context, '/purchases');
                }
              },
              child: const Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _resetFields() {
    _weightController.clear();
    setState(() {
      _selectedCommodity = null;
      _selectedSupplier = null;
      _totalPrice = 0.0;
      _priceInWords = '';
      _transactionDate = DateTime.now();
    });
  }

  @override
  Widget build(BuildContext context) {
    final commodities = ref.watch(commodityNotifierProvider);
    final suppliers = ref.watch(supplierNotifierProvider);

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: TextFormField(
                          controller: _weightController,
                          decoration: InputDecoration(
                            labelText: 'Weight',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter weight';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedUnit,
                        decoration: InputDecoration(
                          labelText: 'Select Unit',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        items: _units.map((String unit) {
                          return DropdownMenuItem<String>(
                            value: unit,
                            child: Text(unit),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUnit = newValue!;
                            _calculateTotalPrice();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  readOnly: true,
                  controller: TextEditingController(
                    text: _selectedCommodity?.rate.toString() ?? '0',
                  ),
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<Commodity>(
                  decoration: InputDecoration(
                    labelText: 'Select Commodity',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  value: _selectedCommodity,
                  items: commodities.map((Commodity commodity) {
                    return DropdownMenuItem<Commodity>(
                      value: commodity,
                      child: Text(commodity.name),
                    );
                  }).toList(),
                  onChanged: (Commodity? newValue) {
                    setState(() {
                      _selectedCommodity = newValue;
                      _calculateTotalPrice();
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                DropdownButtonFormField<Supplier>(
                  decoration: InputDecoration(
                    labelText: 'Select Supplier',
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  value: _selectedSupplier,
                  items: suppliers.map((Supplier supplier) {
                    return DropdownMenuItem<Supplier>(
                      value: supplier,
                      child: Text(supplier.name),
                    );
                  }).toList(),
                  onChanged: (Supplier? newValue) {
                    setState(() {
                      _selectedSupplier = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                Text('Total Price: \$${_totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Text('In Words: $_priceInWords',
                    style: TextStyle(color: Colors.grey[600])),
                const SizedBox(height: 16.0),
                Center(
                  child: SizedBox(
                    width: 450, // Set the desired width here
                    child: ElevatedButton(
                      onPressed: _showSaveTransactionDialog,
                      child: const Text('Save Transaction'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
