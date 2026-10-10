import 'package:flutter/material.dart';
import 'package:speanmeas/features/widget/widget.dart' as widget;

class ReceiptItem {
  final String name;
  final int quantity;
  final double unitPrice;

  const ReceiptItem({
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get total => quantity * unitPrice;
}

class _Main_State extends State<Main_> {
  // ########## BLOCK: Attributes // ##########

  // TODO: replace with real guest/stay/charge data once a booking and
  // charges endpoint exists.
  final String guestName = 'Sok Dara';
  final String roomNumber = '201';
  final DateTime checkIn = DateTime(2026, 9, 21);
  final DateTime checkOut = DateTime(2026, 9, 22);

  final List<ReceiptItem> roomServiceItems = const [
    ReceiptItem(name: 'Club Sandwich', quantity: 1, unitPrice: 6.50),
    ReceiptItem(name: 'Iced Coffee', quantity: 2, unitPrice: 2.75),
  ];
  final List<ReceiptItem> miniBarItems = const [
    ReceiptItem(name: 'Bottled Water', quantity: 2, unitPrice: 1.50),
    ReceiptItem(name: 'Snack Mix', quantity: 1, unitPrice: 3.00),
  ];
  final List<ReceiptItem> punishmentItems = const [
    ReceiptItem(name: 'Late Checkout Fee', quantity: 1, unitPrice: 10.00),
  ];
  // ########## END BLOCK: Attributes // ##########

  // ########## BLOCK: Design // ##########
  @override
  Widget build(BuildContext context) {
    return widget.buildLayout(
      title: 'Receipt',
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.black12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.black87, fontSize: 13),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildDashedDivider(),
                    const SizedBox(height: 8),
                    _buildInfoLine('Guest / ភ្ញៀវ', guestName),
                    _buildInfoLine('Room / បន្ទប់', roomNumber),
                    _buildInfoLine(
                      'Stay / ការស្នាក់នៅ',
                      '${_formatDate(checkIn)} - ${_formatDate(checkOut)}',
                    ),
                    _buildInfoLine(
                      'Date / កាលបរិច្ឆេទ',
                      _formatDate(DateTime.now()),
                    ),
                    const SizedBox(height: 8),
                    _buildDashedDivider(),
                    const SizedBox(height: 8),
                    _buildRow(
                      'Item / មុខទំនិញ',
                      'Qty / ចំនួន',
                      'Amount / ទឹកប្រាក់',
                      bold: true,
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      'Room Service / សេវាកម្មបន្ទប់',
                      roomServiceItems,
                    ),
                    const SizedBox(height: 12),
                    _buildSection('MiniBar / មីនីបារ', miniBarItems),
                    const SizedBox(height: 12),
                    _buildSection('Punishment / ពិន័យ', punishmentItems),
                    const SizedBox(height: 12),
                    _buildDashedDivider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total / សរុបរួម',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _money(_grandTotal),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Center(
                      child: Text(
                        'Thank you / អរគុណ',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return const Column(
      children: [
        Text(
          'Spean Meas Hotel',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('សណ្ឋាគារ ស្ពានមាស', style: TextStyle(fontSize: 14)),
        SizedBox(height: 4),
        Text(
          'Receipt / បង្កាន់ដៃ',
          style: TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildInfoLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.black54)),
          Text(value),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<ReceiptItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        for (final item in items)
          _buildRow(item.name, '${item.quantity}', _money(item.total)),
        const SizedBox(height: 4),
        _buildRow(
          'Subtotal / សរុបរង',
          '',
          _money(_sectionTotal(items)),
          muted: true,
        ),
      ],
    );
  }

  /// One table row shaped like the reference receipt: name on the left,
  /// quantity in the middle, amount right-aligned.
  Widget _buildRow(
    String name,
    String qty,
    String amount, {
    bool bold = false,
    bool muted = false,
  }) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontStyle: muted ? FontStyle.italic : FontStyle.normal,
      color: muted ? Colors.black54 : null,
      fontSize: bold ? 12 : 13,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: Text(name, style: style)),
          Expanded(
            flex: 2,
            child: Text(qty, textAlign: TextAlign.center, style: style),
          ),
          Expanded(
            flex: 3,
            child: Text(amount, textAlign: TextAlign.right, style: style),
          ),
        ],
      ),
    );
  }

  /// Thermal-receipt style dashed line.
  Widget _buildDashedDivider() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final count = (constraints.maxWidth / 6).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            count,
            (_) => const SizedBox(
              width: 3,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Colors.black38),
              ),
            ),
          ),
        );
      },
    );
  }
  // ########## END BLOCK: Design // ##########

  // ########## BLOCK: Methods // ##########
  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  String _money(double value) => '\$${value.toStringAsFixed(2)}';

  double _sectionTotal(List<ReceiptItem> items) =>
      items.fold(0, (sum, item) => sum + item.total);

  double get _grandTotal =>
      _sectionTotal(roomServiceItems) +
      _sectionTotal(miniBarItems) +
      _sectionTotal(punishmentItems);

  @override
  void initState() {
    super.initState();
  }
  // ########## END BLOCK: Method // ##########
}

class Main_ extends StatefulWidget {
  const Main_({super.key});

  @override
  State<Main_> createState() => _Main_State();
}

void main() {
  runApp(
    MaterialApp(
      title: "Development",
      debugShowCheckedModeBanner: false,
      home: Main_(),
    ),
  );
}
