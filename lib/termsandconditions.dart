import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
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
                    'By using Stackfood, you agree to the following terms and conditions:',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '''1. **Acceptance of Terms**: By accessing or using Stackfood, you agree to be bound by these terms and conditions. If you do not agree, you may not use the service.

2. **User Responsibilities**: You are responsible for maintaining the confidentiality of your account and password. You agree to notify us immediately of any unauthorized use of your account.

3. **Prohibited Activities**: You may not use Stackfood for any illegal or unauthorized purpose. You must not violate any laws in your jurisdiction.

4. **Modifications to Terms**: Stackfood reserves the right to modify these terms at any time. Your continued use of the service constitutes acceptance of the modified terms.

5. **Termination**: We may terminate or suspend your account immediately, without prior notice, for any reason, including violation of these terms.

6. **Governing Law**: These terms are governed by the laws of your country. Any disputes will be resolved in the courts of your jurisdiction.

''',

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