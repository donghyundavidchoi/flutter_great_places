import 'package:flutter/material.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:great_places/screens/add_place_screen.dart';
import 'package:great_places/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatelessWidget {
  const PlacesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndsetPlaces(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Consumer<GreatPlaces>(
                child: const Center(
                  child: Text('Got no places yet. Start adding new places.'),
                ),
                builder: (context, greatPlace, child) => greatPlace
                        .items.isEmpty
                    ? child!
                    : ListView.builder(
                        itemCount: greatPlace.items.length,
                        itemBuilder: (context, index) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlace.items[index].image),
                          ),
                          title: Text(greatPlace.items[index].title),
                          subtitle:
                              Text(greatPlace.items[index].location!.address!),
                          onTap: () {
                            Navigator.of(context).pushNamed(
                              PlaceDetailScreen.routeName,
                              arguments: greatPlace.items[index].id,
                            );
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
