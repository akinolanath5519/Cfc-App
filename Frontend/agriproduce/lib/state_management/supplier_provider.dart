// supplier_provider.dart
import 'package:agriproduce/data_models/supplier_model.dart';
import 'package:agriproduce/services/supplier_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// Import the Supplier model

// Create a provider for the SupplierService
final supplierProvider = Provider<SupplierService>((ref) {
  return SupplierService();
});

// Create a StateNotifier to manage the state of suppliers
class SupplierNotifier extends StateNotifier<List<Supplier>> {
  final SupplierService _supplierService;
  SupplierNotifier(this._supplierService) : super([]);

  // Fetch suppliers
  Future<void> fetchSuppliers(WidgetRef ref) async {
    try {
      final fetchedSuppliers = await _supplierService.getSuppliers(ref);
      state = fetchedSuppliers; // Update state with fetched suppliers
    } catch (error) {
      print('Error fetching suppliers: $error');
      throw error; // Handle the error appropriately
    }
  }

  // Create a new supplier
  Future<void> createSupplier(WidgetRef ref, Supplier supplier) async {
    await _supplierService.createSupplier(ref, supplier);
    await fetchSuppliers(ref); // Refresh the list after creating
  }

  // Update an existing supplier
  Future<void> updateSupplier(WidgetRef ref, String supplierId, Supplier supplier) async {
    await _supplierService.updateSupplier(ref, supplierId, supplier);
    await fetchSuppliers(ref); // Refresh the list after updating
  }

  // Delete a supplier
  Future<void> deleteSupplier(WidgetRef ref, String supplierId) async {
    await _supplierService.deleteSupplier(ref, supplierId);
    await fetchSuppliers(ref); // Refresh the list after deletion
  }
}

// Create a provider for the SupplierNotifier
final supplierNotifierProvider = StateNotifierProvider<SupplierNotifier, List<Supplier>>((ref) {
  final supplierService = ref.watch(supplierProvider);
  return SupplierNotifier(supplierService);
});
