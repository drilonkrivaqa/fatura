import 'package:flutter/material.dart';

import '../models/invoice.dart';

class StatusChip extends StatelessWidget {
  final InvoiceStatus status;

  const StatusChip({super.key, required this.status});

  Color _backgroundColor(BuildContext context) {
    switch (status) {
      case InvoiceStatus.paid:
        return Colors.green.shade100;
      case InvoiceStatus.partial:
        return Colors.orange.shade100;
      case InvoiceStatus.unpaid:
      default:
        return Colors.red.shade100;
    }
  }

  Color _textColor() {
    switch (status) {
      case InvoiceStatus.paid:
        return Colors.green.shade900;
      case InvoiceStatus.partial:
        return Colors.orange.shade900;
      case InvoiceStatus.unpaid:
      default:
        return Colors.red.shade900;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(status.name.toUpperCase(), style: TextStyle(color: _textColor())),
      backgroundColor: _backgroundColor(context),
    );
  }
}
