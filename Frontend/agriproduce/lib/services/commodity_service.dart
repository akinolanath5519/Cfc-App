import 'dart:convert';
import 'package:agriproduce/data_models/commodity_model.dart'; // Import the Commodity model
import 'package:agriproduce/state_management/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:agriproduce/constant/config.dart';

class CommodityService {
  // Method to create a commodity
  Future<void> createCommodity(WidgetRef ref, Commodity commodity) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/commodity'), // Adjust the endpoint as needed
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(commodity.toJson()), // Use the Commodity's toJson method
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create commodity: ${response.body}');
    }
  }

  // Method to get all commodities
  Future<List<Commodity>> getCommodities(WidgetRef ref) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/commodity'), // Adjust the endpoint as needed
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> commodityList = jsonDecode(response.body);
      return commodityList.map<Commodity>((json) => Commodity.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load commodities: ${response.body}');
    }
  }

  // Method to update a commodity
  Future<void> updateCommodity(WidgetRef ref, String commodityId, Commodity commodity) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/commodity/$commodityId'), // Adjust the endpoint as needed
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(commodity.toJson()), // Use the Commodity's toJson method
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update commodity: ${response.body}');
    }
  }

  // Method to delete a commodity
  Future<void> deleteCommodity(WidgetRef ref, String commodityId) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/commodity/$commodityId'), // Adjust the endpoint as needed
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete commodity: ${response.body}');
    }
  }
}
