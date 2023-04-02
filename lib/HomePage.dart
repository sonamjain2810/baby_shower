import 'dart:async';
import 'dart:io';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'data/Quotes.dart';
import 'data/Shayari.dart';
import 'data/Status.dart';
import 'widgets/CustomBannerWidget.dart';
import 'widgets/CustomBannerWidget2.dart';
import 'widgets/CustomFBTextWidget.dart';
import 'widgets/CustomFeatureCard.dart';
import 'widgets/ImageTextHorizontalWidget2.dart';
import 'widgets/MessageWidget1.dart';
import 'widgets/MessageWidget3.dart';
import 'widgets/QuotesDesign3.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'data/AdService.dart';
import 'data/Gifs.dart';
import 'data/Images.dart';
import 'data/Messages.dart';
import 'data/Strings.dart';
import 'widgets/AppStoreItemWidget2.dart';
import 'widgets/CustomFullCard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'utils/SizeConfig.dart';
import 'MyDrawer.dart';
import 'widgets/CustomTextOnlyWidget.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// Height = 8.96
// Width = 4.14

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static final facebookAppEvents = FacebookAppEvents();
  String interstitialTag = "";
  String _authStatus = 'Unknown';

  late BannerAd bannerAd1, bannerAd2, bannerAd3;
  bool isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => initPlugin());
    AdService.createInterstialAd();

    bannerAd1 = GetBannerAd();
    bannerAd2 = GetBannerAd();
    bannerAd3 = GetBannerAd();
  }

  BannerAd GetBannerAd() {
    return BannerAd(
        size: AdSize.mediumRectangle,
        adUnitId: Strings.iosAdmobBannerId,
        listener: BannerAdListener(onAdLoaded: (_) {
          setState(() {
            isBannerAdLoaded = true;
          });
        }, onAdFailedToLoad: (ad, error) {
          isBannerAdLoaded = true;
          ad.dispose();
        }),
        request: AdRequest())
      ..load();
  }

  @override
  void dispose() {
    super.dispose();
    bannerAd1.dispose();
    bannerAd2.dispose();
    bannerAd3.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final TrackingStatus status =
          await AppTrackingTransparency.requestTrackingAuthorization();

      switch (status) {
        case TrackingStatus.authorized:
          print("Tracking Status Authorized");
          break;
        case TrackingStatus.denied:
          print("Tracking Status Denied");
          break;
        case TrackingStatus.notDetermined:
          print("Tracking Status not Determined");
          break;
        case TrackingStatus.notSupported:
          print("Tracking Status not Supported");
          break;
        case TrackingStatus.restricted:
          print("Tracking Status Restricted");
          break;
        default:
      }
    } on PlatformException {
      setState(() => _authStatus = 'PlatformException was thrown');
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    print("UUID: $uuid");
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
          style: Theme.of(context).appBarTheme.textTheme!.headline1,
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  DesignerContainer(
                    isLeft: false,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.width(8)),
                      child: Center(
                        child: Text("Choose Wishes From Below",
                            style: Theme.of(context).textTheme.headline1),
                      ),
                    ),
                  ),

                  Divider(),

                  // Wishes Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Select Wishes Type",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        // Honey
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.height(6.0)),
                              child: Row(
                                children: [
                                  //English
                                  InkWell(
                                    child: MessageWidget3(
                                      headLine: "Wishes For All",
                                      subTitle: Messages.english_data[2],
                                      imagePath:
                                          "http://andiwiniosapps.in/baby_shower_wishes/images/66.png",
                                      color: Colors.orange,
                                    ),
                                    onTap: () {
                                      print("English Message Clicked");
                                      interstitialTag = "lang_english";
                                      facebookAppEvents.logEvent(
                                        name: "Message List",
                                        parameters: {
                                          'button_id': 'lang_english_button',
                                        },
                                      );
                                      AdService.context = context;
                                      AdService.interstitialTag =
                                          "lang_english";
                                      AdService.showInterstitialAd();
                                    },
                                  ),

                                  Column(
                                    children: [
                                      InkWell(
                                        child: MessageWidget1(
                                          headLine: "Wishes For Twins",
                                          subTitle: Messages.hindi_data[0],
                                          imagePath:
                                              "http://andiwiniosapps.in/baby_shower_wishes/images/69.png",
                                          color: Colors.brown,
                                        ),
                                        onTap: () {
                                          print("Hindi Clicked");
                                          interstitialTag = "lang_hindi";
                                          facebookAppEvents.logEvent(
                                            name: "Message List",
                                            parameters: {
                                              'button_id': 'lang_hindi_button',
                                            },
                                          );
                                          AdService.context = context;
                                          AdService.interstitialTag =
                                              "lang_hindi";
                                          AdService.showInterstitialAd();
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(8.0),
                                      ),

                                      //Spainsh
                                      InkWell(
                                        child: MessageWidget1(
                                          headLine: "Hindi Wishes",
                                          subTitle: Messages.spanish_data[1],
                                          imagePath:
                                              "http://andiwiniosapps.in/baby_shower_wishes/images/66.png",
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        onTap: () {
                                          print("For All Clicked");
                                          interstitialTag = "lang_spanish";
                                          facebookAppEvents.logEvent(
                                            name: "Message List",
                                            parameters: {
                                              'button_id':
                                                  'lang_spanish_button',
                                            },
                                          );
                                          AdService.context = context;
                                          AdService.interstitialTag =
                                              "lang_spanish";
                                          AdService.showInterstitialAd();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        // rikhil

                        // Abdul

                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  bottom: SizeConfig.height(6.0)),
                              child: Row(
                                children: [
                                  Column(
                                    children: [
                                      // German
                                      InkWell(
                                        child: MessageWidget1(
                                          headLine: "Wishes For Baby Girl",
                                          subTitle: Messages.german_data[0],
                                          imagePath:
                                              "http://andiwiniosapps.in/baby_shower_wishes/images/68.png",
                                          color: Colors.pink[300]!,
                                        ),
                                        onTap: () {
                                          print("German Clicked");
                                          interstitialTag = "lang_german";
                                          facebookAppEvents.logEvent(
                                            name: "Message List",
                                            parameters: {
                                              'button_id': 'lang_german_button',
                                            },
                                          );
                                          AdService.context = context;
                                          AdService.interstitialTag =
                                              "lang_german";
                                          AdService.showInterstitialAd();
                                        },
                                      ),
                                      SizedBox(
                                        height: SizeConfig.height(8.0),
                                      ),

                                      // French
                                      InkWell(
                                          child: MessageWidget1(
                                            headLine: "Wishes For Baby Boys",
                                            subTitle: Messages.french_data[0],
                                            imagePath:
                                                "http://andiwiniosapps.in/baby_shower_wishes/images/67.png",
                                            color: Colors.blue[300]!,
                                          ),
                                          onTap: () {
                                            print("français Clicked");
                                            interstitialTag = "lang_french";
                                            facebookAppEvents.logEvent(
                                              name: "Message List",
                                              parameters: {
                                                'button_id':
                                                    'lang_french_button',
                                              },
                                            );
                                            AdService.context = context;
                                            AdService.interstitialTag =
                                                "lang_french";
                                            AdService.showInterstitialAd();
                                          }),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      // Italy
                                      InkWell(
                                        child: MessageWidget1(
                                          headLine: "Funny Wishes",
                                          subTitle: Messages.italy_data[6],
                                          imagePath:
                                              "http://andiwiniosapps.in/baby_shower_wishes/images/66.png",
                                          color: Colors.green[400]!,
                                        ),
                                        onTap: () {
                                          print("Italian Clicked");
                                          interstitialTag = "lang_italian";
                                          facebookAppEvents.logEvent(
                                            name: "Message List",
                                            parameters: {
                                              'button_id':
                                                  'lang_italian_button',
                                            },
                                          );
                                          AdService.context = context;
                                          AdService.interstitialTag =
                                              "lang_italian";
                                          AdService.showInterstitialAd();
                                        },
                                      ),

                                      SizedBox(
                                        height: SizeConfig.height(8.0),
                                      ),

                                      //Portugal
                                      InkWell(
                                        child: MessageWidget1(
                                          headLine: "Hindi Poems",
                                          subTitle: Messages.portugal_data[3],
                                          imagePath:
                                              "http://andiwiniosapps.in/baby_shower_wishes/images/66.png",
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onTap: () {
                                          print("Portuguese Clicked");
                                          interstitialTag = "lang_portuguese";
                                          facebookAppEvents.logEvent(
                                            name: "Message List",
                                            parameters: {
                                              'button_id':
                                                  'lang_portuguese_button',
                                            },
                                          );
                                          AdService.context = context;
                                          AdService.interstitialTag =
                                              "lang_portuguese";
                                          AdService.showInterstitialAd();
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Kalam
                      ],
                    ),
                  ),

                  // Wishes end
                  Divider(),

                  // Wish Creator Start
                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Generate Baby Shower Cards",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: InkWell(
                            child: CustomBannerWidget(
                              size: MediaQuery.of(context).size,
                              imagePath: Images.images_path[1],
                              buttonText: "create Invitation",
                              topText: "Send ",
                              middleText: "Cards & Greetings",
                              bottomText: "Share it With Your Loved Ones",
                            ),
                            onTap: () {
                              print("Meme Clicked");
                              interstitialTag = "meme";
                              facebookAppEvents.logEvent(
                                name: "Meme Generator",
                                parameters: {
                                  'button_id': 'meme_button',
                                },
                              );

                              AdService.context = context;
                              AdService.interstitialTag = "meme";
                              AdService.showInterstitialAd();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Wish Creator End

                  Divider(),

                  // Quotes Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Baby Quotes",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: InkWell(
                            child: Container(
                              width: size.width - SizeConfig.width(16),
                              height: size.width / 2,
                              decoration: BoxDecoration(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? Theme.of(context).primaryColorDark
                                        : Colors.pink[300],
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(SizeConfig.height(20)),
                                  topRight:
                                      Radius.circular(SizeConfig.height(20)),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 4,
                                      color: Colors.grey),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Icon(Icons.format_quote,
                                      color: Theme.of(context)
                                          .primaryIconTheme
                                          .color),
                                  Positioned(
                                    top: 20,
                                    width: size.width - SizeConfig.width(16),
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(SizeConfig.width(8)),
                                        child: Text(
                                          Quotes.quotes_data[4],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(SizeConfig.width(8)),
                                        child: Text(
                                          "Tap Here to Continue",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  color: Colors.cyan[400]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              print("Quotes Clicked");
                              interstitialTag = "quotes";
                              facebookAppEvents.logEvent(
                                name: "Quotes List",
                                parameters: {
                                  'button_id': 'Quotes_button',
                                },
                              );
                              AdService.context = context;
                              AdService.interstitialTag = "quotes";
                              AdService.showInterstitialAd();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quotes End
                  Divider(),
                  // Game Download
                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("👋,Games For You | 👗 🆙 | 🫣 🔍 | 🧩🤔",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                AppStoreItemWidget2(
                                  appTitle: "",
                                  imageUrl:
                                      "https://is5-ssl.mzstatic.com/image/thumb/Purple112/v4/4a/8c/62/4a8c6201-b787-d4fa-e1d0-4b585454c47c/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                  appUrl:
                                      "https://apps.apple.com/us/app/puzzle-games-jigsaw-puzzles/id1660034531",
                                ),
                                AppStoreItemWidget2(
                                  appTitle: "",
                                  imageUrl:
                                      "https://is3-ssl.mzstatic.com/image/thumb/Purple112/v4/88/77/c6/8877c63f-7403-9b49-d575-578d80075271/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                  appUrl:
                                      "https://apps.apple.com/us/app/christmas-game-dressup-girl-hd/id6443515715",
                                ),
                                AppStoreItemWidget2(
                                  appTitle: "",
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple112/v4/a2/4c/bf/a24cbfec-774f-8ef4-7901-95857d34e6a1/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                  appUrl:
                                      "https://apps.apple.com/us/app/christmas-hidden-objects-brain/id1542868606",
                                ),
                                AppStoreItemWidget2(
                                  appTitle: "",
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple122/v4/ff/3b/6e/ff3b6e42-cd15-99ef-e566-18250123f049/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/460x0w.png",
                                  appUrl:
                                      "https://apps.apple.com/us/app/christmas-decoration-makeover/id1660383621",
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    //banner
                  ),

                  // Game Download
                  Divider(),

                  //Native Ad
                  DesignerContainer(
                    isLeft: false,
                    child: Container(
                      height: bannerAd3.size.height.toDouble(),
                      width: bannerAd3.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd3),
                    ),
                  ),

                  Divider(),

                  //Gifs Start
                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(" Gifs ",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[5],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[6],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[3],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Gifs.gifs_path[11],
                                      ontap: null),
                                ],
                              ),
                              onTap: () {
                                print("Gifs Clicked");
                                interstitialTag = "gif";
                                facebookAppEvents.logEvent(
                                  name: "GIF List",
                                  parameters: {
                                    'button_id': 'gif_button',
                                  },
                                );
                                AdService.context = context;
                                AdService.interstitialTag = "gif";
                                AdService.showInterstitialAd();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Gifs End

                  Divider(),

                  DesignerContainer(
                      isLeft: false,
                      child: Column(children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("✋ Need Your HELP? 😊",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(
                              "Your suggestions are very important to improve your experience in next APP Update. Let me know how our team can improve. Thanks! and click the BUTTON Below 👇🏻 to RATE this app.",
                              style: Theme.of(context).textTheme.subtitle1),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Strings.RateNReview();
                            },
                            child: const Text("⬇️ Rate & Review ⬇️"))
                      ])),

                  Divider(),
                  // Shayari start
                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("Baby Shower Invitations",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: InkWell(
                            child: Container(
                              width: size.width - SizeConfig.width(16),
                              height: size.width / 2,
                              decoration: BoxDecoration(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? Theme.of(context).primaryColorDark
                                        : Colors.pink[300],
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(SizeConfig.height(20)),
                                  topRight:
                                      Radius.circular(SizeConfig.height(20)),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 0),
                                      blurRadius: 4,
                                      color: Colors.grey),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Icon(Icons.format_quote,
                                      color: Theme.of(context)
                                          .primaryIconTheme
                                          .color),
                                  Positioned(
                                    top: 20,
                                    width: size.width - SizeConfig.width(16),
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(SizeConfig.width(8)),
                                        child: Text(
                                          Shayari.shayari_data[29],
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 0,
                                    bottom: 0,
                                    right: 0,
                                    child: Center(
                                      child: Padding(
                                        padding:
                                            EdgeInsets.all(SizeConfig.width(8)),
                                        child: Text(
                                          "Tap Here to Continue",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText1!
                                              .copyWith(
                                                  color: Colors.cyan[400]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              print("Shayari Clicked");
                              interstitialTag = "shayari";
                              facebookAppEvents.logEvent(
                                name: "Shayari List",
                                parameters: {
                                  'button_id': 'Shayari_button',
                                },
                              );
                              AdService.context = context;
                              AdService.interstitialTag = "shayari";
                              AdService.showInterstitialAd();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Shayari end

                  Divider(),
                  //Native Ad
                  DesignerContainer(
                    isLeft: true,
                    child: Container(
                      height: bannerAd2.size.height.toDouble(),
                      width: bannerAd2.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd2),
                    ),
                  ),

                  Divider(),
                  //Image Start

                  DesignerContainer(
                    isLeft: true,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text(" Wishes Images ",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Images.images_path[13],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Images.images_path[12],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Images.images_path[8],
                                      ontap: null),
                                  CustomFeatureCard(
                                      size: size,
                                      imageUrl: Images.images_path[9],
                                      ontap: null),
                                ],
                              ),
                              onTap: () {
                                print("Images Clicked");
                                interstitialTag = "image";
                                facebookAppEvents.logEvent(
                                  name: "Image List",
                                  parameters: {
                                    'button_id': 'Image_button',
                                  },
                                );
                                AdService.context = context;
                                AdService.interstitialTag = "image";
                                AdService.showInterstitialAd();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Image End

                  Divider(),

                  // Status Start

                  DesignerContainer(
                    isLeft: false,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: Text("New Born Baby Poems",
                              style: Theme.of(context).textTheme.headline1),
                        ),
                        Padding(
                          padding: EdgeInsets.all(SizeConfig.width(8)),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: InkWell(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  CustomFBTextWidget(
                                    size: size,
                                    text: Status.status_data[2],
                                    color: Colors.pink[300],
                                    url:
                                        "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                    isLeft: false,
                                  ),
                                  SizedBox(width: SizeConfig.width(8)),
                                  CustomFBTextWidget(
                                    size: size,
                                    text: Status.status_data[3],
                                    color: Colors.pink[300],
                                    url:
                                        "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                    isLeft: false,
                                  ),
                                  SizedBox(width: SizeConfig.width(8)),
                                  CustomFBTextWidget(
                                    size: size,
                                    text: Status.status_data[4],
                                    color: Colors.pink[300],
                                    url:
                                        "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                    isLeft: false,
                                  ),
                                  SizedBox(width: SizeConfig.width(8)),
                                  CustomFBTextWidget(
                                    size: size,
                                    text: Status.status_data[7],
                                    color: Colors.pink[300],
                                    url:
                                        "http://andiwiniosapps.in/baby_shower_wishes/images/9.jpeg",
                                    isLeft: false,
                                  ),
                                ],
                              ),
                              onTap: () {
                                print("Status Clicked");
                                interstitialTag = "status";
                                facebookAppEvents.logEvent(
                                  name: "Status List",
                                  parameters: {
                                    'button_id': 'Status_button',
                                  },
                                );
                                AdService.context = context;
                                AdService.interstitialTag = "status";
                                AdService.showInterstitialAd();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  //Status End

                  Divider(),
                  //Native Ad
                  DesignerContainer(
                    isLeft: false,
                    child: Container(
                      height: bannerAd1.size.height.toDouble(),
                      width: bannerAd1.size.width.toDouble(),
                      child: AdWidget(ad: bannerAd1),
                    ),
                  ),

                  Divider(),

                  Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Text("Play Game \"Sell Rakhi\"",
                        style: Theme.of(context).textTheme.headline1),
                  ),

                  InkWell(
                    child: CustomFullCard(
                      size: MediaQuery.of(context).size,
                      imageUrl: "lib/assets/rakhi_game.jpeg",
                    ),
                    onTap: () {
                      if (Platform.isAndroid) {
                        // Android-specific code
                        print("More Button Clicked");
                        launch(
                            "https://play.google.com/store/apps/developer?id=Festival+Messages+SMS");
                      } else if (Platform.isIOS) {
                        // iOS-specific code
                        print("More Button Clicked");
                        launch("https://apps.apple.com/us/app/-/id1434054710");

                        facebookAppEvents.logEvent(
                          name: "Play Rakshabandhan Game",
                          parameters: {
                            'clicked_on_play_rakshabandhan_game': 'Yes',
                          },
                        );
                      }
                    },
                  ),

                  Divider(),

                  Padding(
                    padding: EdgeInsets.all(SizeConfig.width(8)),
                    child: Text("Apps From Developer",
                        style: Theme.of(context).textTheme.headline1),
                  ),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.width(8)),
                      child: Row(
                        children: <Widget>[
                          //Column1
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple117/v4/8f/e7/b5/8fe7b5bc-03eb-808c-2b9e-fc2c12112a45/mzl.jivuavtz.png/292x0w.jpg",
                                  appTitle: "Good Morning Images & Messages",
                                  appUrl:
                                      "https://apps.apple.com/us/app/good-morning-images-messages-to-wish-greet-gm/id1232993917"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple114/v4/44/e0/fd/44e0fdb5-667b-5468-7b2f-53638cba539e/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                  appTitle: "Birthday Status Wishes Quotes",
                                  appUrl:
                                      "https://apps.apple.com/us/app/birthday-status-wishes-quotes/id1522542709"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is3-ssl.mzstatic.com/image/thumb/Purple124/v4/9c/17/e3/9c17e319-fadf-d92a-b586-bacda2d699bd/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                  appTitle: "Good Night Gif Image Quote Sm‪s",
                                  appUrl:
                                      "https://apps.apple.com/us/app/good-night-gif-image-quote-sms/id1527002426"),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),
                          //Column2
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is2-ssl.mzstatic.com/image/thumb/Purple124/v4/e9/96/64/e99664d3-1083-5fac-6a0c-61718ee209fd/AppIcon-0-1x_U007emarketing-0-0-GLES2_U002c0-512MB-sRGB-0-0-0-85-220-0-0-0-7.png/292x0w.jpg",
                                  appTitle: "Weight Loss My Diet Coach Tips",
                                  appUrl:
                                      "https://apps.apple.com/us/app/weight-loss-my-diet-coach-tips/id1448343218"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is2-ssl.mzstatic.com/image/thumb/Purple127/v4/5f/7c/45/5f7c45c7-fb75-ea39-feaa-a698b0e4b09e/pr_source.jpg/292x0w.jpg",
                                  appTitle: "English Speaking Course Grammar",
                                  appUrl:
                                      "https://apps.apple.com/us/app/english-speaking-course-learn-grammar-vocabulary/id1233093288"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple128/v4/50/ad/82/50ad82d9-0d82-5007-fcdd-cc47c439bfd0/AppIcon-0-1x_U007emarketing-0-85-220-10.png/292x0w.jpg",
                                  appTitle: "English Hindi Language Diction",
                                  appUrl:
                                      "https://apps.apple.com/us/app/english-hindi-language-diction/id1441243874"),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),
                          //Column3

                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple124/v4/89/1b/44/891b44e5-bbb3-a530-0f97-011c226d79e1/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                  appTitle: "Thank You Greetings Card Make‪r",
                                  appUrl:
                                      "https://apps.apple.com/us/app/thank-you-greetings-card-maker/id1552601152"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is3-ssl.mzstatic.com/image/thumb/Purple114/v4/b6/3d/cd/b63dcde0-b4db-d05b-7025-e879a338049a/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                  appTitle: "Sorry Forgive Card Status Gif‪s‬",
                                  appUrl:
                                      "https://apps.apple.com/us/app/sorry-forgive-card-status-gifs/id1549696526"),
                              Divider(),
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/9a/52/7a/9a527a0e-ca83-ecba-5f1b-336057d7a48b/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                  appTitle: "Anniversary Wishes Gif Image‪s‬",
                                  appUrl:
                                      "https://apps.apple.com/us/app/anniversary-wishes-gif-images/id1527002955"),
                            ],
                          ),
                          SizedBox(width: SizeConfig.width(3)),

                          //Column4
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/cd/fa/5f/cdfa5f06-68b0-c6ff-eb35-e4b5cd5ac890/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/230x0w.webp",
                                  appTitle: "Get Well Soon Gif Image eCard‪s",
                                  appUrl:
                                      "https://apps.apple.com/us/app/get-well-soon-gif-image-ecards/id1526953576"),
                              Divider(),
                              /*AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is4-ssl.mzstatic.com/image/thumb/Purple91/v4/f0/84/d7/f084d764-79a8-f6d1-3778-1cb27fabb8bd/pr_source.png/292x0w.jpg",
                                  appTitle: "Egg Recipes 100+ Recipes",
                                  appUrl:
                                      "https://apps.apple.com/us/app/egg-recipes-100-recipes-collection-for-eggetarian/id1232736881"),
                              Divider(),*/
                              AppStoreAppsItemWidget1(
                                  imageUrl:
                                      "https://is1-ssl.mzstatic.com/image/thumb/Purple114/v4/0f/d6/f4/0fd6f410-9664-94a5-123f-38d787bf28c6/AppIcon-1x_U007emarketing-0-7-0-0-85-220.png/292x0w.jpg",
                                  appTitle: "Rakshabandhan Images Greetings",
                                  appUrl:
                                      "https://apps.apple.com/us/app/rakshabandhan-images-greetings/id1523619788"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}

class DesignerContainer extends StatelessWidget {
  const DesignerContainer({
    Key? key,
    required this.child,
    required this.isLeft,
  }) : super(key: key);

  final Widget child;
  final bool isLeft;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLeft
          ? BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(SizeConfig.height(20)),
              ),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0), blurRadius: 4, color: Colors.grey),
              ],
            )
          : BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(SizeConfig.height(20)),
              ),
              boxShadow: [
                BoxShadow(
                    offset: Offset(0, 0), blurRadius: 4, color: Colors.grey),
              ],
            ),
      child: child,
    );
  }
}

class CustomHeader1 extends StatelessWidget {
  const CustomHeader1({
    Key? key,
    this.headerText,
    this.imagePath,
    this.descriptionText,
  }) : super(key: key);

  final String? headerText, imagePath, descriptionText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 3 * SizeConfig.widthMultiplier,
        bottom: 10 * SizeConfig.widthMultiplier,
        left: 10 * SizeConfig.widthMultiplier,
        right: 10 * SizeConfig.widthMultiplier,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryVariant,
        borderRadius: BorderRadius.only(
          //30
          bottomRight: Radius.circular(MediaQuery.of(context).size.width),
        ),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    headerText!,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    width: 1.93 * SizeConfig.widthMultiplier,
                  ),
                  CircleAvatar(
                    backgroundImage: NetworkImage(imagePath!),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(
            height: 2 * SizeConfig.heightMultiplier,
          ),
          Text(
            descriptionText!,
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle1!
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class AppStoreAppsItemWidget1 extends StatelessWidget {
  const AppStoreAppsItemWidget1({
    Key? key,
    this.imageUrl,
    this.appUrl,
    this.appTitle,
  }) : super(key: key);

  final String? imageUrl, appUrl, appTitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius:
                BorderRadius.all(Radius.circular(SizeConfig.width(16))),
            child: Padding(
              padding: EdgeInsets.only(right: SizeConfig.width(3)),
              child: CachedNetworkImage(
                height: SizeConfig.height(80),
                width: SizeConfig.width(80),
                imageUrl: imageUrl!,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fadeOutDuration: const Duration(seconds: 1),
                fadeInDuration: const Duration(seconds: 3),
              ),
            ),
          ),
          Text(
            appTitle!,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        launch(appUrl!);
      },
    );
  }
}
