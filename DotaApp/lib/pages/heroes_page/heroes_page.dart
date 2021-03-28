import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../client/stratz_client_interface.dart';
import '../../cubits/heroes_cubit/heroes_cubit.dart';
import '../../cubits/heroes_cubit/heroes_cubit_state.dart';
import '../../cubits/navigation_cubit/navigation_cubit.dart';
import '../../cubits/navigation_cubit/navigation_state.dart';
import '../../infrastructure/get_it.dart';
import 'hero_card.dart';

class HeroesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          HeroesCubit(client: getIt.get<IStratzClient>())..getHeroes(),
      child: BlocBuilder<HeroesCubit, HeroesCubitState>(
        builder: (context, state) {
          if (state.isLoading) {
            return CircularProgressIndicator();
          } else {
            return ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              padding: const EdgeInsets.all(8),
              itemCount: state.heroes.length,
              itemBuilder: (context, index) {
                var hero = state.heroes[index];
                return BlocBuilder<NavigationCubit, NavigationState>(
                    builder: (context, state) => HeroCard(
                        hero,
                        () => context
                            .read<NavigationCubit>()
                            .navigateToHeroesPage(hero.id)));
              },
            );
          }
        },
      ),
    );
  }
}
