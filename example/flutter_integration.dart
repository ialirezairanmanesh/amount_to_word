import 'package:flutter/material.dart';
import 'package:amount_to_word/amount_to_word.dart';

/// Example Flutter app demonstrating amount_to_word package integration
class AmountToWordDemo extends StatefulWidget {
  const AmountToWordDemo({super.key});

  @override
  State<AmountToWordDemo> createState() => _AmountToWordDemoState();
}

class _AmountToWordDemoState extends State<AmountToWordDemo> {
  final TextEditingController _controller = TextEditingController();
  double _amount = 0;
  CurrencyConfig _selectedCurrency = CurrencyConfig.usDollar;

  @override
  void initState() {
    super.initState();
    _controller.text = '123.45';
    _amount = 123.45;
  }

  @override
  Widget build(BuildContext context) {
    // Auto-detect converter based on app locale
    final converter = AmountToWords.fromContext(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Amount to Words Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount input
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter Amount',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _amount = double.tryParse(value) ?? 0;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Currency selection
            DropdownButtonFormField<CurrencyConfig>(
              value: _selectedCurrency,
              decoration: const InputDecoration(
                labelText: 'Currency',
                border: OutlineInputBorder(),
              ),
              items: [
                DropdownMenuItem(
                  value: CurrencyConfig.usDollar,
                  child: Text('US Dollar'),
                ),
                DropdownMenuItem(
                  value: CurrencyConfig.euro,
                  child: Text('Euro'),
                ),
                DropdownMenuItem(
                  value: CurrencyConfig.iranianToman,
                  child: Text('Iranian Toman'),
                ),
                DropdownMenuItem(
                  value: CurrencyConfig.iranianRial,
                  child: Text('Iranian Rial'),
                ),
                DropdownMenuItem(
                  value: CurrencyConfig.turkishLira,
                  child: Text('Turkish Lira'),
                ),
                DropdownMenuItem(
                  value: CurrencyConfig.canadianDollar,
                  child: Text('Canadian Dollar'),
                ),
                DropdownMenuItem(
                  value: CurrencyConfig.afghanAfghani,
                  child: Text('Afghan Afghani'),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedCurrency = value!;
                });
              },
            ),
            
            const SizedBox(height: 24),
            
            // Results
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Result',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    
                    // Number only
                    Text(
                      'Number only: ${converter.toWords(_amount)}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    
                    // With currency
                    Text(
                      'With currency: ${converter.convert(_amount, currency: _selectedCurrency)}',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Language info
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language Info',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text('Detected Language: ${converter.language.name}'),
                    Text('Language Code: ${converter.language.code}'),
                    Text('Locale: ${Localizations.localeOf(context)}'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    title: 'Amount to Words Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: const AmountToWordDemo(),
    // Example with Persian locale
    localizationsDelegates: const [
      // Add your localization delegates here
    ],
    supportedLocales: const [
      Locale('en', 'US'),
      Locale('fa', 'IR'),
      Locale('tr', 'TR'),
    ],
  ));
}
