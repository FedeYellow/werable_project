import 'package:latlong2/latlong.dart';
import 'ProductModel.dart';

class Shopper {
  final String name;
  final String address;
  final String phone;
  final LatLng location;
  final List<Product> products;

  Shopper({
    required this.name,
    required this.address,
    required this.phone,
    required this.location,
    required this.products,
  });
}
