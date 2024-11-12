import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prueba_helipagos_mobile/blocs/nft_bloc.dart';
import 'package:prueba_helipagos_mobile/events/nft_event.dart';
import 'package:prueba_helipagos_mobile/states/nft_state.dart';
import 'package:prueba_helipagos_mobile/models/nft.dart';
import 'package:prueba_helipagos_mobile/screens/nft_detail_screen.dart';

class NftListScreen extends StatefulWidget {
  const NftListScreen({super.key});

  @override
  State<NftListScreen> createState() => _NftListScreenState();
}

class _NftListScreenState extends State<NftListScreen> {
  final ScrollController _scrollController = ScrollController();
  late NftBloc _nftBloc;

  @override
  void initState() {
    super.initState();
    _nftBloc = BlocProvider.of<NftBloc>(context);
    _nftBloc.add(FetchNfts());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_nftBloc.isFetching &&
          !(_nftBloc.state is! NftLoading)) {
        final state = _nftBloc.state;
        if (state is NftLoaded) {
          _nftBloc.add(FetchNfts());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de NFTs'),
        centerTitle: true,
      ),
      body: BlocBuilder<NftBloc, NftState>(
        builder: (context, state) {
          if (state is NftLoading && _nftBloc.currentPage == 1) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is NftLoaded) {
            final nfts = state.nfts;
            if (nfts.isEmpty) {
              return const Center(child: Text('No hay NFTs disponibles'));
            }
            return ListView.builder(
              controller: _scrollController,
              itemCount: nfts.length,
              itemBuilder: (context, index) {
                final Nft nft = nfts[index];
                return NftCard(nft: nft);
              },
            );
          } else if (state is NftError) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          } else {
            return const Center(child: Text('No hay datos disponibles'));
          }
        },
      ),
    );
  }
}

class NftCard extends StatelessWidget {
  final Nft nft;

  const NftCard({required this.nft, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
