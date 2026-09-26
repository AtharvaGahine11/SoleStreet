class Coupon {
  final String code;
  final String description;
  final double discountPercent; // e.g. 15 for 15%
  final double maxDiscountAmount;
  final double minOrderValue;
  final DateTime expiryDate;

  const Coupon({
    required this.code,
    required this.description,
    required this.discountPercent,
    required this.maxDiscountAmount,
    this.minOrderValue = 0,
    required this.expiryDate,
  });

  double calculateDiscount(double subtotal) {
    if (subtotal < minOrderValue) return 0;
    double rawDiscount = subtotal * (discountPercent / 100);
    if (rawDiscount > maxDiscountAmount) {
      return maxDiscountAmount;
    }
    return rawDiscount.roundToDouble();
  }
}
