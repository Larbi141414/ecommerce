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
          const Text('إضافة منتج جديد', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _idController, decoration: const InputDecoration(labelText: 'Product ID')),
          const SizedBox(height: 8),
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'اسم المنتج')),
          const SizedBox(height: 8),
          TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'السعر'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final id = _idController.text.trim();
              final name = _nameController.text.trim();
              final price = double.tryParse(_priceController.text.trim()) ?? -1;
              if (id.isEmpty || name.isEmpty || price <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ادخل بيانات صحيحة')));
                return;
              }
              final ok = prodProv.addProduct(Product(id: id, name: name, price: price));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'تم إضافة المنتج' : 'معرف المنتج موجود بالفعل')));
              if (ok) {
                _idController.clear();
                _nameController.clear();
                _priceController.clear();
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('إضافة منتج'),
          ),
          const Divider(height: 30),
          const Text('حذف منتج (أدخل ID)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          TextField(controller: _deleteIdController, decoration: const InputDecoration(labelText: 'Product ID')),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () {
              final id = _deleteIdController.text.trim();
              if (id.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ادخل ID صحيح')));
                return;
              }
              final ok = prodProv.deleteProduct(id);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'تم حذف المنتج' : 'لم يتم العثور على المنتج')));
              if (ok) _deleteIdController.clear();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('حذف منتج'),
          ),
          const Divider(height: 30),
          const Text('قائمة المنتجات', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...prodProv.products.map((p) {
            return Card(
              child: ListTile(
                title: Text(p.name),
                subtitle: Text('ID: ${p.id} — السعر: ${p.price.toStringAsFixed(2)} دج'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('تأكيد الحذف'),
                        content: Text('هل تريد حذف المنتج ${p.name}?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
                          TextButton(
                            onPressed: () {
                              prodProv.deleteProduct(p.id);
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
