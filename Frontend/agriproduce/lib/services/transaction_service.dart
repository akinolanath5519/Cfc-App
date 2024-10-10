import 'dart:convert';
import 'package:agriproduce/data_models/transaction_model.dart'; // Import the Transaction model
import 'package:agriproduce/state_management/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:agriproduce/constant/config.dart';

class TransactionService {
  // Method to create a transaction
  Future<void> createTransaction(WidgetRef ref, Transaction transaction) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/transaction'), // Adjust the endpoint as needed
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaction.toJson()), // Use the Transaction's toJson method
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create transaction: ${response.body}');
    }
  }

  // Method to get all transactions
  Future<List<Transaction>> getTransactions(WidgetRef ref) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/transaction'), // Adjust the endpoint as needed
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> transactionList = jsonDecode(response.body);
      return transactionList.map<Transaction>((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load transactions: ${response.body}');
    }
  }

  // Method to update a transaction
  Future<void> updateTransaction(WidgetRef ref, String transactionId, Transaction transaction) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/transaction/$transactionId'), // Adjust the endpoint as needed
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(transaction.toJson()), // Use the Transaction's toJson method
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction: ${response.body}');
    }
  }

  // Method to delete a transaction
  Future<void> deleteTransaction(WidgetRef ref, String transactionId) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/transaction/$transactionId'), // Adjust the endpoint as needed
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction: ${response.body}');
    }
  }
}
