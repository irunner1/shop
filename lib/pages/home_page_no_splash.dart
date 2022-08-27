import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:app/pages/item_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../helpers/colors.dart';
import '../helpers/item.dart';
import '../helpers/data.dart';
import 'dart:convert';


class MyHome extends StatefulWidget {
  const MyHome({Key? key}) : super(key: key);

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  List<HomeStore> hotSales = [];
  List<BestSeller> bestSales = [];

  Future fetchHotSales() async {
    var response = await http.get(Uri.https('run.mocky.io', '/v3/654bd15e-b121-49ba-a588-960956b15175'));
    List<HomeStore> homeStore = [];
    homeStore.clear();
    if (response.statusCode == 200) {
      var notes = json.decode(response.body);
      for (var noteJson in notes['home_store']) {
        homeStore.add(HomeStore.fromJson(noteJson));
      }
    }
    return homeStore;
  }
  
  Future fetchBestSales() async {
    var response = await http.get(Uri.https('run.mocky.io', '/v3/654bd15e-b121-49ba-a588-960956b15175'));
    List<BestSeller> bestSale = [];
    bestSale.clear();
    if (response.statusCode == 200) {
      var notes = json.decode(response.body);
      for (var dataJson in notes['best_seller']) {
        bestSale.add(BestSeller.fromJson(dataJson));
      }
    }
    return bestSale;
  }
  late FocusNode node;
  
  @override
  void initState() {
    super.initState();
    fetchBestSales().then((value) {
      bestSales.clear();
      bestSales.addAll(value);
    });
    fetchHotSales().then((value) {
      hotSales.clear();
      hotSales.addAll(value);
    });
    node = FocusNode();
  }

