import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/dummy_products.dart';
import '../../../providers/cart_provider.dart';

class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  final Map<String, String?> selectedSize = {};

  List<String> getSizesForCategory(String category) {
    if (category == "Shoes") {
      return ["5", "6", "7", "8", "9", "10", "11", "12", "13"];
    }
    // Default: Women & Men
    return ["XS", "S", "M", "L", "XL"];
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final filtered = dummyProducts
        .where((p) => p.category.toLowerCase() == widget.categoryName.toLowerCase())
        .toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.black,
      ),
      body: filtered.isEmpty
          ? Center(
              child: Text(
                "No products found",
                style: TextStyle(color: Colors.white70),
              ),
            )
          : GridView.builder(
              padding: EdgeInsets.all(16),
              itemCount: filtered.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.60,
              ),
              itemBuilder: (context, index) {
                final product = filtered[index];
                final qty = cart.items[product] ?? 0;

                final availableSizes = getSizesForCategory(widget.categoryName);

                return Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // IMAGE
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          child: Image.asset(
                            product.imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),

                      // NAME
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Text(
                          product.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // PRICE
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          "\$${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: 6),

                      // SIZE SELECTOR
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Wrap(
                          spacing: 6,
                          children: availableSizes.map((size) {
                            final isSelected = selectedSize[product.id] == size;
                            return ChoiceChip(
                              label: Text(size),
                              selected: isSelected,
                              onSelected: (val) {
                                setState(() {
                                  selectedSize[product.id] = val ? size : null;
                                });
                              },
                              selectedColor: Colors.tealAccent,
                              backgroundColor: Colors.white12,
                              labelStyle: TextStyle(
                                color: isSelected ? Colors.black : Colors.white70,
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      SizedBox(height: 10),

                      // ADD / QTY
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: qty == 0
                            ? ElevatedButton(
                                onPressed: () {
                                  if (selectedSize[product.id] == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Please select a size"),
                                      ),
                                    );
                                    return;
                                  }
                                  cart.addToCart(product);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.tealAccent,
                                  foregroundColor: Colors.black,
                                  minimumSize: Size(double.infinity, 36),
                                  shape: StadiumBorder(),
                                ),
                                child: Text("Add"),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () => cart.decreaseQty(product),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white12,
                                      radius: 14,
                                      child: Icon(Icons.remove, color: Colors.tealAccent),
                                    ),
                                  ),
                                  Text(
                                    qty.toString(),
                                    style: TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  InkWell(
                                    onTap: () => cart.increaseQty(product),
                                    child: CircleAvatar(
                                      backgroundColor: Colors.white12,
                                      radius: 14,
                                      child: Icon(Icons.add, color: Colors.tealAccent),
                                    ),
                                  ),
                                ],
                              ),
                      ),

                      SizedBox(height: 8),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
