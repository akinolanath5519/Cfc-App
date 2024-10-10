import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:agriproduce/data_models/sack_model.dart';// Import the SackService
import 'package:agriproduce/state_management/sack_provider.dart'; // Import the provider

class SackManagementScreen extends ConsumerStatefulWidget {
  @override
  _SackManagementScreenState createState() => _SackManagementScreenState();
}

class _SackManagementScreenState extends ConsumerState<SackManagementScreen> {
  TextEditingController searchController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    // Fetch sacks on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sackRecordsProvider.notifier).fetchSacks(ref);
    });
  }

  @override
  Widget build(BuildContext context) {
    final sackRecords = ref.watch(sackRecordsProvider);
    final filteredSackRecords = _filterSackRecords(sackRecords);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sack Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildSearchField(),
            Expanded(
              child: filteredSackRecords.isEmpty
                  ? _buildEmptyState(context)
                  : ListView.builder(
                      itemCount: filteredSackRecords.length,
                      itemBuilder: (context, index) {
                        final sackRecord = filteredSackRecords[index];
                        return _buildSackCard(sackRecord);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddSackDialog(context);
        },
        child: Icon(Icons.add),
        tooltip: 'Add New Record',
        backgroundColor: Colors.greenAccent,
      ),
    );
  }

  // Search field widget
  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search Supplier Name',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onChanged: (query) {
          setState(() {});
        },
      ),
    );
  }

  // Sack Card UI
  Widget _buildSackCard(SackRecord sackRecord) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person, color: Colors.greenAccent),
                SizedBox(width: 10),
                Text(
                  'Supplier: ${sackRecord.supplierName}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.calendar_today, color: Colors.blue),
                SizedBox(width: 10),
                Text(
                  'Date: ${sackRecord.date}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.orange),
                SizedBox(width: 10),
                Text(
                  'Bags Collected: ${sackRecord.bagsCollected}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.cancel, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Bags Returned: ${sackRecord.bagsReturned}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.assignment_late, color: Colors.blueGrey),
                SizedBox(width: 10),
                Text(
                  'Bags Remaining: ${sackRecord.bagsRemaining}',
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showEditSackDialog(context, sackRecord);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmation(sackRecord.id);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Empty state widget
  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Text(
        'No sacks available.',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  // Filter sacks based on the search query
  List<SackRecord> _filterSackRecords(List<SackRecord> sackRecords) {
    final query = searchController.text.toLowerCase();
    return sackRecords.where((sack) {
      return sack.supplierName.toLowerCase().contains(query);
    }).toList();
  }

  // Show Add Sack Dialog
  void _showAddSackDialog(BuildContext context) {
    final supplierNameController = TextEditingController();
    final bagsCollectedController = TextEditingController();
    final bagsReturnedController = TextEditingController();
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Sack Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: supplierNameController,
                decoration: InputDecoration(labelText: 'Supplier Name'),
              ),
              TextField(
                controller: bagsCollectedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bags Collected'),
              ),
              TextField(
                controller: bagsReturnedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bags Returned'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text('Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newSack = SackRecord(
                  id: '', // Let the server generate the ID
                  supplierName: supplierNameController.text,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                  bagsCollected: int.parse(bagsCollectedController.text),
                  bagsReturned: int.parse(bagsReturnedController.text),
                );

                ref.read(sackRecordsProvider.notifier).addSack(newSack);
                ref.read(sackServiceProvider).createSack(ref, newSack);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show Edit Sack Dialog
  void _showEditSackDialog(BuildContext context, SackRecord sackRecord) {
    final supplierNameController = TextEditingController(text: sackRecord.supplierName);
    final bagsCollectedController = TextEditingController(text: sackRecord.bagsCollected.toString());
    final bagsReturnedController = TextEditingController(text: sackRecord.bagsReturned.toString());
    DateTime selectedDate = DateFormat('yyyy-MM-dd').parse(sackRecord.date);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Sack Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: supplierNameController,
                decoration: InputDecoration(labelText: 'Supplier Name'),
              ),
              TextField(
                controller: bagsCollectedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bags Collected'),
              ),
              TextField(
                controller: bagsReturnedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: 'Bags Returned'),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text('Select Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedSack = SackRecord(
                  id: sackRecord.id,
                  supplierName: supplierNameController.text,
                  date: DateFormat('yyyy-MM-dd').format(selectedDate),
                  bagsCollected: int.parse(bagsCollectedController.text),
                  bagsReturned: int.parse(bagsReturnedController.text),
                );

                ref.read(sackRecordsProvider.notifier).updateSack(updatedSack);
                ref.read(sackServiceProvider).updateSack(ref, sackRecord.id, updatedSack);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(String sackId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this sack record?'),
          actions: [
            TextButton(
              onPressed: () {
                ref.read(sackRecordsProvider.notifier).deleteSack(sackId);
                ref.read(sackServiceProvider).deleteSack(ref, sackId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  // Show filter options dialog
  void _showFilterOptions() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () {
                  // Filter by date range
                  _showDateRangePicker();
                  Navigator.of(context).pop();
                },
                child: Text('Filter by Date Range'),
              ),
              // Add other filter options here
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Show date range picker
  void _showDateRangePicker() async {
    DateTimeRange? pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedRange != null) {
      setState(() {
        startDate = pickedRange.start;
        endDate = pickedRange.end;
      });
      
      List<SackRecord> _filterSackRecords(List<SackRecord> sackRecords) {
  final query = searchController.text.toLowerCase();

  return sackRecords.where((sack) {
    // Check if the supplier name matches the search query
    final matchesSearchQuery = sack.supplierName.toLowerCase().contains(query);

    // Check if the date falls within the selected date range
    final sackDate = DateFormat('yyyy-MM-dd').parse(sack.date);
    final matchesDateRange = (startDate == null || endDate == null) ||
        (sackDate.isAfter(startDate!) || sackDate.isAtSameMomentAs(startDate!)) &&
        (sackDate.isBefore(endDate!) || sackDate.isAtSameMomentAs(endDate!));

    // Combine both conditions
    return matchesSearchQuery && matchesDateRange;
  }).toList();
}
// You can apply the filter logic here
    }
  }
}
