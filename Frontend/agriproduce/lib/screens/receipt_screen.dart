import 'package:agriproduce/data_models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;

class ReceiptScreen extends StatelessWidget {
  final Transaction transaction;

  const ReceiptScreen({Key? key, required this.transaction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receipt'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              _shareReceipt();
            },
          ),
          IconButton(
            icon: const Icon(Icons.print),
            onPressed: () {
              _printReceipt(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Receipt Details',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailCard('Commodity Name', transaction.commodityName),
            _buildDetailCard('Weight', '${transaction.weight} kg'),
            _buildDetailCard('Supplier', transaction.supplierName),
            _buildDetailCard(
                'Price', '\$${transaction.price.toStringAsFixed(2)}'),
            _buildDetailCard(
              'Date',
              transaction.transactionDate != null
                  ? DateFormat('yyyy-MM-dd')
                      .format(transaction.transactionDate!)
                  : 'No date available',
            ),
            const Spacer(),
            _buildContactInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }

  void _shareReceipt() {
    final String receiptDetails = '''
    Receipt Details:
    Commodity Name: ${transaction.commodityName}
    Weight: ${transaction.weight} kg
    Supplier: ${transaction.supplierName}
    Price: \$${transaction.price.toStringAsFixed(2)}
    Date: ${transaction.transactionDate != null ? DateFormat('yyyy-MM-dd').format(transaction.transactionDate!) : 'No date available'}
    ''';

    Share.share(receiptDetails,
        subject: 'Receipt for ${transaction.commodityName}');
  }

  void _printReceipt(BuildContext context) async {
    final pdf = pw.Document();

    // QR Code generation
    final qrData =
        'Commodity: ${transaction.commodityName}\nSupplier: ${transaction.supplierName}\nPrice: \$${transaction.price.toStringAsFixed(2)}';
    final qrCodeImage = await _generateQRCode(qrData);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Receipt Details',
                  style: pw.TextStyle(
                      fontSize: 26, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              _buildDetailPDF('Commodity Name', transaction.commodityName),
              _buildDetailPDF('Weight', '${transaction.weight} kg'),
              _buildDetailPDF('Supplier', transaction.supplierName),
              _buildDetailPDF(
                  'Price', '\$${transaction.price.toStringAsFixed(2)}'),
              _buildDetailPDF(
                'Date',
                transaction.transactionDate != null
                    ? DateFormat('yyyy-MM-dd')
                        .format(transaction.transactionDate!)
                    : 'No date available',
              ),
              pw.SizedBox(height: 20),
              pw.Center(child: pw.Image(qrCodeImage)), // Center the QR code
              pw.SizedBox(height: 20),
              _buildContactInfoPDF(),
            ],
          );
        },
      ),
    );

    try {
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error printing receipt: $e')),
      );
    }
  }

  Future<pw.MemoryImage> _generateQRCode(String data) async {
    final qrPainter = QrPainter(
      data: data,
      version: QrVersions.auto,
      gapless: true,
    );

    // Generate a QR code image
    final qrImage = await qrPainter.toImage(200);
    final byteData = await qrImage.toByteData(
        format: ui.ImageByteFormat.png); // Use PNG format

    // Return the image as MemoryImage
    return pw.MemoryImage(byteData!.buffer.asUint8List());
  }

  pw.Widget _buildDetailPDF(String title, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(12.0),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(title,
              style:
                  pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
          pw.Text(value, style: const pw.TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  pw.Widget _buildContactInfoPDF() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Divider(thickness: 1),
        pw.SizedBox(height: 16),
        pw.Text('Contact Us:',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        pw.SizedBox(height: 8),
        pw.Bullet(text: 'Phone: (123) 456-7890'),
        pw.Bullet(text: 'Email: support@example.com'),
        pw.Bullet(text: 'Address: 1234 Main St, Anytown, USA'),
        pw.SizedBox(height: 16),
        pw.Center(
          child: pw.Text('Follow us on:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ),
        pw.SizedBox(height: 8),
        pw.Center(
          child: pw.Text('Facebook  |  Twitter',
              style: pw.TextStyle(fontWeight: pw.FontWeight.normal)),
        ),
        pw.SizedBox(height: 16),
        pw.Center(
          child: pw.Text(
            'Thank you for your purchase!',
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(thickness: 1),
        const SizedBox(height: 16),
        Row(
          children: const [
            Icon(Icons.phone, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text('Phone: (123) 456-7890',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.email, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text('Email: support@example.com',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Icon(Icons.location_on, color: Colors.blueAccent),
            SizedBox(width: 8),
            Text('Address: 1234 Main St, Anytown, USA',
                style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        const SizedBox(height: 16),
        const SizedBox(height: 8),
        const Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.facebook, color: Colors.blueAccent),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Center(
          child: Text(
            'Thank you for your purchase!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
