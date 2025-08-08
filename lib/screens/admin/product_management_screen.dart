import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../models/product.dart';

class ProductManagementScreen extends StatefulWidget {
  const ProductManagementScreen({super.key});

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  final _idController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _deleteIdController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _deleteIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prodProv = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المنتجات'),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'إضافة منتج جديد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'معرف المنتج (Product ID)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'اسم المنتج',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'السعر (دج)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final id = _idController.text.trim();
              final name = _nameController.text.trim();
              final price = double.tryParse(_priceController.text.trim()) ?? -1;

              if (id.isEmpty || name.isEmpty || price <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى إدخال بيانات صحيحة')),
                );
                return;
              }

              final added = prodProv.addProduct(Product(id: id, name: name, price: price));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(added ? 'تم إضافة المنتج' : 'معرف المنتج موجود بالفعل')),
              );
              if (added) {
                _idController.clear();
                _nameController.clear();
                _priceController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: const Text('إضافة منتج'),
          ),

          const Divider(height: 40, thickness: 2),

          const Text(
            'حذف منتج (أدخل معرف المنتج)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _deleteIdController,
            decoration: const InputDecoration(
              labelText: 'معرف المنتج (Product ID)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              final id = _deleteIdController.text.trim();
              if (id.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('يرجى إدخال معرف المنتج')),
                );
                return;
              }
              final deleted = prodProv.deleteProduct(id);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(deleted ? 'تم حذف المنتج' : 'لم يتم العثور على المنتج')),
              );
              if (deleted) _deleteIdController.clear();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            child: const Text('حذف منتج'),
          ),

          const Divider(height: 40, thickness: 2),

          const Text(
            'قائمة المنتجات',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 12),

          ...prodProv.products.map((product) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                title: Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text('ID: ${product.id} — السعر: ${product.price.toStringAsFixed(2)} دج'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: Text('هل تريد حذف المنتج "${product.name}"؟'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('إلغاء'),
                          ),
                          TextButton(
                            onPressed: () {
                              prodProv.deleteProduct(product.id);
                              Navigator.pop(ctx);
                            },
                            child: const Text('حذف', style: TextStyle(color: Colors.redAccent)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
