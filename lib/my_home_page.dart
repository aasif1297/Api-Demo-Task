import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/res/endpoints.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';

import 'core/failure.dart';
import 'core/network.dart';
import 'data/model/recepies_model_response.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late Future<Either<Failure, Response>> _dataFuture;

  @override
  void initState() {
    super.initState();
    getDataFromApi();
  }

  getDataFromApi() {
    _dataFuture =
        ref.read(networkRepoProvider).getRequest(url: EndPoints.recipes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder(
            future: _dataFuture,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                final result = snapshot.data!;

                return result.fold(
                  (failure) => Center(child: Text('Error: ${failure.message}')),
                  (response) {
                    final data = RecipesResponseModel.fromJson(
                      jsonDecode(response.body),
                    );
                    return ListView(
                      children: data.recipes
                          .map((e) => ListTile(title: Text(e.name)))
                          .toList(),
                    );
                  },
                );
              }

              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              return GestureDetector(
                onTap: () => getDataFromApi(),
                child: const Text(
                  'Fetch Data',
                ),
              );
            }),
      ),
    );
  }
}
