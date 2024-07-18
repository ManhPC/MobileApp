import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/view/provider/dataIndustries.dart';
import 'package:nvs_trading/presentation/view/provider/datasegments.dart';
import 'package:nvs_trading/presentation/view/provider/getInfoAccount.dart';
import 'package:nvs_trading/presentation/theme/themeProvider.dart';
import 'package:nvs_trading/presentation/view/authentication/authentication_bloc.dart';
import 'package:nvs_trading/presentation/view/login/login.dart';
import 'package:nvs_trading/presentation/view/login/login_bloc.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:nvs_trading/common/configs/locator.dart';

void main() async {
  await initDI();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();

  //full man hinh
  // Thiết lập chế độ toàn màn hình và cấu hình để nội dung hiển thị dưới vùng tai thỏ
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Đảm bảo nội dung hiển thị dưới vùng tai thỏ
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Màu thanh trạng thái trong suốt
    systemNavigationBarColor:
        Colors.transparent, // Màu thanh điều hướng trong suốt
    systemNavigationBarDividerColor: Colors.transparent,
    statusBarIconBrightness: Brightness
        .dark, // Đặt màu biểu tượng thanh trạng thái thành màu tối (hoặc sáng tùy thuộc vào nền)
    systemNavigationBarIconBrightness: Brightness
        .dark, // Đặt màu biểu tượng thanh điều hướng thành màu tối (hoặc sáng tùy thuộc vào nền)
  ));

  //storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );

  //change theme
  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadTheme();

  // Load locale from storage
  Locale? savedLocale = await loadLocaleFromStorage();

  // notifications
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notifications channel",
    ),
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
    ),
  ]);
  bool isAllowedToSendNotifications =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotifications) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }

  runApp(
    MultiProvider(
      providers: [
        BlocProvider<MarketInfoCubit>(
            create: (context) => dI<MarketInfoCubit>()),
        ChangeNotifierProvider(create: (context) => GetInfoAccount()),
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => DataSegmentsProvider()),
        ChangeNotifierProvider(create: (context) => DataIndustriesProvider()),
        ChangeNotifierProvider(create: (context) => ChangeAcctno()),
      ],
      child: MyApp(
        savedLocale: savedLocale,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.savedLocale});

  final Locale? savedLocale;

  @override
  State<MyApp> createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  @override
  void initState() {
    super.initState();
    // Set the locale to the saved locale
    _locale = widget.savedLocale;
  }

  setLocale(Locale locale) {
    setState(() {
      _locale = locale;
      saveLocaleToStorage(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthenticationBloc(),
      child: BlocProvider(
        create: (context) => LoginBloc(),
        child: MaterialApp(
          title: 'NVS app',
          theme: Provider.of<ThemeProvider>(context).currentTheme,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: _locale,
          home: const Scaffold(
            body: Login(),
          ),
        ),
      ),
    );
  }
}

Future<void> saveLocaleToStorage(Locale locale) async {
  // Save the locale to storage
  await HydratedBloc.storage.write('locale', locale.languageCode);
}

Future<Locale?> loadLocaleFromStorage() async {
  final String? storedLocale = HydratedBloc.storage.read('locale');

  if (storedLocale != null) {
    return Locale(storedLocale);
  } else {
    return null;
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
