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
      'nome': 'Líderfarma',
      'endereco': 'R. Mal Deodoro, 949',
      'avaliacao': 4.9,
      'imagem': 'assets/farmacias/liderfarma.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/9isanmUfNEqen8Qs5'
    },
    {
      'nome': 'PanVel',
      'endereco': 'R. Doutor Maruri, 515',
      'avaliacao': 4.6,
      'imagem': 'assets/farmacias/panvel.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/VZYbHbD13vAb2nvD8'
    },
    {
      'nome': 'Preço Popular',
      'endereco': 'R. Mal Deodoro, 826',
      'avaliacao': 4.9,
      'imagem': 'assets/farmacias/precopopular.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/UpAMRGiRZobGzKwj7'
    },
    {
      'nome': 'FarmaTotal',
      'endereco': 'R. Doutor Maruri, 1765',
      'avaliacao': 4.9,
      'imagem': 'assets/farmacias/farmatotal.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/VU6BoBnJPSfUahm59'
    },
    {
      'nome': 'São João',
      'endereco': 'R. Mal Deodoro, 952',
      'avaliacao': 4.1,
      'imagem': 'assets/farmacias/saojoao.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/VZYbHbD13vAb2nvD8'
    },
    {
      'nome': 'OesteFarma',
      'endereco': 'Anexo ao Via Passarela',
      'avaliacao': 4.9,
      'imagem': 'assets/farmacias/oestefarma.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/JEZ5mnPAYhveKmzC6'
    },
    {
      'nome': 'Preço Popular',
      'endereco': 'R. Anita Garibaldi, 16',
      'avaliacao': 4.8,
      'imagem': 'assets/farmacias/precopopular.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/7Rc4p48muyKPPiW96'
    },
    {
      'nome': 'Farmácia do Trabalhador FCT',
      'endereco': 'R. do Comércio',
      'avaliacao': 4.2,
      'imagem': 'assets/farmacias/fct.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/y9NbWz11ohLcPf3A7'
    },
    {
      'nome': 'FarmaSesi',
      'endereco': 'R. Mal Deodoro, 969',
      'avaliacao': 4.1,
      'imagem': 'assets/farmacias/farmasesi.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/2n7g8z1friachq9w7'
    },
    {
      'nome': 'Farmácia Brasil',
      'endereco': 'R. Mal Deodoro, 1000',
      'avaliacao': 4.6,
      'imagem': 'assets/farmacias/liderfarma.jpeg',
      'mapsUrl': ''
    },
    {
      'nome': 'farmaSesi Comércio',
      'endereco': 'R. do Comércio, 336',
      'avaliacao': 3.8,
      'imagem': 'assets/farmacias/farmasesi.jpeg',
      'mapsUrl': 'https://maps.app.goo.gl/o1Va9MhBVwNWPDwC7'
    },
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
      backgroundColor: Colors.white, // fundo branco
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: cidadeSelecionada,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
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
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
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