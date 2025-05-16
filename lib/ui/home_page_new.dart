import 'package:flutter/material.dart';
import 'package:untitled/ui/search_page.dart';

import '../model/CartItem.dart';
import '../utils/constants.dart';

void main() => runApp(MaterialApp(home: FoodMenuScreen()));

class FoodMenuScreen extends StatefulWidget {
  @override
  State<FoodMenuScreen> createState() => _FoodMenuScreenState();
}

class _FoodMenuScreenState extends State<FoodMenuScreen> {

  List<CartItem> menuItems = [
    CartItem(name: "Chicken Slab Burger", image: 'assets/img1.png', price: 259),
    CartItem(name: "Chicken Crunch Burger", image: 'assets/img2.png', price: 209),
    CartItem(name: "Donut Header Chicken", image: 'assets/img3.png', price: 199),
    CartItem(name: "Mighty Chicken Patty Burger", image: 'assets/img1.png', price: 209),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void restoreItem() {
    setState(() {
      menuItems = Constant().restoreItem(menuItems);
    });
  }

  void updateCart(CartItem item, int change) {
    setState(() {
      item.quantity += change;
      if (item.quantity <= 0) {
        Constant.cart.remove(item.name);
        item.quantity = 0;
      } else {
        Constant.cart[item.name] = item;
        print(Constant.cart.values.first.name);
      }
    });
  }

  int getItemQty(CartItem item) => item.quantity ?? 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/bg.jpg',
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 50,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconButton(context, Icons.arrow_back_ios_new),
                      Row(
                        children: [
                          GestureDetector(
                              child: _iconButton(context, Icons.search),
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())).then((onValue){
                                restoreItem();
                              });
                            },
                          ),
                          SizedBox(width: 8),
                          _iconButton(context, Icons.share),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Amerika Foods", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("American, Fast Food, Burgers", style: TextStyle(color: Colors.grey[600])),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      _iconText(Icons.star, "4.5"),
                      SizedBox(width: 10),
                      Text("|"),
                      SizedBox(width: 10),
                      _iconText(Icons.chat_bubble_outline, "1K+ reviews"),
                      SizedBox(width: 10),
                      Text("|"),
                      SizedBox(width: 10),
                      _iconText(Icons.access_time, "15 mins"),
                      Spacer(),
                      Icon(Icons.favorite_border, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
            TabBar(
              labelColor: Colors.green,
              unselectedLabelColor: Colors.black,
              indicatorColor: Colors.green,
              isScrollable: true,
              tabs: [
                Tab(text: 'Recommended'),
                Tab(text: 'Combos'),
                Tab(text: 'Regular Burgers'),
                Tab(text: 'Specials'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildFoodList(),
                  Center(child: Text("Combos")),
                  Center(child: Text("Regular Burgers")),
                  Center(child: Text("Specials")),
                ],
              ),
            ),
            _buildCartSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodList() {
    return ListView.separated(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: menuItems.length,
      separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
      itemBuilder: (context, index) {
        final item = menuItems[index];
        final qty = getItemQty(item);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: Image.asset(
                        item.image,
                        width: 80,
                        height: 80,
                        fit: BoxFit.fitWidth
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 4),
                    Text(
                      "It is a long established fact that a reader will be distracted.",
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("₹ ${item.price}", style: TextStyle(fontWeight: FontWeight.bold)),
                        Spacer(),
                        GestureDetector(
                          onTap: () => updateCart(item, -1),
                          child: _qtyButton(Icons.remove, borderColor: Colors.grey),
                        ),
                        SizedBox(width: 20),
                        Text("$qty"),
                        SizedBox(width: 20),
                        GestureDetector(
                          onTap: () => updateCart(item, 1),
                          child: _qtyButton(Icons.add, borderColor: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _qtyButton(IconData icon, {Color borderColor = Colors.grey}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: EdgeInsets.all(4),
      child: Icon(icon, size: 18, color: borderColor),
    );
  }

  Widget _buildCartSummary() {
    if (Constant.cart.isEmpty) return SizedBox.shrink();

    int totalQty = Constant.cart.values.fold(0, (sum, item) => sum + item.quantity);
    int totalPrice = 0;

    Constant.cart.forEach((title, itm) {
      final item = menuItems.firstWhere((e) => e.name == title);
      totalPrice += item.price * itm.quantity;
    });

    return Material(
      elevation: 10,
      shadowColor: Colors.black,
      color: Colors.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Text("$totalQty item${totalQty > 1 ? 's' : ''} | ₹ $totalPrice", style: TextStyle(fontWeight: FontWeight.bold),),
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
      ),
    );
  }

  Widget _iconButton(BuildContext context, IconData icon) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: Colors.amber, size: 16),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:untitled/search_page.dart';
//
// void main() => runApp(MaterialApp(home: FoodMenuScreen()));
//
// class FoodMenuScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         body: Column(
//           children: [
//             Stack(
//               children: [
//                 Image.asset(
//                   'assets/bg.jpg',
//                   width: double.infinity,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   top: 50,
//                   left: 16,
//                   right: 16,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _iconButton(context, Icons.arrow_back_ios_new),
//                       Row(
//                         children: [
//                           _iconButton(context, Icons.search),
//                           SizedBox(width: 8),
//                           _iconButton(context, Icons.share),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(
//                 horizontal: 16.0,
//                 vertical: 10,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Amerika Foods",
//                     style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 4),
//                   Text(
//                     "American, Fast Food, Burgers",
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       _iconText(Icons.star, "4.5"),
//                       SizedBox(width: 10),
//                       _iconText(Icons.chat_bubble_outline, "1K+ reviews"),
//                       SizedBox(width: 10),
//                       _iconText(Icons.access_time, "15 mins"),
//                       Spacer(),
//                       Icon(Icons.favorite_border, color: Colors.grey),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
//             TabBar(
//               labelColor: Colors.green,
//               unselectedLabelColor: Colors.black,
//               indicatorColor: Colors.green,
//               isScrollable: true,
//               tabs: [
//                 Tab(text: 'Recommended'),
//                 Tab(text: 'Combos'),
//                 Tab(text: 'Regular Burgers'),
//                 Tab(text: 'Specials'),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   _buildFoodList(),
//                   Center(child: Text("Combos")),
//                   Center(child: Text("Regular Burgers")),
//                   Center(child: Text("Specials")),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _iconButton(BuildContext context, IconData icon) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//         child: IconButton(
//           icon: Icon(icon, size: 20),
//           highlightColor: Colors.white,
//           onPressed: () {
//             Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
//           },
//         ),
//     );
//   }
//
//   Widget _iconText(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.amber, size: 16),
//         SizedBox(width: 4),
//         Text(text, style: TextStyle(fontSize: 14)),
//       ],
//     );
//   }
//
//   Widget _buildFoodList() {
//     final menuItems = [
//       {
//         'title': "Chicken Crunch Burger",
//         'price': 209,
//         'image': 'assets/img1.png',
//       },
//       {
//         'title': "Mighty Chicken Patty Burger",
//         'price': 259,
//         'image': 'assets/img2.png',
//       },
//       {
//         'title': "Donut Header Chicken",
//         'price': 199,
//         'image': 'assets/img3.png',
//       },
//     ];
//
//     return ListView.separated(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       itemCount: menuItems.length,
//       separatorBuilder:
//           (context, index) => Divider(height: 1, color: Colors.grey.shade300),
//       itemBuilder: (context, index) {
//         final item = menuItems[index];
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.asset(
//                   item['image'].toString(),
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       item['title'].toString(),
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 16,
//                       ),
//                     ),
//                     SizedBox(height: 4),
//                     Text(
//                       "It is a long established fact that a reader will be distracted.",
//                       style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Text(
//                           "₹ ${item['price']}",
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                         Spacer(),
//                         _qtyButton(Icons.remove),
//                         SizedBox(width: 6),
//                         Text("0"),
//                         SizedBox(width: 6),
//                         _qtyButton(Icons.add, borderColor: Colors.green),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _qtyButton(IconData icon, {Color borderColor = Colors.grey}) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: borderColor),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Icon(icon, size: 18, color: borderColor),
//     );
//   }
// }



//======


// import 'package:flutter/material.dart';
// import 'package:untitled/search_page.dart';
// import 'package:provider/provider.dart';
//
// void main() => runApp(
//   ChangeNotifierProvider(
//     create: (_) => CartProvider(),
//     child: MaterialApp(home: FoodMenuScreen()),
//   ),
// );
//
// class CartProvider with ChangeNotifier {
//   Map<String, int> _cart = {};
//
//   Map<String, int> get cart => _cart;
//
//   void updateItem(String title, int change) {
//     final currentQty = _cart[title] ?? 0;
//     final newQty = currentQty + change;
//     if (newQty <= 0) {
//       _cart.remove(title);
//     } else {
//       _cart[title] = newQty;
//     }
//     notifyListeners();
//   }
//
//   int getQty(String title) => _cart[title] ?? 0;
//
//   int get totalQty => _cart.values.fold(0, (a, b) => a + b);
//   int totalPrice(List<Map<String, dynamic>> menuItems) {
//     int total = 0;
//     _cart.forEach((title, qty) {
//       final item = menuItems.firstWhere((e) => e['title'] == title);
//       total += item['price'] * qty;
//     });
//     return total;
//   }
// }
//
// class FoodMenuScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> menuItems = [
//     {
//       'title': "Chicken Crunch Burger",
//       'price': 209,
//       'image': 'assets/img1.png',
//     },
//     {
//       'title': "Mighty Chicken Patty Burger",
//       'price': 259,
//       'image': 'assets/img2.png',
//     },
//     {
//       'title': "Donut Header Chicken",
//       'price': 199,
//       'image': 'assets/img3.png',
//     },
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//
//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         body: Column(
//           children: [
//             Stack(
//               children: [
//                 Image.asset(
//                   'assets/bg.jpg',
//                   width: double.infinity,
//                   height: 250,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   top: 50,
//                   left: 16,
//                   right: 16,
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _iconButton(context, Icons.arrow_back_ios_new),
//                       Row(
//                         children: [
//                           _iconButton(context, Icons.search),
//                           SizedBox(width: 8),
//                           _iconButton(context, Icons.share),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Amerika Foods", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//                   SizedBox(height: 4),
//                   Text("American, Fast Food, Burgers", style: TextStyle(color: Colors.grey[600])),
//                   SizedBox(height: 8),
//                   Row(
//                     children: [
//                       _iconText(Icons.star, "4.5"),
//                       SizedBox(width: 10),
//                       _iconText(Icons.chat_bubble_outline, "1K+ reviews"),
//                       SizedBox(width: 10),
//                       _iconText(Icons.access_time, "15 mins"),
//                       Spacer(),
//                       Icon(Icons.favorite_border, color: Colors.grey),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
//             TabBar(
//               labelColor: Colors.green,
//               unselectedLabelColor: Colors.black,
//               indicatorColor: Colors.green,
//               isScrollable: true,
//               tabs: [
//                 Tab(text: 'Recommended'),
//                 Tab(text: 'Combos'),
//                 Tab(text: 'Regular Burgers'),
//                 Tab(text: 'Specials'),
//               ],
//             ),
//             Expanded(
//               child: TabBarView(
//                 children: [
//                   _buildFoodList(context),
//                   Center(child: Text("Combos")),
//                   Center(child: Text("Regular Burgers")),
//                   Center(child: Text("Specials")),
//                 ],
//               ),
//             ),
//             if (cart.cart.isNotEmpty)
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//                 color: Colors.white,
//                 child: Row(
//                   children: [
//                     Text("${cart.totalQty} items | ₹${cart.totalPrice(menuItems)}"),
//                     Spacer(),
//                     ElevatedButton(
//                       onPressed: () {},
//                       style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
//                       child: Text("View cart"),
//                     ),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildFoodList(BuildContext context) {
//     final cart = Provider.of<CartProvider>(context);
//
//     return ListView.separated(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       itemCount: menuItems.length,
//       separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade300),
//       itemBuilder: (context, index) {
//         final item = menuItems[index];
//         final qty = cart.getQty(item['title']);
//         return Padding(
//           padding: const EdgeInsets.symmetric(vertical: 12.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(12),
//                 child: Image.asset(
//                   item['image'],
//                   width: 80,
//                   height: 80,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(item['title'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//                     SizedBox(height: 4),
//                     Text(
//                       "It is a long established fact that a reader will be distracted.",
//                       style: TextStyle(color: Colors.grey[600], fontSize: 13),
//                     ),
//                     SizedBox(height: 8),
//                     Row(
//                       children: [
//                         Text("₹ ${item['price']}", style: TextStyle(fontWeight: FontWeight.bold)),
//                         Spacer(),
//                         GestureDetector(
//                           onTap: () => cart.updateItem(item['title'], -1),
//                           child: _qtyButton(Icons.remove),
//                         ),
//                         SizedBox(width: 6),
//                         Text("$qty"),
//                         SizedBox(width: 6),
//                         GestureDetector(
//                           onTap: () => cart.updateItem(item['title'], 1),
//                           child: _qtyButton(Icons.add, borderColor: Colors.green),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _qtyButton(IconData icon, {Color borderColor = Colors.grey}) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: borderColor),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       padding: EdgeInsets.all(4),
//       child: Icon(icon, size: 18, color: borderColor),
//     );
//   }
//
//   Widget _iconButton(BuildContext context, IconData icon) {
//     return Material(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(10),
//       child: IconButton(
//         icon: Icon(icon, size: 20),
//         onPressed: () {
//           Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen()));
//         },
//       ),
//     );
//   }
//
//   Widget _iconText(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.amber, size: 16),
//         SizedBox(width: 4),
//         Text(text, style: TextStyle(fontSize: 14)),
//       ],
//     );
//   }
// }
