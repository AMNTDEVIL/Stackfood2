import 'package:flutter/material.dart';

class RestaurantPage extends StatelessWidget{
  const RestaurantPage ({Key? key}): super (key:key);
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const HeaderSection(
              image: "assets/discount_image.jpeg",
              title: "All restaurant",
              subtitle: "15 Restaurant Near You",
            ),
            const FilterSelector(
              filters:[
                "Top Rated","Discount","Veg","Non-Veg",
              ]
            ),
            //Restaurant Cards
            RestaurantCard(
              image: "assets/cafemonarch.png",
              name:"cafe monarch",
              rating:5.0,
              deliveryTime:"30-40mins",
              distance:"1879.00km",
            ),
            RestaurantCard(
              image: "assets/hungrypuppets.png",
              name: "hungry puppets.png",
              rating:4.7,
              deliveryTime:"30-40mins",
              distance:"563.83km",
            )
          ],
        ),
      ),
    );
  }
}

class FilterSelector extends StatelessWidget{
  final List<String> filters;
  const FilterSelector({
    Key?key,
    required this.filters
}): super (key:key);

  @override
  Widget build(BuildContext context) {
          return Padding(padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: filters.map((filter)=>buildFilterchip(filter)).toList(),

          ),
          );
  }
  Widget buildFilterchip(String label){
    return Chip(label: Text(label),backgroundColor: Colors.grey[200],);
  }
}
class RestaurantCard extends StatelessWidget {
  final String image;
  final String name;
  final double rating;
  final String deliveryTime;
  final String distance;

  const RestaurantCard({
    Key? key,
    required this.image,
    required this.name,
    required this.rating,
    required this.deliveryTime,
    required this.distance,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // Restaurant Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10)),
              child: Image.asset(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Restaurant Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "$rating ★",
                    style: TextStyle(color: Colors.orange[400], fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    deliveryTime,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    distance,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 10,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class HeaderSection extends StatelessWidget{
  final String image;
  final String title;
  final String subtitle;
  const HeaderSection({
    Key?key,
    required this.image,
    required this.title,
    required this.subtitle,
  }): super (key: key);
  @override
  Widget build(BuildContext context){
    return Stack(
      children: [
        Container(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage(image),fit: BoxFit.cover),
          ),
        ),
        Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold,color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4.0,
                      color: Colors.black,
                      offset: Offset(2.0, 2.0),
                    ),
                  ]
                ),),
                Text(subtitle,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 10,color: Colors.grey[50]),)
              ],
        ))
      ],
    );
  }
}
