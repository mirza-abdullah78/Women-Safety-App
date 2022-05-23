class StoreProduct {
  String? id, title, category, articleId, productPhoto;
  bool isAvailable;
  int? quantity,price;

  StoreProduct(this.title, this.category, this.articleId,
      this.productPhoto, this.quantity, this.isAvailable,this.price);

  Map<String, dynamic> toJson() => {
        '_id': id,
        'title': title,
        'category': category,
        'articleId': articleId,
        'productPhoto': productPhoto,
        'quantity': quantity,
        'isAvailable': isAvailable,
        'price':price
      };

  StoreProduct.fromJson(Map<String, dynamic> jsonData)
      : id = jsonData['_id'],
        title = jsonData['title'],
        category = jsonData['category'],
        articleId = jsonData['articleId'],
        productPhoto = jsonData['productPhoto'],
        quantity = jsonData['quantity'],
        isAvailable = jsonData['isAvailable'] ?? false,
        price = jsonData['price'];
}
