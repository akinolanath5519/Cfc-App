import 'dart:convert';
import 'package:agriproduce/data_models/sack_model.dart';
import 'package:agriproduce/state_management/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:agriproduce/constant/config.dart';

class SackService {
  // Method to create a sack
  Future<void> createSack(WidgetRef ref, SackRecord sack) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.post(
      Uri.parse('${Config.baseUrl}/sack'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sack.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create sack: ${response.body}');
    }
  }

  // Method to get all sacks
  Future<List<SackRecord>> getSacks(WidgetRef ref) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('${Config.baseUrl}/sack'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> sackList = jsonDecode(response.body);
      return sackList.map<SackRecord>((json) => SackRecord.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load sacks: ${response.body}');
    }
  }

  // Method to update a sack
  Future<void> updateSack(WidgetRef ref, String sackId, SackRecord sack) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('${Config.baseUrl}/sack/$sackId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(sack.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update sack: ${response.body}');
    }
  }

  // Method to delete a sack
  Future<void> deleteSack(WidgetRef ref, String sackId) async {
    final token = ref.read(tokenProvider);

    if (token == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.delete(
      Uri.parse('${Config.baseUrl}/sack/$sackId'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete sack: ${response.body}');
    }
  }
}