  @override
  void dispose() {
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget buildImage(String urlImage, int index) => ClipRRect(
      borderRadius: BorderRadius.circular(15),
      // child: Image(image: NetworkImage(urlImage),fit: BoxFit.cover)
      child: Stack(
        alignment: Alignment.topLeft,
        
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: Image.network(
              urlImage,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          (hotSales[index].isNew == true)
            ? Container(
              padding: const EdgeInsets.all(20),
              child: const CircleAvatar(
                backgroundColor: AppColors.contrastColor,
                child: Text(
                  'New',
                  style: TextStyle(
                    color: AppColors.fillColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12
                  ),
                ),
              ),
            )
            : const Icon(
                Icons.favorite_outline,
                color: Colors.transparent,
              ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 70),
            alignment: Alignment.centerLeft,
            child: Column(
              children: [
                Text(
                  hotSales[index].title,
                  style: const TextStyle(
                    color: AppColors.fillColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 25
                  ),
                ),
                Text(
                  hotSales[index].subtitle,
                  style: const TextStyle(
                    color: AppColors.fillColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11
                  ),
                ),
                const Spacer(),
                TextButton(
                  style: TextButton.styleFrom(                    
                    backgroundColor: AppColors.fillColor,
                    padding: const EdgeInsets.only(left: 40, right: 40),
                  ),
                  onPressed: null,
                  child: const Text(
                    'Buy now!',
                    style: TextStyle(
                      color: AppColors.secondaryColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                const Spacer(),
              ],
            )
          ),
        ],
      ),
    );

    return GestureDetector(
      onTap: (() {
        node.unfocus();
      }),
      child: Scaffold(
        body: ListView(
          children: [
            Row(
              children: [
                const Spacer(flex: 2),
                const Icon(
                  Icons.location_on_outlined,
                  color: AppColors.contrastColor,
                  size: 20,
                ),
                const Text(
                  'Zihuatanejo, Gro',
                  style: TextStyle(
                    fontSize: 15,
                    color: AppColors.secondaryColor
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                const Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: AppColors.subColor
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.filter_alt_outlined, color: AppColors.secondaryColor),
                    iconSize: 25,
                    splashRadius: 25,
                    onPressed: (){
                      log('filter');
                    },
                )
              ],
            ),
            Row(
              children: const [
                Spacer(),
                Text(
                  'Select Category',
                  style: TextStyle(
                    fontSize: 25,
                    color:AppColors.secondaryColor,
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                Spacer(
                  flex: 6,
                ),
                Text(
                  'view all',
                  style: TextStyle(fontSize: 15, color: AppColors.contrastColor),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                Spacer(),
              ],
            ),
            SizedBox(
              height: 150,
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20, left: 0, right: 8, bottom: 0),
                itemCount: category.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      width: 75,
                      margin: const EdgeInsets.only(left: 20),
                      child: Column(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Container(
                              width: 71,
                              height: 71,
                              color: AppColors.contrastColor,
                              child: Icon(
                                category[index].icon,
                                color: AppColors.fillColor
                              ),
                            ),
                          ),
                          const Padding(padding: EdgeInsets.only(top: 10)),
                          Text(
                            category[index].name,
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                    },
                  );
                }
              ),
            ),
            Row(
              children: [
                const Spacer(flex: 3),
                SizedBox(
                  width: 300,
                  height: 45,
                  child: TextField(
                    focusNode: node,
                    decoration: InputDecoration(
                      labelText: "Search",
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Mark Pro',
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.contrastColor
                      ),
                      filled: true,
                      fillColor: AppColors.fillColor,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: const BorderSide(color: AppColors.contrastColor, width: 1.0),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                        borderSide: BorderSide(color: AppColors.fillColor, width: 1.0),
                      ),
                      
                    ),
                  ),
                ),
                const Spacer(),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.contrastColor,
                  child: IconButton(
                    icon: const Icon(Icons.qr_code, color: AppColors.fillColor),
                      iconSize: 25,
                      splashRadius: 25,
                      onPressed: (){
                        log('qr');
                      },
                  ),
                ),
                const Spacer(flex: 3),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              children: const [
                Spacer(),
                Text(
                  'Hot Sales',
                  style: TextStyle(
                    fontSize: 25,
                    color:AppColors.secondaryColor,
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                Spacer(
                  flex: 6,
                ),
                Text(
                  'see more',
                  style: TextStyle(fontSize: 15, color: AppColors.contrastColor),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                Spacer(),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder(
              future: fetchHotSales(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (hotSales.isEmpty) {
                  hotSales.addAll(snapshot.data);
                }
                if (snapshot.hasData) {
                  return SizedBox(
                    height: 210,
                    child: Stack(
                      children: <Widget>[
                        CarouselSlider.builder(
                          itemCount: hotSales.length,
                          itemBuilder: ((context, index, realIndex) {
                            final urlImage = hotSales[index].picture;
                            return buildImage(urlImage, index);
                          }),
                          options: CarouselOptions(
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            viewportFraction: 0.9,
                            height: 200,
                          )
                        ),
                      ]
                    )
                  );
                }
                return const Center(child: Text("no info"));
              },
            ),
            Row(
              children: const [
                Spacer(),
                Text(
                  'Best seller',
                  style: TextStyle(
                    fontSize: 25,
                    color:AppColors.secondaryColor,
                    fontWeight: FontWeight.bold
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                Spacer(
                  flex: 6,
                ),
                Text(
                  'see more',
                  style: TextStyle(
                    fontSize: 15,
                    fontFamily: 'Mark Pro',
                    color: AppColors.contrastColor
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                ),
                Spacer(),
              ],
            ),
            FutureBuilder(
              future: fetchBestSales(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (bestSales.isEmpty) {
                  bestSales.addAll(snapshot.data);
                }
                if (snapshot.hasData) {
                  return GestureDetector(
                    child: SizedBox(
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5.0,
                          mainAxisSpacing: 5.0,
                        ),
                        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 8),
                        itemCount: bestSales.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ClipRRect(
                            child: Container(
                              width: 170,
                              margin: const EdgeInsets.only(left: 20, right: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: AppColors.fillColor,
                              ),
                              child: Column(
                                children: <Widget>[
                                  Stack(
                                    alignment: Alignment.topRight,
                                    children: <Widget>[
                                      Image(
                                          fit: BoxFit.fitHeight,
                                          height: 150,
                                          width: 150,
                                          image: NetworkImage(bestSales[index].picture),
                                        ),
                                      CachedNetworkImage(
                                        imageUrl: bestSales[index].picture,
                                         height: 150,
                                          width: 150,
                                          fit: BoxFit.fitHeight,
                                        // placeholder: (context, url) => CircularProgressIndicator(),
                                        // errorWidget: (context, url, error) => Icon(Icons.error),
                                        // imageBuilder: (context, imageProvider) => Container(
                                        //   decoration: BoxDecoration(
                                        //     image: DecorationImage(
                                        //         image: imageProvider,
                                        //         fit: BoxFit.cover,
                                        //         colorFilter:
                                        //             ColorFilter.mode(Colors.red, BlendMode.colorBurn)),
                                        //   ),
                                        // ),
                                        // Image(
                                        //   fit: BoxFit.fitHeight,
                                        //   height: 150,
                                        //   width: 150,
                                        //   image: NetworkImage(bestSales[index].picture),
                                        // ),
                                        // Image(
                                        //   fit: BoxFit.fitHeight,
                                        //   height: 150,
                                        //   width: 150,
                                        //   image: NetworkImage(bestSales[index].picture),
                                        // ),
                                      ),
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: AppColors.fillColor,
                                        child: IconButton(
                                          iconSize: 15,
                                          splashRadius: 15,
                                          icon: (bestSales[index].isFavorites == true)
                                          ? const Icon(
                                              Icons.favorite_outlined,
                                              color: AppColors.contrastColor,
                                            )
                                          : const Icon(
                                              Icons.favorite_outline,
                                              color: AppColors.contrastColor,
                                            ),
                                          onPressed: () {
                                            if (bestSales[index].isFavorites == false) {
                                              setState(() {
                                                bestSales[index].isFavorites = true;
                                              });
                                            } else {
                                              setState(() {
                                                bestSales[index].isFavorites = false;
                                              });
                                            }
                                            log(bestSales[index].isFavorites.toString());
                                          },
                                        ),
                                      ),
                                    ]
                                  ),
                                  Row(
                                    children: [
                                      const Spacer(
                                        flex: 2,
                                      ),
                                      Text('\$${bestSales[index].discountPrice}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: AppColors.secondaryColor
                                        ),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                        textAlign: TextAlign.left,
                                      ),
                                      const Spacer(),
                                      Text('\$${bestSales[index].priceWithoutDiscount}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: AppColors.priceColor,
                                          decoration: TextDecoration.lineThrough
                                        ),
                                        overflow: TextOverflow.fade,
                                        maxLines: 1,
                                        softWrap: false,
                                        textAlign: TextAlign.left,
                                      ),
                                      const Spacer(
                                        flex: 4,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    bestSales[index].title,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: AppColors.secondaryColor
                                    ),
                                    overflow: TextOverflow.fade,
                                    maxLines: 1,
                                    softWrap: false,
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      )
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyItemPage()),
                      );
                    },
                  );
                }
                return const Center(child: Text("no info"));
              },
            )
          ]
        ),
      ),
    );
  }
}