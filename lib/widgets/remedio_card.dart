import 'package:flutter/material.dart';
import '../models/remedio.dart';

class RemedioCard extends StatelessWidget {
  final Remedio remedio;
  final VoidCallback? onTap;

  const RemedioCard({
    Key? key,
    required this.remedio,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: remedio.cor,
          radius: 28,
          child: Icon(remedio.icone, color: Colors.black, size: 28),
        ),
        title: Text(
          remedio.nome,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(remedio.tipo),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              remedio.frequencia,
              style: TextStyle(color: Colors.green),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  remedio.duracao,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 8),
                Icon(Icons.notifications_none, size: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}