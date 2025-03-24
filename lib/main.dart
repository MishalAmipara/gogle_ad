import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  AdManagerBannerAd? _bannerAd;
  bool _isLoaded = false;
  final adUnitId = "ca-app-pub-8973398920717930/8068913895";
  final adUnitId1 = "ca-app-pub-8973398920717930/8068913895";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    MobileAds.instance.initialize().then((InitializationStatus status) {
      print("Google Mobile Ads SDK initialized: ${status.adapterStatuses}");
      loadAd();
    });
  }

  void loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    // final size = await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
    //     MediaQuery
    //         .sizeOf(context)
    //         .width
    //         .truncate());

    _bannerAd = AdManagerBannerAd(
      adUnitId: adUnitId,
      request: const AdManagerAdRequest(),
      sizes: [AdSize.banner],
      listener: AdManagerBannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        onAdClicked: (ad) {

        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          print('AdManagerBannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )
      ..load();
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(

          backgroundColor: Theme
              .of(context)
              .colorScheme
              .inversePrimary,

          title: Text(widget.title),
        ),
        body: Center(

          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _isLoaded?
                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: AdSize.banner.width.toDouble(),
                      height: AdSize.banner.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ):CircularProgressIndicator()
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed:loadAd,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
  }
