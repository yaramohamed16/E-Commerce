//Nadeen Elafify

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../cubit/ShopCubit/cubit.dart';
import '../../cubit/ShopCubit/states.dart';
import '../../models/FavouritesModel/favorites_model.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ShopCubit cubit = ShopCubit.get(context);
        return ConditionalBuilder(
            condition: cubit.favoritesModel != null,
            builder: (context) => ListView.separated(
                itemBuilder: (context, index) => buildFavItem(
                    ShopCubit.get(context).favoritesModel!.data!.data![index],
                    context),
                separatorBuilder: (context, index) => myDivider(),
                itemCount:
                    ShopCubit.get(context).favoritesModel!.data!.data!.length),
            fallback: (context) =>
                const Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget buildFavItem(FavoritesData model, context) => Padding(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 120,
          child: Row(
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage('${model.product!.image}'),
                    width: 120,
                    height: 120,
                  ),
                  if (model.product!.discount != 0)
                    Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: const Text(
                        "Discount",
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    )
                ],
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.product!.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          model.product!.price.toString(),
                          style: const TextStyle(
                              fontSize: 12, color: Colors.deepOrange),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        if (model.product!.discount != 0)
                          Text(
                            model.product!.oldPrice.toString(),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        const Spacer(),
                        IconButton(
                            onPressed: () {
                              ShopCubit.get(context)
                                  .changeFavorites(model.product!.id!);
                            },
                            icon: CircleAvatar(
                              radius: 15,
                              backgroundColor: ShopCubit.get(context)
                                          .favorites[model.product!.id] ??
                                      false
                                  ? Colors.red
                                  : Colors.grey,
                              child: const Icon(
                                Icons.favorite_border,
                                size: 14,
                                color: Colors.white,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
  Widget myDivider() => Container(
        height: 2,
        color: const Color(0xffDCDCDC),
      );
}
