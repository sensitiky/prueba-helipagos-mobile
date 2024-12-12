import 'package:flutter/material.dart';
import 'package:prueba_helipagos_mobile/models/nft.dart';
import 'package:prueba_helipagos_mobile/screens/nft_detail_screen.dart';

class NftCard extends StatelessWidget {
  final Nft nft;

  const NftCard({required this.nft, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key("nft_${nft.assetPlatformId}"),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: const Icon(Icons.image, color: Colors.blue),
        title: Text(nft.name ?? 'Sin Nombre'),
        subtitle: Text('Contrato: ${nft.contractAddress ?? 'N/A'}'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NftDetailScreen(
                assetPlatformId: nft.assetPlatformId!,
                contractAddress: nft.contractAddress!,
              ),
            ),
          );
        },
      ),
    );
  }
}
