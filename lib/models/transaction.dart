import 'package:flutter/material.dart';

class TransactionModel {
  final String title;
  final int amount; // positive untuk income, negative untuk expense
  final String category;
  final IconData? icon;

  TransactionModel(this.title, this.amount, this.category, {this.icon});
}
