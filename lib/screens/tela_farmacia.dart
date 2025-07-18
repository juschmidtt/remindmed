import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TelaFarmacia extends StatefulWidget {
  const TelaFarmacia({super.key});

  @override
  State<TelaFarmacia> createState() => _TelaFarmaciaState();
}

class _TelaFarmaciaState extends State<TelaFarmacia> {
  String cidadeSelecionada = 'Concórdia - SC';

  final List<Map<String, dynamic>> farmacias = [
    {
      'nome': 'PanVel Concórdia',
      'endereco': 'R. Dr. Maruri, 515',
      'avaliacao': 4.5,
      'imagem': 'assets/farmacias/panvel.jpg',
      'mapsUrl': 'https://maps.google.com/?q=R.+Dr.+Maruri,+515'
    },
    {
      'nome': 'Farmácia Preço Popular',
      'endereco': 'R. Mal. Deodoro, 1685',
      'avaliacao': 4.9,
      'imagem': 'assets/farmacias/popular.jpg',
      'mapsUrl': 'https://maps.google.com/?q=R.+Mal.+Deodoro,+1685'
    },
    // outras
  ];

  Future<void> _abrirNoMapa(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Não foi possível abrir o mapa.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Precisando de mais remédios?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: cidadeSelecionada,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'Concórdia - SC',
                  child: Text('Concórdia - SC'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => cidadeSelecionada = value);
                }
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: farmacias.length,
                itemBuilder: (context, index) {
                  final farmacia = farmacias[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Image.asset(
                          farmacia['imagem'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        farmacia['nome'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(farmacia['endereco']),
                          Row(
                            children: [
                              Text(farmacia['avaliacao'].toString()),
                              const SizedBox(width: 4),
                              Row(
                                children: List.generate(5, (i) {
                                  return Icon(
                                    i < farmacia['avaliacao'].floor()
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 16,
                                    color: Colors.amber,
                                  );
                                }),
                              )
                            ],
                          )
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward, color: Colors.blue),
                        onPressed: () => _abrirNoMapa(farmacia['mapsUrl']),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}