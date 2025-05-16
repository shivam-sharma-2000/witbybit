import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/CartItem.dart';
import '../utils/constants.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller = TextEditingController();
  List<CartItem> allItems = [
    CartItem(name: "Chicken Slab Burger", image: 'assets/img1.png', price: 259),
    CartItem(name: "Chicken Crunch Burger", image: 'assets/img2.png', price: 209),
    CartItem(name: "Donut Header Chicken", image: 'assets/img3.png', price: 199),
    CartItem(name: "Mighty Chicken Patty Burger", image: 'assets/img1.png', price: 209),
  ];

  List<CartItem> filteredItems = [];

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
    filteredItems = allItems;
  }

  void _onSearchChanged() {
    String query = _controller.text.toLowerCase();
    setState(() {
      filteredItems = allItems
          .where((item) => item.name.toLowerCase().contains(query))
          .toList();
    });
  }

  void updateCart(CartItem item, int change) {
    setState(() {
      item.quantity += change;
      if (item.quantity <= 0) {
        cart.remove(item.name);
        item.quantity = 0;
      } else {
        cart[item.name] = item;
      }
    });
  }

  Widget _buildCartItem(CartItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(item.image, width: 80, height: 80, fit: BoxFit.fitWidth),
                ),
              ),
            ],
          ),

          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: TextStyle(fontWeight: FontWeight.bold)),
                Text("It is a long established fact that a reader will be distracted."),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text("₹ ${item.price}", style: TextStyle(fontWeight: FontWeight.bold)),
                    Spacer(),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () => updateCart(item, -1),
                    ),
                    Text("${item.quantity}"),
                    IconButton(
                      icon: Icon(Icons.add, color: Colors.green),
                      onPressed: () => updateCart(item, 1),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCartSummary() {
    if (cart.isEmpty) return SizedBox.shrink();

    int totalQty = cart.values.fold(0, (sum, item) => sum + item.quantity);
    int totalPrice = cart.values.fold(0, (sum, item) => sum + item.quantity * item.price);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: Colors.white,
      child: Row(
        children: [
          Text("$totalQty item${totalQty > 1 ? 's' : ''} | ₹ $totalPrice"),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              // Go to cart page if needed
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,

            ),
            child: Text("View cart", style: TextStyle(color: Colors.white),),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: "Search",
            border: InputBorder.none,
            suffixIcon: Icon(Icons.mic),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Wrap(
              spacing: 10,
              children: [
                'Burgers', 'Chicken', 'Fries', 'Beverages', 'Sides', 'Desserts'
              ].map((label) => Chip(
                backgroundColor: Colors.green.shade50,
                label: Text(label),
              )).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("${filteredItems.length} Search results...", style: TextStyle(fontSize: 14)),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredItems.length,
              itemBuilder: (_, index) => _buildCartItem(filteredItems[index]),
              separatorBuilder: (_, __) => Divider(color: Colors.grey.shade300),
            ),
          ),
          _buildCartSummary(),
        ],
      ),
    );
  }
}
