import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
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

  String _localizedStatus(BuildContext context) {
    switch (status) {
      case InvoiceStatus.paid:
        return context.l10n.tr('paid').toUpperCase();
      case InvoiceStatus.partial:
        return context.l10n.tr('partial').toUpperCase();
      case InvoiceStatus.unpaid:
        return context.l10n.tr('unpaid').toUpperCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(_localizedStatus(context), style: TextStyle(color: _textColor())),
      backgroundColor: _backgroundColor(context),
    );
  }
}
