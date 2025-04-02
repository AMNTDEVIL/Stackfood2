function search(query) {
  query = query.toLowerCase();  // Convert query to lowercase
  let results = [];

  // Search restaurants by name
  for (let restaurant of restaurants) {
    if (restaurant.name.toLowerCase().includes(query)) {
      results.push(restaurant.name);
    }

    // Search food items in the restaurant
    for (let foodItem of restaurant.foodItems) {
      if (foodItem.name.toLowerCase().includes(query)) {
        results.push(`${restaurant.name} - ${foodItem.name}`);
      }
    }
  }

  return results;
}

let query = "zz";  // Query can be any part of the food or restaurant name
let foundItems = search(query);

// Print results
console.log(`Results for '${query}':`);
foundItems.forEach(item => console.log(item));
