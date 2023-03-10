import 'package:flutter/cupertino.dart';
import 'package:project_mcc_lec/class/cart_model.dart';
import 'package:project_mcc_lec/class/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int _quantity = 1;
  int get counter => _counter;
  int get quantity => _quantity;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  List<Cart> cart = [];

  Future<List<Cart>> getData() async {
    cart = await dbHelper.getCartList();
    notifyListeners();
    return cart;
  }

  void _setPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('cart_items', _counter);
    prefs.setInt('item_quantity', _quantity);
    prefs.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefsItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _counter = prefs.getInt('cart_items') ?? 0;
    _quantity = prefs.getInt('item_quantity') ?? 1;
    _totalPrice = prefs.getDouble('total_price') ?? 0;
  }

  void addCounter() {
    _counter++;
    _setPrefsItems();
    notifyListeners();
  }

  void removeCounter() {
    _counter--;
    _setPrefsItems();
    notifyListeners();
  }

  int getCounter(int userId) {

    int count = 0;
    for(int i = 0; i<cart.length; i++){
      if(cart[i].userId == userId){
        count++;
      }
    }
    // _getPrefsItems();
    // return _counter;
    return count;
    // return 0;
  }

  int getUniqueCartId(){
    if(cart.isEmpty) return 0;
    int newId = cart[cart.length-1].id! + 1;
    return newId;
  }

  int getTotalItem() {
    return cart.length;
    // return 0;
  }

  void addQuantity(int bookId, int userId) {
    final index = cart.indexWhere((element) => element.bookId == bookId && element.userId == userId);
    // print(index);
    // print(cart[index].quantity!.value);
    cart[index].quantity!.value = cart[index].quantity!.value + 1;
    _setPrefsItems();
    notifyListeners();
    // print(cart[index].quantity!.value);
  }

  void deleteQuantity(int bookId, int userId) {
    final index = cart.indexWhere((element) => element.bookId == bookId && element.userId == userId);
    final currentQuantity = cart[index].quantity!.value;
    if (currentQuantity <= 1) {
      currentQuantity == 1;
    } else {
      cart[index].quantity!.value = currentQuantity - 1;
    }
    _setPrefsItems();
    notifyListeners();
  }

  void removeItem(int bookId, int userId) {
    final index = cart.indexWhere((element) => element.bookId == bookId && element.userId == userId);
    cart.removeAt(index);
    _setPrefsItems();
    notifyListeners();
  }

  void clearCart(int userId){
    dbHelper.deleteAfterPayment(userId);
    cart.removeWhere((element) => element.userId == userId);
    // cart.clear();
    _counter = 0;
    // _counter -= 
    _setPrefsItems();
    notifyListeners();
  }

  int getQuantity(int quantity) {
    _getPrefsItems();
    return _quantity;
  }

  void addTotalPrice(double productPrice) {
    _totalPrice = _totalPrice + productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice = _totalPrice - productPrice;
    _setPrefsItems();
    notifyListeners();
  }

  double getTotalPrice() {
    _getPrefsItems();
    return _totalPrice;
  }
}