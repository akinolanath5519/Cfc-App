import 'package:agriproduce/data_models/supplier_model.dart';
import 'package:agriproduce/state_management/supplier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SupplierScreen extends ConsumerStatefulWidget {
  @override
  _SupplierScreenState createState() => _SupplierScreenState();
}

class _SupplierScreenState extends ConsumerState<SupplierScreen> {
  bool isLoading = false;
  String searchTerm = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }

  Future<void> _fetchSuppliers() async {
    setState(() {
      isLoading = true;
    });

    try {
      await ref.read(supplierNotifierProvider.notifier).fetchSuppliers(ref);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching suppliers')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showSupplierDialog(BuildContext context, {Supplier? supplier}) {
    final nameController = TextEditingController(text: supplier?.name);
    final contactController = TextEditingController(text: supplier?.contact);
    final addressController = TextEditingController(text: supplier?.address);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text(supplier == null ? 'Add Supplier' : 'Edit Supplier'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(nameController, 'Name'),
                _buildTextField(contactController, 'Contact', hintText: 'Enter 11-digit contact number', isPhone: true),
                _buildTextField(addressController, 'Address'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (supplier == null) {
                  await _createSupplier(nameController.text, contactController.text, addressController.text);
                } else {
                  await _updateSupplier(supplier.id, nameController.text, contactController.text, addressController.text);
                }
              },
              child: Text(supplier == null ? 'Add' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _createSupplier(String name, String contact, String address) async {
    try {
      await ref.read(supplierNotifierProvider.notifier).createSupplier(ref, Supplier(id: '', name: name, contact: contact, address: address));
      _fetchSuppliers();
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding supplier')));
    }
  }

  Future<void> _updateSupplier(String id, String name, String contact, String address) async {
    try {
      await ref.read(supplierNotifierProvider.notifier).updateSupplier(ref, id, Supplier(id: id, name: name, contact: contact, address: address));
      _fetchSuppliers();
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating supplier')));
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String supplierId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: Text('Delete Supplier'),
          content: Text('Are you sure you want to delete this supplier? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                try {
                  await ref.read(supplierNotifierProvider.notifier).deleteSupplier(ref, supplierId);
                  _fetchSuppliers();
                  Navigator.of(context).pop();
                } catch (error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error deleting supplier')));
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(supplierNotifierProvider);

    final filteredSuppliers = suppliers.where((supplier) =>
      supplier.name.toLowerCase().contains(searchTerm.toLowerCase()) ||
      supplier.contact.contains(searchTerm)).toList();

    return Scaffold(
      appBar: AppBar(title: Text('Suppliers')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildSearchBar(),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredSuppliers.length,
                    itemBuilder: (context, index) {
                      final supplier = filteredSuppliers[index];
                      return _buildSupplierTile(supplier, context);
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showSupplierDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildSupplierTile(Supplier supplier, BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(supplier.name),
          subtitle: Text(supplier.contact),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _showSupplierDialog(context, supplier: supplier),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _showDeleteConfirmationDialog(context, supplier.id),
              ),
            ],
          ),
        ),
        Divider(thickness: 1.0, color: Colors.grey[300]), // Faint line separator
      ],
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          labelText: 'Search Suppliers',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          suffixIcon: searchTerm.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      searchTerm = '';
                      searchController.clear();
                    });
                  },
                )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            searchTerm = value;
          });
        },
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {String? hintText, bool isPhone = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(),
        ),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      ),
    );
  }
}
