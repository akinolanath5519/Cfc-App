// supplier_service.dart
import 'dart:convert';
import 'package:agriproduce/data_models/supplier_model.dart';
import 'package:agriproduce/state_management/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:agriproduce/constant/config.dart';


class SupplierService {
  // Method to create a supplier
  Future<void> createSupplier(WidgetRef ref, Supplier supplier) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/supplier'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(supplier.toJson()), // Use the Supplier's toJson method
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create supplier: ${response.body}');
    }
  }

  // Method to get all suppliers
  Future<List<Supplier>> getSuppliers(WidgetRef ref) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/supplier'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> supplierList = jsonDecode(response.body);
      return supplierList.map<Supplier>((json) => Supplier.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load suppliers: ${response.body}');
    }
  }

  // Method to update a supplier
  Future<void> updateSupplier(WidgetRef ref, String supplierId, Supplier supplier) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/supplier/$supplierId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(supplier.toJson()), // Use the Supplier's toJson method
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update supplier: ${response.body}');
    }
  }

  // Method to delete a supplier
  Future<void> deleteSupplier(WidgetRef ref, String supplierId) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/supplier/$supplierId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete supplier: ${response.body}');
    }
  }
}
