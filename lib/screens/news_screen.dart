import 'package:blott/utils/utilities.dart';
import 'package:blott/viewmodels/news_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';
import '../utils/utils.dart';
import '../viewmodels/user_info_view_model.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  User? user;
  @override
  void initState() {
    super.initState();
    getUser();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<NewsViewModel>().getNews();
    });
  }

  void getUser() async {
    user = await context.read<UserInfoViewModel>().getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NewsViewModel>(builder: (context, vm, _) {
      return AppScaffold(
        isLoading: vm.isLoading,
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
              color: AppColors.bgHeaderColor,
              height: 181,
              width: double.infinity,
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.heightSpace,
                    Text("Hey ${user?.firstName ?? "--"}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: AppFonts.raleway,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        )),
                    22.heightSpace,
                    Builder(
                      builder: (context) {
                        if (vm.isLoading) {
                          return const SizedBox.shrink();
                        }
                        if (vm.errorMessage.isNotEmpty) {
                          return Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(vm.errorMessage,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      )),
                                  24.heightSpace,
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(24),
                                      ),
                                    ),
                                    onPressed: () {
                                      vm.getNews();
                                    },
                                    child: const Text("Retry",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return Expanded(
                            child: ListView.builder(
                                itemCount: vm.news.length,
                                itemBuilder: (context, index) {
                                  return NewsWidget(
                                    news: vm.news[index],
                                  );
                                }));
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class NewsWidget extends StatelessWidget {
  final NewsModel news;
  const NewsWidget({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final isSuccessful = await Utilities.launchURL(news.url);
        if (!isSuccessful) {
          if (!context.mounted) return;
          Utilities.showErrorSnacbar(context, "Failed to open the link");
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            CachedNetworkImage(
                imageUrl: news.image,
                width: 100,
                height: 100,
                alignment: Alignment.center,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator.adaptive()),
                errorWidget: (context, url, error) => const Center(
                        child: Icon(
                      Icons.error,
                      color: Colors.redAccent,
                      size: 15,
                    ))),
            16.widthSpace,
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(news.source,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.rubik,
                            color: Colors.white.withOpacity(.70),
                            fontSize: 12,
                          )),
                      12.widthSpace,
                      Text(news.formattedDate,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white.withOpacity(.70),
                            fontSize: 12,
                          )),
                    ],
                  ),
                  8.heightSpace,
                  Text(Utilities.truncate(news.summary, 40),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        height: 1.2,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
