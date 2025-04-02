import 'package:flutter/material.dart';

class CouponPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Coupons'),
        backgroundColor: Colors.orange,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildCouponCard(
            discount: '10.0% OFF',
            restaurant: 'Hungry Puppets',
            validity: '07 Feb 2023 to 01 Dec 2025',
            minPurchase: '*Min Purchase \$50',
          ),
          SizedBox(height: 16),
          _buildCouponCard(
            discount: '50.0% OFF',
            restaurant: 'on Hungry Puppets',
            validity: '07 Feb 2023 to 01 Dec 2025',
            minPurchase: '*Min Purchase \$100',
          ),
          SizedBox(height: 16),
          _buildCouponCard(
            discount: '20.0% OFF',
            restaurant: 'On all restaurants!',
            validity: '07 Feb 2023 to 01 Dec 2025',
            minPurchase: '*Min Purchase \$300',
          ),
          SizedBox(height: 16),
          _buildCouponCard(
            discount: 'Free Delivery',
            restaurant: 'On all restaurants!',
            validity: '07 Feb 2023 to 01 Dec 2025',
            minPurchase: '*Min Purchase \$150',
          ),
        ],
      ),
    );
  }

  Widget _buildCouponCard({
    required String discount,
    required String restaurant,
    required String validity,
    required String minPurchase,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              discount,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8),
            Text(
              restaurant,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              validity,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 8),
            Text(
              minPurchase,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
