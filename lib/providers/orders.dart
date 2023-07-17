import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.products,
    required this.id,
    required this.amount,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  final String authToken;
  final String userId;
  Orders(this.authToken, this.userId, this._orders);

  Future<void> fetchAndSetOrders() async {
    final url =
        'https://shopapp-8c593-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrder = [];
    try {
      final extractedItems = json.decode(response.body) as Map<String, dynamic>;
      extractedItems.forEach((orderId, orderData) {
        loadedOrder.add(OrderItem(
            products: ((orderData['product'] ?? []) as List<dynamic>)
                .map(
                  (items) => CartItem(
                      id: items['id'],
                      title: items['title'],
                      quantity: items['quantity'],
                      price: items['price']),
                )
                .toList(),
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = loadedOrder.reversed.toList();
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shopapp-8c593-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    final response = await http.post(Uri.parse(url),
        body: json.encode({
          'amount': total,
          'dateTime': timestamp.toIso8601String(),
          'product': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        }));

    if (total != 0) {
      _orders.insert(
        0,
        OrderItem(
          products: cartProducts,
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: timestamp,
        ),
      );
    }
    notifyListeners();
  }
}
