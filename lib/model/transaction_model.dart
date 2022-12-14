enum TransactionType {
  buy,
  deposit,
  withdraw,
  unknown;
}

class Transaction {
  final TransactionType? type;
  final String buyerUid;
  final String? productUid;
  final String date;
  final String time;
  final double price;
  final String? transactionID;

  static TransactionType? getTransactionType(String type) {
    switch (type.toLowerCase()) {
      case 'buy':
        return TransactionType.buy;
      case 'deposit':
        return TransactionType.deposit;
      case 'withdraw':
        return TransactionType.withdraw;
      default:
        return TransactionType.unknown;
    }
  }

  Transaction(
      {required this.buyerUid,
      required this.price,
      required this.type,
      required this.date,
      required this.time,
      this.productUid,
      this.transactionID});

  Transaction.fromMap({required Map<String, dynamic> transactionMap})
      : buyerUid = transactionMap['buyerUid'],
        price = transactionMap['price'].toDouble(),
        type = getTransactionType(transactionMap['type']),
        date = transactionMap['date'],
        time = transactionMap['time'],
        productUid = transactionMap['productUid'] ?? '',
        transactionID = transactionMap['transactionID'] ?? '';

  Map<String, dynamic> toMap() => {
        'buyerUid': buyerUid,
        'price': price,
        'type': type?.name.toString(),
        'date': date,
        'time': time,
        'productUid': productUid ?? '',
        'transactionID': transactionID ?? '',
      };
}
