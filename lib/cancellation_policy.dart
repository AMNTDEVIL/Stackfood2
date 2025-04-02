import 'package:flutter/material.dart';

class CancellationPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cancellation Policy'),
      ),
      body: Column(
        children: [
          Divider(
            thickness: 1,
            color: Colors.grey,
            indent: 16,
            endIndent: 16,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Our cancellation policy is designed to provide flexibility while ensuring fairness:',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '''1. **Order Cancellation**: You may cancel your order at any time before preparation begins. Once preparation starts, cancellations are not allowed.

2. **Cancellation Process**: To cancel an order, go to your order history and select the "Cancel Order" option. Alternatively, contact our support team.

3. **Refunds for Cancellations**: If you cancel an eligible order, a full refund will be processed within 5-7 business days.

4. **Late Cancellations**: If you cancel after preparation has started, you may be charged a partial fee to cover costs.

5. **Exceptions**: In cases of delayed delivery or incorrect orders, you may be eligible for a full refund.

6. **Contact Us**: For assistance with cancellations, please contact our support team at support@stackfood.com.''',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}