import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/nft_bloc.dart';
import '../states/nft_state.dart';

class NftListScreen extends StatelessWidget {
  const NftListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lista de NFTs')),
      body: BlocBuilder<NftBloc, NftState>(
        builder: (context, state) {
          if (state is NftLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NftLoaded) {
            final nfts = state.nfts;
            return ListView.builder(
              itemCount: nfts.length,
              itemBuilder: (context, index) {
                final nft = nfts[index];
                return ListTile(
                  title: Text(nft.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Contrato: ${nft.contractAddress}'),
                      Text('Plataforma: ${nft.assetPlatformId}'),
                    ],
                  ),
                );
              },
            );
          } else if (state is NftError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}
