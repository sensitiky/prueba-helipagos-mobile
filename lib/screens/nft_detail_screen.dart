import 'package:flutter/material.dart';
import 'package:prueba_helipagos_mobile/models/nft.dart';
import 'package:prueba_helipagos_mobile/services/api_service.dart';
import 'package:flutter_html/flutter_html.dart';

class NftDetailScreen extends StatefulWidget {
  final String assetPlatformId;
  final String contractAddress;

  const NftDetailScreen({
    super.key,
    required this.assetPlatformId,
    required this.contractAddress,
  });

  @override
  NftDetailScreenState createState() => NftDetailScreenState();
}

class NftDetailScreenState extends State<NftDetailScreen> {
  late Future<Nft> _nftFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nftFuture = _apiService.fetchNftDetails(
      widget.assetPlatformId,
      widget.contractAddress,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del NFT'),
        centerTitle: true,
      ),
      body: FutureBuilder<Nft>(
        future: _nftFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else if (snapshot.hasData) {
            final nft = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                children: [
                  // Imagen de encabezado
                  Stack(
                    children: [
                      if (nft.bannerImage != null)
                        Image.network(
                          nft.bannerImage!,
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      else
                        Container(
                          width: double.infinity,
                          height: 250,
                          color: Colors.grey,
                          child: const Icon(Icons.image, size: 100),
                        ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Text(
                          nft.name ?? 'Sin Nombre',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 6.0,
                                color: Colors.black54,
                                offset: Offset(2.0, 2.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // Tarjeta de descripción
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Descripción',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Html(
                                  data: nft.description ?? 'N/A',
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(16.0),
                                      color: Colors.grey,
                                    ),
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Tarjeta de detalles
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            children: [
                              ListTile(
                                leading:
                                    const Icon(Icons.account_balance_wallet),
                                title: const Text('Contrato'),
                                subtitle: Text(nft.contractAddress ?? 'N/A'),
                              ),
                              ListTile(
                                leading: const Icon(Icons.language),
                                title: const Text('Plataforma'),
                                subtitle: Text(nft.assetPlatformId ?? 'N/A'),
                              ),
                              if (nft.nativeCurrencySymbol != null)
                                ListTile(
                                  leading: const Icon(Icons.attach_money),
                                  title: const Text('Moneda Nativa'),
                                  subtitle: Text(nft.nativeCurrencySymbol!),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(
                child: Text('No se encontraron detalles del NFT'));
          }
        },
      ),
    );
  }
}
