import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:jd_shop/model/product_model.dart';
import 'package:jd_shop/model/transaction_model.dart' as tran;
import 'package:jd_shop/model/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firebaseStore = FirebaseFirestore.instance;

  Future<void> createUserFromModel({required User user}) async {
    final docUser = _firebaseStore.collection('users').doc(user.uid);
    final Map<String, dynamic> userInfo = user.toMap();
    await docUser.set(userInfo);
  }

  Future<User?> getUserFromUid({required uid}) async {
    final docUser = _firebaseStore.collection('users').doc(uid);
    final snapshot = await docUser.get();

    if (!snapshot.exists) return null;
    final userInfo = snapshot.data();
    final user = User.fromMap(userMap: userInfo!);

    return user;
  }

  Future<void> updateUserFromUid({required uid, required User user}) async {
    final docUser = _firebaseStore.collection('users').doc(uid);
    final newUserInfo = user.toMap();

    docUser.set(newUserInfo);
  }

  Future<Product?> getFutureProduct() async {
    final docProduct = _firebaseStore.collection('products').doc();
    final snapshot = await docProduct.get();

    if (!snapshot.exists) return null;
    final productInfo = snapshot.data();
    final Product product = Product.fromMap(productMap: productInfo!);

    return product;
  }

  Future<List<Product?>> getFutureListProduct() async {
    final snapshot = await _firebaseStore.collection('products').get();
    return snapshot.docs
        .map((doc) => Product.fromMap(productMap: doc.data()))
        .toList();
  }

  Stream<List<Product>> getStreamListProduct() => _firebaseStore
      .collection('products')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => Product.fromMap(productMap: doc.data()))
          .toList());

  Stream<List<tran.Transaction>> getStreamListTransaction() => _firebaseStore
      .collection('transactions')
      .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => tran.Transaction.fromMap(transactionMap: doc.data()))
          .toList());

  Future<void> addProduct({required Product product}) async {
    // final docProduct = _firebaseStore.collection('products').doc();
    // final Map<String, dynamic> productInfo = product.toMap();
    // await docProduct.set(productInfo);

    _firebaseStore.collection('products').add(product.toMap()).then(
        (documentSnapshot) => _firebaseStore
            .collection('products')
            .doc('${documentSnapshot.id}')
            .update({'uid': '${documentSnapshot.id}'}));
  }

  Future<void> updateProductFromUid(
      {required uid, required Product newProduct}) async {
    final docProduct = _firebaseStore.collection('products').doc(uid);
    // final newProductInfo = product.toMap();

    // docProduct.set(newProductInfo);

    docProduct.update({'name': '${newProduct.name}'});
    docProduct.update({'price': '${newProduct.price}'});
    docProduct.update({'quantity': '${newProduct.quantity}'});
    docProduct.update({'description': '${newProduct.description}'});
    docProduct.update({'photoURL': '${newProduct.photoURL}'});
  }

  Future<void> deleteProduct({required Product product}) async {
    final docProduct =
        _firebaseStore.collection('products').doc('${product.uid}');
    docProduct.delete();
  }

  //transaction
  Future<void> addTransaction({required tran.Transaction transaction}) async {
    // final docTransaction = _firebaseStore.collection('transactions').doc();
    // final Map<String, dynamic> transactionInfo = transaction.toMap();
    // await docTransaction.set(transactionInfo);

    _firebaseStore.collection('transactions').add(transaction.toMap()).then(
        (documentSnapshot) => _firebaseStore
            .collection('transactions')
            .doc('${documentSnapshot.id}')
            .update({'transactionID': '${documentSnapshot.id}'}));
  }
}
