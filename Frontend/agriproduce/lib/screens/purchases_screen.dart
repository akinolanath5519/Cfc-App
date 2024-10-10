import 'package:agriproduce/screens/receipt_screen.dart';
import 'package:agriproduce/state_management/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class PurchasesScreen extends ConsumerStatefulWidget {
  const PurchasesScreen({Key? key}) : super(key: key);

  @override
  _PurchasesScreenState createState() => _PurchasesScreenState();
}

class _PurchasesScreenState extends ConsumerState<PurchasesScreen> {
  final TextEditingController _searchController = TextEditingController();
  String? errorMessage;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchTransactions() async {
    try {
      await ref.read(transactionProvider.notifier).fetchTransactions(ref);
      setState(() {
        errorMessage = null;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
      print('Error in PurchasesScreen: $errorMessage');
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(
        start: startDate ?? DateTime.now(),
        end: endDate ?? DateTime.now(),
      ),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
    }
  }

  void _clearDateRange() {
    setState(() {
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactions = ref.watch(transactionProvider);
    final searchQuery = _searchController.text;

    // Filter transactions based on search query and date range
    final filteredTransactions = transactions.where((transaction) {
      final searchLower = searchQuery.toLowerCase();
      final matchesQuery =
          transaction.supplierName.toLowerCase().contains(searchLower) ||
              transaction.commodityName.toLowerCase().contains(searchLower);

      final matchesDate = (startDate == null || endDate == null)
          ? true
          : transaction.transactionDate != null &&
              transaction.transactionDate!
                  .isAfter(startDate!.subtract(Duration(days: 1))) &&
              transaction.transactionDate!
                  .isBefore(endDate!.add(Duration(days: 1)));

      return matchesQuery && matchesDate;
    }).toList();

    // Calculate total price of filtered transactions
    double totalPrice =
        filteredTransactions.fold(0, (sum, item) => sum + item.price);

    return Scaffold(
      body: errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $errorMessage',
                      style: TextStyle(color: Colors.red)),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: fetchTransactions,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Search bar for supplier and commodity names
                        TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: 'Search by Supplier or Commodity',
                            prefixIcon: Icon(Icons.search),
                            suffixIcon: searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {});
                                    },
                                  )
                                : null,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        const SizedBox(height: 16),
                        // Date range picker for filtering
                        GestureDetector(
                          onTap: () => _selectDateRange(context),
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  startDate == null && endDate == null
                                      ? 'Filter by Date Range'
                                      : 'Selected Dates: ${DateFormat('yyyy-MM-dd').format(startDate!)} - ${DateFormat('yyyy-MM-dd').format(endDate!)}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.date_range),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Clear date range button
                        if (startDate != null && endDate != null)
                          ElevatedButton(
                            onPressed: _clearDateRange,
                            child: const Text('Clear Date Range'),
                          ),
                        const SizedBox(height: 16),
                        // No transactions state
                        if (filteredTransactions.isEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  'No transactions found',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                    'Try adjusting your filters or adding new transactions.'),
                              ],
                            ),
                          )
                        else
                          // List of transactions with animations
                          AnimationLimiter(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredTransactions.length,
                              itemBuilder: (context, index) {
                                final transaction = filteredTransactions[index];
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  duration: const Duration(milliseconds: 375),
                                  child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: GestureDetector(
                                        onDoubleTap: () {
                                          // Navigate to ReceiptScreen on double tap
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ReceiptScreen(
                                                      transaction: transaction),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          elevation: 4,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${transaction.commodityName} - ${transaction.weight} kg',
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Supplier: ${transaction.supplierName}',
                                                  style: TextStyle(
                                                      color: Colors.grey[600]),
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Price: \$${transaction.price.toStringAsFixed(2)}',
                                                      style: const TextStyle(
                                                          color: Colors.green),
                                                    ),
                                                    Text(
                                                      'Date: ${transaction.transactionDate != null ? DateFormat('yyyy-MM-dd').format(transaction.transactionDate!) : 'No date available'}',
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Total transactions and price display without card
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Transactions: ${filteredTransactions.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total Price: \$${totalPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
