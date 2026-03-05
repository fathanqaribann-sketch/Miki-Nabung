
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path_provider/path_provider.dart';

part 'savings_provider.g.dart';

@JsonSerializable()
class SavingsTarget {
  final String id;
  final String title;
  final double totalAmount;
  final DateTime targetDate;
  double currentAmount;

  SavingsTarget({
    required this.id,
    required this.title,
    required this.totalAmount,
    required this.targetDate,
    this.currentAmount = 0.0,
  });

  @JsonKey(includeFromJson: false, includeToJson: false)
  double get suggestedDailySaving {
    final remainingAmount = totalAmount - currentAmount;
    if (remainingAmount <= 0) return 0;

    final remainingDays = targetDate.difference(DateTime.now()).inDays;
    if (remainingDays <= 0) return remainingAmount; // If it's the last day or past due, the suggestion is to pay the rest.

    return remainingAmount / remainingDays;
  }

  factory SavingsTarget.fromJson(Map<String, dynamic> json) =>
      _$SavingsTargetFromJson(json);

  Map<String, dynamic> toJson() => _$SavingsTargetToJson(this);
}

class SavingsProvider with ChangeNotifier {
  List<SavingsTarget> _targets = [];

  static const _fileName = 'savings_data.json';

  SavingsProvider() {
    _loadData();
  }

  List<SavingsTarget> get targets => _targets;

  Future<File> _getFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> _saveData() async {
    try {
      final file = await _getFilePath();
      final jsonString = jsonEncode(_targets.map((t) => t.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      // Handle errors, maybe log them
      debugPrint("Error saving data: $e");
    }
  }

  Future<void> _loadData() async {
    try {
      final file = await _getFilePath();
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(jsonString);
        _targets = jsonList.map((json) => SavingsTarget.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      // Handle errors, maybe log them
      debugPrint("Error loading data: $e");
    }
  }

  Future<void> addTarget(SavingsTarget target) async {
    _targets.add(target);
    await _saveData();
    notifyListeners();
  }

  Future<void> makeDeposit(String targetId, double amount) async {
    try {
      final target = _targets.firstWhere((t) => t.id == targetId);
      target.currentAmount += amount;
      await _saveData();
      notifyListeners();
    } catch (e) {
      debugPrint("Error making deposit: $e");
    }
  }

  Future<void> removeTarget(String targetId) async {
    _targets.removeWhere((t) => t.id == targetId);
    await _saveData();
    notifyListeners();
  }
}
