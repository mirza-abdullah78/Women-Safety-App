class Order {
  String? id, phoneNumber, deliveryAddress;
  bool? isCOD;
  Map? orderBy;
  int? total;
  List<Map>? products;

  Order(this.phoneNumber, this.deliveryAddress, this.isCOD, this.orderBy,
      this.products, this.total);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'phoneNumber': phoneNumber,
        'deliveryAddress': deliveryAddress,
        'isCOD': isCOD,
        'orderBy': orderBy,
        'products': products,
        'total': total
      };

  Order.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
        phoneNumber = jsonData['phoneNumber'],
        deliveryAddress = jsonData['deliveryAddress'],
        isCOD = jsonData['isCOD'],
        orderBy = jsonData['orderBy'],
        total = jsonData['total'],
        products = jsonData['products'];
}
