import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: Column(
        children: [
          // Add a grey divider below the AppBar title
          Divider(
            thickness: 1,  // Line thickness
            color: Colors.grey,  // Line color
            indent: 16,  // Indentation from left
            endIndent: 16,  // Indentation from right
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    'Stackfood is a complete Multi-vendor food product delivery system developed with a powerful admin panel that helps you control your business smartly.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    '''Stackfood est un système de livraison de produits alimentaires multi-vendeurs complet développé avec un puissant panneau d'administration qui vous permet de contrôler votre entreprise de manière intelligente. Grâce à Stackfood, vous pouvez gérer efficacement les commandes, surveiller les performances des vendeurs et offrir une expérience client exceptionnelle.

Notre système est conçu pour répondre aux besoins des entreprises modernes de restauration, en offrant des outils flexibles et personnalisables. Vous pouvez suivre les ventes, optimiser les délais de livraison, et élargir votre portée en ligne grâce à nos fonctionnalités conviviales.

Nous nous engageons à protéger vos données et à vous offrir une solution technologique fiable pour que vous puissiez vous concentrer sur ce qui compte vraiment : la satisfaction de vos clients.''',
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
