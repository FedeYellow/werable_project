import 'package:latlong2/latlong.dart';
import 'ProductModel.dart';
import 'ShopperModel.dart';

final List<Shopper> shoppers = [
  Shopper(
    name: 'General Market',
    address: 'Via Roma 12, Padova',
    phone: '+39 049 1234567',
    location: LatLng(45.4064, 11.8768),
    products: [
      Product(name: 'Pane', price: '1.50', expiry: '2025-06-01', shopperName: 'General Market', calories: 265),
      Product(name: 'Latte', price: '0.99', expiry: '2025-06-05', shopperName: 'General Market', calories: 42),
      Product(name: 'Uova', price: '2.30', expiry: '2025-06-08', shopperName: 'General Market', calories: 155),
    ],
  ),
  Shopper(
    name: 'Bio Bontà',
    address: 'Via Venezia 20, Padova',
    phone: '+39 049 2345678',
    location: LatLng(45.4090, 11.8800),
    products: [
      Product(name: 'Yogurt', price: '1.20', expiry: '2025-06-04', shopperName: 'Bio Bontà', calories: 60),
      Product(name: 'Miele', price: '4.50', expiry: '2026-01-10', shopperName: 'Bio Bontà', calories: 304),
      Product(name: 'Tè Verde', price: '2.10', expiry: '2025-07-01', shopperName: 'Bio Bontà', calories: 1),
    ],
  ),
  Shopper(
    name: 'Fresco Mercato',
    address: 'Corso Milano 33, Padova',
    phone: '+39 049 3456789',
    location: LatLng(45.4030, 11.8720),
    products: [
      Product(name: 'Pomodori', price: '2.00', expiry: '2025-06-03', shopperName: 'Fresco Mercato', calories: 18),
      Product(name: 'Insalata', price: '1.70', expiry: '2025-06-02', shopperName: 'Fresco Mercato', calories: 14),
      Product(name: 'Cetrioli', price: '1.20', expiry: '2025-06-06', shopperName: 'Fresco Mercato', calories: 12),
    ],
  ),
  Shopper(
    name: 'Alimentari Da Gianni',
    address: 'Via Trieste 5, Padova',
    phone: '+39 049 9876543',
    location: LatLng(45.4075, 11.8700),
    products: [
      Product(name: 'Formaggio', price: '3.20', expiry: '2025-06-10', shopperName: 'Alimentari Da Gianni', calories: 402),
      Product(name: 'Salame', price: '4.80', expiry: '2025-06-15', shopperName: 'Alimentari Da Gianni', calories: 450),
      Product(name: 'Prosciutto', price: '5.90', expiry: '2025-06-20', shopperName: 'Alimentari Da Gianni', calories: 350),
    ],
  ),
  Shopper(
    name: 'Spesa Facile',
    address: 'Via Belzoni 14, Padova',
    phone: '+39 049 8765432',
    location: LatLng(45.4045, 11.8785),
    products: [
      Product(name: 'Pasta', price: '1.10', expiry: '2026-01-01', shopperName: 'Spesa Facile', calories: 371),
      Product(name: 'Riso', price: '1.30', expiry: '2026-02-15', shopperName: 'Spesa Facile', calories: 365),
      Product(name: 'Olio d\'oliva', price: '3.99', expiry: '2026-12-31', shopperName: 'Spesa Facile', calories: 884),
    ],
  ),
  Shopper(
    name: 'Bottega Verde',
    address: 'Via Gattamelata 3, Padova',
    phone: '+39 049 1122334',
    location: LatLng(45.4088, 11.8744),
    products: [
      Product(name: 'Frutta secca', price: '2.50', expiry: '2025-11-20', shopperName: 'Bottega Verde', calories: 607),
      Product(name: 'Mandorle', price: '3.10', expiry: '2025-12-10', shopperName: 'Bottega Verde', calories: 579),
      Product(name: 'Noci', price: '3.40', expiry: '2025-12-15', shopperName: 'Bottega Verde', calories: 654),
    ],
  ),
];
