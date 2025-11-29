class Order {
  final String code;
  final double total;
  final String status;
  final String? customerName;
  final String? customerEmail;
  final String? address;

  Order({
    required this.code,
    required this.total,
    required this.status,
    this.customerName,
    this.customerEmail,
    this.address,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      code: json['code'] ?? '',
      total: (json['total'] ?? 0).toDouble(),
      status: json['status'] ?? 'pending',
      customerName: json['customer_name'],
      customerEmail: json['customer_email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'total': total,
      'status': status,
      'customer_name': customerName,
      'customer_email': customerEmail,
      'address': address,
    };
  }
}
