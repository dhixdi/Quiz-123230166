import 'package:flutter/material.dart';
import '../models/kuliner_model.dart';
import 'kuliner_detail_page.dart';

class KulinerListPage extends StatefulWidget {
  final String username;

  const KulinerListPage({super.key, required this.username});

  @override
  State<KulinerListPage> createState() => _KulinerListPageState();
}

class _KulinerListPageState extends State<KulinerListPage> {
  // List untuk melacak apakah setiap item sudah di-favorit atau belum
  // Panjang list sama dengan jumlah data kuliner, semua default false
  late List<bool> _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = List.generate(dummyFoods.length, (_) => false);
  }

  // Fungsi untuk mendapatkan warna berdasarkan rating
  Color _ratingColor(double rating) {
    if (rating >= 9.0) return Colors.green;
    if (rating >= 8.0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          'Selamat datang, ${widget.username}!',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.deepOrange,
        automaticallyImplyLeading: false, // Tidak ada tombol back ke login
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: dummyFoods.length,
        itemBuilder: (context, index) {
          final kuliner = dummyFoods[index];
          return _KulinerCard(
            kuliner: kuliner,
            isFavorited: _isFavorited[index],
            ratingColor: _ratingColor(kuliner.calories),
            onFavoriteTap: () {
              // Toggle status favorit
              setState(() {
                _isFavorited[index] = !_isFavorited[index];
              });
            },
            onCardTap: () {
              // Navigasi ke halaman detail, kirim seluruh object kuliner
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KulinerDetailPage(kuliner: kuliner),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// =====================================================
// Widget Card terpisah (StatelessWidget)
// =====================================================
class _KulinerCard extends StatelessWidget {
  final Food kuliner;
  final bool isFavorited;
  final Color ratingColor;
  final VoidCallback onFavoriteTap;
  final VoidCallback onCardTap;

  const _KulinerCard({
    required this.kuliner,
    required this.isFavorited,
    required this.ratingColor,
    required this.onFavoriteTap,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Gambar kuliner
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  kuliner.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.restaurant, color: Colors.grey),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Info kuliner
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kuliner.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      kuliner.category,
                      
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 4),
                     Text(
                      'Rp ${kuliner.price}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 4),
                    const SizedBox(height: 8),
                  ],
                ),
              ),

              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}