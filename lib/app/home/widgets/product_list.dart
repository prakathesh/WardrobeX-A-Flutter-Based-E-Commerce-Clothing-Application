import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/dummy_products.dart';
import '../../../providers/cart_provider.dart';
import '../../../models/product.dart';

class ProductList extends StatelessWidget {
  final List<Product> products;
  final String? category;

  const ProductList({
    super.key,
    required this.products,
    this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final product = products[index];

        return _ProductCard(product: product);
      },
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;

  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  String? selectedSize;

  List<String> getSizesForCategory(String category) {
    if (category.toLowerCase() == 'shoes') {
      return ['5', '6', '7', '8', '9', '10', '11', '12'];
    }
    if (category.toLowerCase() == 'kids') {
      return ['S', 'M', 'L'];
    }
    if (category.toLowerCase() == 'accessories') {
      return []; // no size
    }
    return ['XS', 'S', 'M', 'L', 'XL']; // men/women
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final product = widget.product;

    final sizes = getSizesForCategory(product.category);

    // key = productId_size or productId_nosize
    final key = "${product.id}_${selectedSize ?? 'nosize'}";
    final qty = cart.items[key]?.quantity ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- IMAGE ----------
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                product.imageUrl,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // ---------- NAME ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // ---------- CATEGORY ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              product.category,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ),

          // ---------- SIZE SELECTOR ----------
          if (sizes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Wrap(
                spacing: 6,
                children: sizes.map((size) {
                  final isSelected = selectedSize == size;
                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedSize = size);
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected
                              ? Colors.tealAccent
                              : Colors.white24,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: isSelected
                            ? Colors.tealAccent.withOpacity(0.2)
                            : Colors.transparent,
                      ),
                      child: Text(
                        size,
                        style: TextStyle(
                          color: isSelected
                              ? Colors.tealAccent
                              : Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

          // ---------- PRICE + CART BUTTON ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: const TextStyle(
                    color: Colors.tealAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                qty == 0
                    ? ElevatedButton(
                        onPressed: () {
                          if (sizes.isNotEmpty && selectedSize == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Please select a size first"),
                              ),
                            );
                            return;
                          }

                          cart.addToCart(
                            product,
                            size: sizes.isEmpty ? null : selectedSize,
                          );
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent,
                          foregroundColor: Colors.black,
                          shape: StadiumBorder(),
                        ),
                        child: Text("Add"),
                      )
                    : Row(
                        children: [
                          // ---------------- decrease ----------------
                          GestureDetector(
                            onTap: () {
                              cart.decreaseQty(key);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.remove,
                                  size: 18, color: Colors.tealAccent),
                            ),
                          ),
                          SizedBox(width: 8),

                          // qty number
                          Text(
                            qty.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 8),

                          // ---------------- increase ----------------
                          GestureDetector(
                            onTap: () {
                              cart.increaseQty(key);
                              setState(() {});
                            },
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.white10,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.add,
                                  size: 18, color: Colors.tealAccent),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
