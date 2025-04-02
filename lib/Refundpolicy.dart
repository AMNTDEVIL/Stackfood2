import 'package:flutter/material.dart';

class RefundPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Policy'),
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
                    'Our refund policy ensures a fair and transparent process for all users:',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '''1. **Eligibility for Refunds**: Refunds are only available for orders that are canceled before preparation begins. Once preparation starts, refunds cannot be processed.

2. **Refund Process**: To request a refund, contact our support team within 24 hours of placing your order. Provide your order details and reason for the refund request.

3. **Refund Timeframe**: Approved refunds will be processed within 5-7 business days. The refund will be credited to your original payment method.

4. **Non-Refundable Items**: Certain items, such as promotional discounts or gift cards, are non-refundable.

5. **Exceptions**: In cases of incorrect orders or quality issues, we may offer a full or partial refund at our discretion.

6. **Contact Us**: For any questions regarding refunds, please contact our support team at support@stackfood.com.''',
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