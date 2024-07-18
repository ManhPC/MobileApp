// ignore_for_file: non_constant_identifier_names

import 'dart:math';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:nvs_trading/common/utils/extensions/string_extensions.dart';
import 'package:nvs_trading/common/utils/utils.dart';
import 'package:nvs_trading/data/model/get_info_order.dart';
import 'package:nvs_trading/data/services/order/PROCOMconditional.dart';
import 'package:nvs_trading/data/services/order/SLTPconditional.dart';
import 'package:nvs_trading/data/services/order/TSconditional.dart';
import 'package:nvs_trading/data/services/order/checkFivePercent.dart';
import 'package:nvs_trading/data/services/getAllCode.dart';
import 'package:nvs_trading/data/services/getBusDate.dart';
import 'package:nvs_trading/data/services/getInfoOrder.dart';
import 'package:nvs_trading/data/services/order/orderExcute.dart';
import 'package:nvs_trading/data/services/order/stopOrderConditional.dart';
import 'package:nvs_trading/data/services/order/tcoConditional.dart';
import 'package:nvs_trading/presentation/theme/color.dart';
import 'package:nvs_trading/presentation/view/order/trading_view.dart';
import 'package:nvs_trading/presentation/view/provider/changeAcctno.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/chooseAcctno.dart';
import 'package:nvs_trading/presentation/widget/highlight.dart';
import 'package:nvs_trading/presentation/widget/msgNotification.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/widget/style/style_body.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddCommand extends StatefulWidget {
  AddCommand({
    super.key,
    this.symbol,
    this.khoiluong,
  });

  String? symbol;
  String? giadat;
  String? khoiluong;

  @override
  State<AddCommand> createState() => _AddCommandState();
}

class _AddCommandState extends State<AddCommand> {
  final TextEditingController _selectedCommand = TextEditingController();
  String typeCommand = "";

  final TextEditingController khoiluong = TextEditingController();
  var a;
  bool checkKhoiluongEdited = false;

  String hintTextCommand = "";

  final TextEditingController giadat = TextEditingController();
  //bool checkGiaDat = false;
  String beforeGiaDat = "";
  String validateGiaDat = "Giá đặt phải nằm trong khoảng trần - sàn";
  bool disabledGiaDat = false;
  bool firstTimeGia = true;

  double ceil = 0;
  double floor = 0;

  String busDate = "";

  FocusNode _focusNode = FocusNode();

  int indexAcctno = 0;

  bool checkAcctno = false;
  int typeGiaDat = 0;

  List<dynamic> commandData = [];
  List<InfoOrder> responseInfoOrder = [];
  bool isClick = false;

  TextEditingController symbol = TextEditingController();
  List<String> listPrice = [];

  //symbol khoi tao
  String currentSymbol = "ACB";
  int tonggiatrilenh = 0;

  //acctno
  String acctno = "";
  //notification
  late FToast fToast;
  //list symbol search
  List<SearchFieldListItem> filteredSuggestions = [];

  //checkbox, pass, checkobscure save in confirm
  TextEditingController passTransaction = TextEditingController();
  bool checkPassTransaction = false;
  String passTransactionValidate = "Vui lòng nhập mật khẩu giao dịch!";
  bool checkObscure = false;
  bool savePassTransaction =
      HydratedBloc.storage.read('savePassTransaction') ?? false;

  //lenh dung
  int highOrlow = 0;
  TextEditingController giakichhoat = TextEditingController();
  var giaKH;
  bool checkGiaKhEdited = false;

  //date
  TextEditingController startDate = TextEditingController();
  TextEditingController endDate = TextEditingController();

  //Gia cat lo, gia chot lai, bien do cat lo
  TextEditingController giaCatLo = TextEditingController();
  bool checkGiaCatLoEdited = false;
  var validateGiaCatLo;
  TextEditingController giaChotLai = TextEditingController();
  bool checkGiaChotLaiEdited = false;
  var validateGiaChotLai;
  TextEditingController biendoCatLo = TextEditingController();

  //bien truot, bien do gia
  TextEditingController bienTruot = TextEditingController();
  bool checkBienTruotEdited = false;
  var validateBienTruot;

  TextEditingController bienDoGia = TextEditingController();

  @override
  void initState() {
    super.initState();

    typeCommand = "NORMAL";
    if (widget.symbol == null) {
      symbol.text = "ACB";
    } else {
      symbol.text = widget.symbol!;
      currentSymbol = widget.symbol!;
    }
    if (widget.khoiluong != null) {
      khoiluong.text = Utils().formatNumber(int.parse(widget.khoiluong!));
    }
    fToast = FToast();
    fToast.init(context);
    _focusNode = FocusNode();
    giadat.addListener(checkGiaDat);
    khoiluong.addListener(checkKL);
    giakichhoat.addListener(checkGiaKH);
    giaCatLo.addListener(checkGiaCatLo);
    giaChotLai.addListener(checkGiaChotLai);
    bienTruot.addListener(checkBienTruot);
    fetchBusDate();
    fetchCommand();
    if (savePassTransaction) {
      passTransaction.text = HydratedBloc.storage.read('passTransaction');
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final changeAcctno = Provider.of<ChangeAcctno>(context, listen: false);
      acctno = changeAcctno.acctno;
      fetchInfoOrder(symbol.text, 0.0);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final changeAcctno = Provider.of<ChangeAcctno>(context);
    if (acctno != changeAcctno.acctno) {
      acctno = changeAcctno.acctno;
      double a = giadat.text.isNotEmpty ? double.parse(giadat.text) : 0;
      print(a);
      if (a != 0.0) {
        fetchInfoOrder(symbol.text, a * 1000);
      }
    }
  }

  void checkGiaCatLo() {
    setState(() {
      errorGiaCatLo;
    });
  }

  void checkGiaChotLai() {
    setState(() {
      errorGiaChotLai;
    });
  }

  void checkGiaKH() {
    setState(() {
      errorGiaKH;
    });
  }

  void checkKL() {
    final text = khoiluong.text.replaceAll(RegExp(r','), '');
    if (text.isNotEmpty) {
      final value = int.parse(text);
      final formattedValue = Utils().formatNumber(value);
      if (khoiluong.text != formattedValue) {
        khoiluong.value = khoiluong.value.copyWith(
          text: formattedValue,
          selection: TextSelection.collapsed(offset: formattedValue.length),
        );
      }
    }
    setState(() {
      errorkhoiluong;
    });
  }

  void checkGiaDat() {
    setState(() {
      errorGiaDat;
    });
  }

  void checkBienTruot() {
    setState(() {
      errorBienTrout;
    });
  }

  @override
  void dispose() {
    super.dispose();
    khoiluong.removeListener(checkKL);
    giadat.removeListener(checkGiaDat);
    giakichhoat.removeListener(checkGiaKH);
    giaCatLo.removeListener(checkGiaCatLo);
    giaChotLai.removeListener(checkGiaChotLai);
    bienTruot.removeListener(checkBienTruot);
    _focusNode.dispose();
  }

  void fetchBusDate() async {
    try {
      final response = await GetBusDate(HydratedBloc.storage.read('token'));
      if (response.statusCode == 200) {
        setState(() {
          busDate = response.data['dateserver'];
          startDate.text =
              DateFormat('dd/MM/yyyy').format(DateTime.parse(busDate));
          endDate.text =
              DateFormat('dd/MM/yyyy').format(DateTime.parse(busDate));
        });

        print(busDate);
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchCommand() async {
    try {
      final response = await GetAllCode(
          "SOD", "OSMARTTYPE", HydratedBloc.storage.read('token'));
      setState(() {
        commandData = response;
      });
    } catch (e) {
      print(e);
    }
  }

  void fetchInfoOrder(String symbol, dynamic price) async {
    try {
      final response = await GetInfoOrder(acctno, symbol, price);
      setState(() {
        responseInfoOrder = response;
      });
    } catch (e) {
      print(e);
    }
  }

  bool isFirstTimeSetLanguage = true;
  @override
  Widget build(BuildContext context) {
    var appLocal = AppLocalizations.of(context)!;
    var language = AppLocalizations.of(context)!.localeName;
    if (isFirstTimeSetLanguage) {
      if (language == 'vi') {
        _selectedCommand.text = "Lệnh thông thường";
      } else {
        _selectedCommand.text = "NORMAL";
      }
      isFirstTimeSetLanguage = false;
    }
    return (responseInfoOrder.isEmpty)
        ? const Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: customTextStyleAppbar(
                text: appLocal.addCommandForm('order'),
              ),
              automaticallyImplyLeading: false,
              actions: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const ChooseAcctno(),
                  ),
                ),
              ],
            ),
            body: BlocBuilder<MarketInfoCubit, MarketInfoState>(
              builder: (context, state) {
                final theme = Theme.of(context);

                var marketInfo = state.marketInfo[currentSymbol];

                List<String> listSymbols = [];
                List<String> listNameBank = [];
                List<String> listMarketNames = [];
                for (var entry in state.marketInfo.entries) {
                  String symbol = entry.value.symbol ?? "";
                  listSymbols.add(symbol);
                  String nameBank = entry.value.symbolName ?? "";
                  listNameBank.add(nameBank);
                  String market = entry.value.marketName ?? "";
                  listMarketNames.add(market);
                }

                if (filteredSuggestions.isEmpty) {
                  filteredSuggestions = List.generate(
                    listSymbols.length,
                    (index) {
                      String symbol = listSymbols[index];
                      String market = listMarketNames[index];
                      String nameBank = listNameBank[index];
                      return SearchFieldListItem(
                        symbol,
                        child: customTextStyleBody(
                          text: "$symbol - ($market) $nameBank",
                          size: 16,
                          txalign: TextAlign.start,
                          color: Theme.of(context).primaryColor,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  );

                  filteredSuggestions
                      .sort((a, b) => a.searchKey.compareTo(b.searchKey));
                }

                final colors = Theme.of(context).primaryColor;
                var bQtty1 = marketInfo?.bidQtty1 ?? 0;
                var bQtty2 = marketInfo?.bidQtty2 ?? 0;
                var bQtty3 = marketInfo?.bidQtty3 ?? 0;
                var oQtty1 = marketInfo?.offerQtty1 ?? 0;
                var oQtty2 = marketInfo?.offerQtty2 ?? 0;
                var oQtty3 = marketInfo?.offerQtty3 ?? 0;
                var maxQtty = max<int>(
                    max(max(bQtty1, bQtty2), max(bQtty3, oQtty1)),
                    max(oQtty2, oQtty3));
                if (maxQtty == 0) {
                  maxQtty = 1;
                }
                if (disabledGiaDat == false && firstTimeGia) {
                  if (marketInfo?.matchPrice == null) {
                    giadat.text = (marketInfo?.refPrice ?? 0).toString();
                  } else {
                    giadat.text = (marketInfo?.matchPrice).toString();
                  }
                  fetchInfoOrder(symbol.text, double.parse(giadat.text) * 1000);
                  firstTimeGia = false;
                }

                // print(marketInfo?.marketCode);
                // print(marketInfo?.tradeSessionCode);
                if (typeCommand == "NORMAL") {
                  if (marketInfo?.marketCode == "STX") {
                    //HNX
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = ["LO", "MTL", "MOK", "MAK", "ATC"];
                        1;
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = ["LO", "MTL", "MOK", "MAK", "ATC"];
                        1;
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO", "MTL", "MOK", "MAK", "ATC"];
                        1;
                        break;
                      // case "10": //Phiên mở cửa
                      //   listPrice = ["LO", "ATC"];
                      //   break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO", "MTL", "MOK", "MAK", "ATC"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = ["LO", "ATC"];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = ["PLO"];
                        break;
                      // case "96": //Kết thúc ngày VD
                      //   listPrice = ["LO", "ATO", "ATC", "MP"];
                      //   break;

                      default:
                        listPrice = ["LO", "ATO", "MTL", "MOK", "MAK", "PLO"];
                    }
                  } else if (marketInfo?.marketCode == "UPX") {
                    //UpCom
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = ["LO"];
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = [];
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO"];
                        break;
                      case "10": //Phiên mở cửa
                        listPrice = [];
                        break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = [];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = [];
                        break;
                      // case "96": //Kết thúc ngày VD
                      //   listPrice = ["LO", "ATO", "ATC", "MP"];
                      //   break;
                      default:
                        listPrice = [];
                    }
                  } else if (marketInfo?.marketCode == "STO") {
                    //HoSE
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = ["LO", "MP", "ATO", "ATC"];
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = ["LO", "MP", "ATO", "ATC"];
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO", "MP", "ATC"];
                        break;
                      case "10": //Phiên mở cửa
                        listPrice = ["LO", "MP", "ATO", "ATC"];
                        break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO", "MP", "ATC"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = ["LO", "ATC"];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = [];
                        break;
                      // case "96": //Kết thúc ngày VD
                      //   listPrice = ["LO", "ATO", "ATC", "MP"];
                      //   break;
                      default:
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                    }
                  } else if (marketInfo?.marketCode == "HCX") {
                    //bond
                  } else if (marketInfo?.marketCode == "DVX") {
                    //phái sinh
                  }
                } else if (typeCommand == "TCO") {
                  listPrice = ['LO'];
                } else if (typeCommand == "SO") {
                  if (marketInfo?.marketCode == "STX") {
                    //HNX
                    listPrice = ["LO", "MTL", "MOK", "MAK"];
                  } else if (marketInfo?.marketCode == "UPX") {
                    //UpCOM
                    listPrice = ["LO", "MTL", "MOK", "MAK"];
                  } else if (marketInfo?.marketCode == "STO") {
                    //HoSE
                    listPrice = ["LO", "MP"];
                  } else if (marketInfo?.marketCode == "HCX") {
                    listPrice = ["LO"];
                    //Bond
                  } else if (marketInfo?.marketCode == "DVX") {
                    listPrice = ["LO"];
                    //Phái sinh
                  }
                } else if (typeCommand == "TS") {
                  if (marketInfo?.marketCode == "STX") {
                    //HNX
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = ["LO", "ATC", "MTL", "MOK", "MAK"];
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = ["LO", "ATC", "MTL", "MOK", "MAK"];
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO", "ATC", "MTL", "MOK", "MAK"];
                        break;
                      case "10": //Phiên mở cửa
                        listPrice = [];
                        break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO", "MTL", "MOK", "MAK", "ATC"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = ["LO", "ATC"];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = ["PLO"];
                        break;
                      case "96": //Kết thúc ngày VD
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;

                      default:
                        listPrice = [];
                    }
                  } else if (marketInfo?.marketCode == "UPX") {
                    //UpCOM
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = [];
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = [];
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO"];
                        break;
                      case "10": //Phiên mở cửa
                        listPrice = [];
                        break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = [];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = [];
                        break;
                      case "96": //Kết thúc ngày VD
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      default:
                        listPrice = [];
                    }
                  } else if (marketInfo?.marketCode == "STO") {
                    //HoSE
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO", "ATC", "MP"];
                        break;
                      case "10": //Phiên mở cửa
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO", "MP", "ATC"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = ["LO", "ATC"];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = [];
                        break;
                      case "96": //Kết thúc ngày VD
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      default:
                        listPrice = [];
                    }
                  } else if (marketInfo?.marketCode == "HCX") {
                    //Bond
                  } else if (marketInfo?.marketCode == "DVX") {
                    //Phái sinh
                  }
                } else if (typeCommand == "SLTP") {
                  if (marketInfo?.marketCode == "STX") {
                    //HNX
                    listPrice = ["LO", "ATC", "MTL", "MOK", "MAK"];
                  } else if (marketInfo?.marketCode == "UPX") {
                    //UpCOM
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = [];
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = [];
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO"];
                        break;
                      case "10": //Phiên mở cửa
                        listPrice = [];
                        break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = [];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = [];
                        break;
                      case "96": //Kết thúc ngày VD
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      default:
                        listPrice = [];
                    }
                  } else if (marketInfo?.marketCode == "STO") {
                    //HoSE
                    switch (marketInfo?.tradeSessionCode) {
                      case "0": // Trước giờ giao dịch
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      case "01": // Trước giờ giao dịch
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      case "03": //Phiên nghỉ trưa
                        listPrice = ["LO", "ATC", "MP"];
                        break;
                      case "10": //Phiên mở cửa
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      case "30": //Phiên liên tục
                        listPrice = ["LO", "MP", "ATC"];
                        break;
                      case "40": //Phiên đóng cửa
                        listPrice = ["LO", "ATC"];
                        break;
                      case "60": //Phiên sau giờ
                        listPrice = [];
                        break;
                      case "96": //Kết thúc ngày VD
                        listPrice = ["LO", "ATO", "ATC", "MP"];
                        break;
                      default:
                        listPrice = [];
                    }
                  } else if (marketInfo?.marketCode == "HCX") {
                    //Bond
                  } else if (marketInfo?.marketCode == "DVX") {
                    //Phái sinh
                  }
                }
                if (khoiluong.text.isNotEmpty &&
                    giadat.text.isNotEmpty &&
                    giadat.text.contains(RegExp(r'^[0-9.]+$'))) {
                  int a =
                      int.parse(khoiluong.text.replaceAll(RegExp(r','), ''));
                  double c = double.parse(giadat.text);
                  int b = (c * 1000).toInt();
                  tonggiatrilenh = a * b;
                } else {
                  tonggiatrilenh = 0;
                }

                if (isClick) {
                  fetchInfoOrder(symbol.text, double.parse(giadat.text) * 1000);
                  isClick = false;
                }
                ceil = marketInfo?.ceilPrice ?? 0;
                floor = marketInfo?.floorPrice ?? 0;
                return Container(
                  margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //search
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 36,
                              width: 240,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SearchField(
                                hint: appLocal.hintSearch,
                                controller: symbol,
                                focusNode: _focusNode,
                                searchInputDecoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4),
                                    child: SvgPicture.asset(
                                        'assets/icons/ic_search.svg'),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        symbol.clear();
                                      });
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).hintColor,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Theme.of(context).hintColor,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding:
                                      const EdgeInsets.only(left: 8),
                                ),
                                itemHeight: 80,
                                maxSuggestionsInViewPort: 2,
                                searchStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).primaryColor,
                                ),
                                suggestions: filteredSuggestions,
                                onSearchTextChanged: (p0) {
                                  setState(() {
                                    symbol.text = p0.toUpperCase();
                                  });

                                  return filteredSuggestions
                                      .where((element) => element.searchKey
                                          .contains(symbol.text))
                                      .toList();
                                },
                                onSubmit: (p0) {
                                  marketInfo = state.marketInfo[symbol.text];
                                  double price =
                                      (marketInfo?.matchPrice ?? 0) * 1000;
                                  setState(() {
                                    currentSymbol = symbol.text;
                                    khoiluong.clear();
                                    checkKhoiluongEdited = false;
                                    double a = (marketInfo?.matchPrice ?? 0);
                                    if (a != 0) {
                                      giadat.text = a.toString();
                                    } else {
                                      giadat.clear();
                                    }
                                    typeGiaDat = 0;
                                    disabledGiaDat = false;
                                    firstTimeGia = true;
                                  });
                                  fetchInfoOrder(symbol.text, price);
                                },
                                onSuggestionTap: (p0) {
                                  _focusNode.unfocus();

                                  marketInfo = state
                                      .marketInfo[p0.searchKey.toUpperCase()];
                                  double price =
                                      (marketInfo?.matchPrice ?? 0) * 1000;
                                  setState(() {
                                    currentSymbol = p0.searchKey;
                                    khoiluong.clear();
                                    checkKhoiluongEdited = false;
                                    double a = (marketInfo?.matchPrice ?? 0);
                                    if (a != 0) {
                                      giadat.text = a.toString();
                                    } else {
                                      giadat.clear();
                                    }
                                    typeGiaDat = 0;
                                    disabledGiaDat = false;
                                    firstTimeGia = true;
                                  });
                                  fetchInfoOrder(p0.searchKey, price);
                                },
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                  barrierColor: Colors.transparent,
                                  shape: const RoundedRectangleBorder(),
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (BuildContext context) {
                                    return FractionallySizedBox(
                                      heightFactor: 0.7,
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: TradingView(
                                              symbol: currentSymbol,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            height: 60,
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .buttonTheme
                                                        .colorScheme!
                                                        .background,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              child: customTextStyleBody(
                                                text: "Đặt lệnh",
                                                color: Theme.of(context)
                                                    .buttonTheme
                                                    .colorScheme!
                                                    .primary,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: SizedBox(
                                width: 72,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icons/ic-chart.svg',
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    customTextStyleBody(
                                      text: "Biểu đồ",
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                        //Thông tin symbol
                        Container(
                          //height: 108,
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 16, bottom: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          padding: const EdgeInsets.only(
                              left: 8, top: 4, bottom: 4, right: 39),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  HighLight(
                                    symbol: marketInfo?.symbol,
                                    textStyle:
                                        theme.textTheme.bodyMedium?.copyWith(
                                      color: colorRealTime[
                                              marketInfo?.matchPriceColor] ??
                                          colors,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    value: "${marketInfo?.matchPrice}"
                                            .isValidNumber
                                        ? double.tryParse(
                                            marketInfo?.matchPrice.toString() ??
                                                "0")
                                        : null,
                                    type: HighLightType.PRICE,
                                    child: Text(
                                      "${marketInfo?.matchPrice ?? 0}",
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 2),
                                    child: Row(
                                      children: [
                                        customTextStyleBody(
                                          text:
                                              "${marketInfo?.changePrice ?? 0} / ",
                                          color: colorRealTime[marketInfo
                                                  ?.changePriceColor] ??
                                              colors,
                                          fontWeight: FontWeight.w400,
                                        ),
                                        customTextStyleBody(
                                          text:
                                              "${marketInfo?.pctChangePrice ?? 0}%",
                                          fontWeight: FontWeight.w400,
                                          color: colorRealTime[marketInfo
                                                  ?.pctChangePriceColor] ??
                                              colors,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      customTextStyleBody(
                                        text:
                                            "${appLocal.addCommandForm('totalvol')}: ",
                                        fontWeight: FontWeight.w400,
                                        size: 12,
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        txalign: TextAlign.start,
                                      ),
                                      customTextStyleBody(
                                        text: Utils().formatNumber(
                                            marketInfo?.totalTradedQttyNM ?? 0),
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 4),
                                    height: 40,
                                    width: 132,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customTextStyleBody(
                                              text: appLocal
                                                  .addCommandForm('floor'),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              size: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            customTextStyleBody(
                                              text:
                                                  "${marketInfo?.floorPrice ?? 0}",
                                              color: const Color(0xff0CC6DA),
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customTextStyleBody(
                                              text:
                                                  appLocal.addCommandForm('tc'),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              size: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            customTextStyleBody(
                                              text:
                                                  "${marketInfo?.refPrice ?? 0}",
                                              color: const Color(0xffCCAC3D),
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customTextStyleBody(
                                              text: appLocal
                                                  .addCommandForm('ceil'),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              size: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            customTextStyleBody(
                                              text:
                                                  "${marketInfo?.ceilPrice ?? 0}",
                                              color: const Color(0xffF23AFF),
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 132,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customTextStyleBody(
                                              text: appLocal
                                                  .addCommandForm('lowest'),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              size: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            customTextStyleBody(
                                              text:
                                                  "${marketInfo?.lowestPrice ?? 0}",
                                              color: const Color(0xffF04A47),
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customTextStyleBody(
                                              text: appLocal
                                                  .addCommandForm('avg'),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              size: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            customTextStyleBody(
                                              text:
                                                  "${marketInfo?.avgPrice ?? 0}",
                                              color: const Color(0xffCCAC3D),
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            customTextStyleBody(
                                              text: appLocal
                                                  .addCommandForm('highest'),
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              size: 12,
                                              fontWeight: FontWeight.w400,
                                            ),
                                            const SizedBox(
                                              height: 2,
                                            ),
                                            customTextStyleBody(
                                              text:
                                                  "${marketInfo?.highestPrice ?? 0}",
                                              color: const Color(0xff4FD08A),
                                              fontWeight: FontWeight.w500,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),

                        // bieu do KL mua ban
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            38) /
                                        2,
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        customTextStyleBody(
                                          text: appLocal.addCommandForm('Bvol'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        customTextStyleBody(
                                          text: appLocal.addCommandForm('Bpri'),
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff4FD08A),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            38) /
                                        2,
                                    height: 20,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        customTextStyleBody(
                                          text: appLocal.addCommandForm('Spri'),
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffF04A47),
                                        ),
                                        customTextStyleBody(
                                          text: appLocal.addCommandForm('Svol'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            38) /
                                        2,
                                    height: 68,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              child: HighLight(
                                                symbol: marketInfo?.symbol,
                                                textStyle: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                ),
                                                value: "$bQtty1".isValidNumber
                                                    ? double.tryParse(
                                                        bQtty1.toString())
                                                    : null,
                                                type: HighLightType.PRICE,
                                                child: Text(
                                                  Utils().formatNumber(bQtty1),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60,
                                              height: 20,
                                              alignment: Alignment.centerRight,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: (bQtty1 / maxQtty) *
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    38) /
                                                                2 -
                                                            60),
                                                    decoration: BoxDecoration(
                                                      color: backgroundColorRealTime[
                                                          marketInfo
                                                              ?.bidPrice1Color],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 4,
                                                    top: 1,
                                                    child: HighLight(
                                                      symbol:
                                                          marketInfo?.symbol,
                                                      textStyle: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: colorRealTime[
                                                            marketInfo
                                                                ?.bidPrice1Color],
                                                        fontSize: 14,
                                                      ),
                                                      value: "${marketInfo?.bidPrice1}"
                                                              .isValidNumber
                                                          ? double.tryParse(marketInfo
                                                                  ?.bidPrice1Color
                                                                  .toString() ??
                                                              '0')
                                                          : null,
                                                      type: HighLightType.PRICE,
                                                      child: Text(
                                                          "${marketInfo?.bidPrice1 ?? 0}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              child: HighLight(
                                                symbol: marketInfo?.symbol,
                                                textStyle: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                ),
                                                value: "$bQtty2".isValidNumber
                                                    ? double.tryParse(
                                                        bQtty2.toString())
                                                    : null,
                                                type: HighLightType.PRICE,
                                                child: Text(
                                                  Utils().formatNumber(bQtty2),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60,
                                              height: 20,
                                              alignment: Alignment.centerRight,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: (bQtty2 / maxQtty) *
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    38) /
                                                                2 -
                                                            60),
                                                    decoration: BoxDecoration(
                                                      color: backgroundColorRealTime[
                                                          marketInfo
                                                              ?.bidPrice2Color],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 4,
                                                    top: 1,
                                                    child: HighLight(
                                                      symbol:
                                                          marketInfo?.symbol,
                                                      textStyle: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: colorRealTime[
                                                            marketInfo
                                                                ?.bidPrice2Color],
                                                        fontSize: 14,
                                                      ),
                                                      value: "${marketInfo?.bidPrice2}"
                                                              .isValidNumber
                                                          ? double.tryParse(marketInfo
                                                                  ?.bidPrice2Color
                                                                  .toString() ??
                                                              '0')
                                                          : null,
                                                      type: HighLightType.PRICE,
                                                      child: Text(
                                                          "${marketInfo?.bidPrice2 ?? 0}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 60,
                                              child: HighLight(
                                                symbol: marketInfo?.symbol,
                                                textStyle: theme
                                                    .textTheme.bodyMedium
                                                    ?.copyWith(
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  fontSize: 14,
                                                ),
                                                value: "$bQtty3".isValidNumber
                                                    ? double.tryParse(
                                                        bQtty3.toString())
                                                    : null,
                                                type: HighLightType.PRICE,
                                                child: Text(
                                                  Utils().formatNumber(bQtty3),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60,
                                              height: 20,
                                              alignment: Alignment.centerRight,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: (bQtty3 / maxQtty) *
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    38) /
                                                                2 -
                                                            60),
                                                    decoration: BoxDecoration(
                                                      color: backgroundColorRealTime[
                                                          marketInfo
                                                              ?.bidPrice3Color],
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    right: 4,
                                                    top: 1,
                                                    child: HighLight(
                                                      symbol:
                                                          marketInfo?.symbol,
                                                      textStyle: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: colorRealTime[
                                                            marketInfo
                                                                ?.bidPrice3Color],
                                                        fontSize: 14,
                                                      ),
                                                      value: "${marketInfo?.bidPrice3}"
                                                              .isValidNumber
                                                          ? double.tryParse(marketInfo
                                                                  ?.bidPrice3Color
                                                                  .toString() ??
                                                              '0')
                                                          : null,
                                                      type: HighLightType.PRICE,
                                                      child: Text(
                                                          "${marketInfo?.bidPrice3 ?? 0}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: (MediaQuery.of(context).size.width -
                                            38) /
                                        2,
                                    height: 68,
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60,
                                              height: 20,
                                              alignment: Alignment.centerLeft,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: (oQtty1 / maxQtty) *
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    38) /
                                                                2 -
                                                            60),
                                                    decoration: BoxDecoration(
                                                      color: backgroundColorRealTime[
                                                              marketInfo
                                                                  ?.offerPrice1Color] ??
                                                          colors,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 4,
                                                    top: 1,
                                                    child: HighLight(
                                                      symbol:
                                                          marketInfo?.symbol,
                                                      textStyle: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: colorRealTime[
                                                            marketInfo
                                                                ?.offerPrice1Color],
                                                        fontSize: 14,
                                                      ),
                                                      value: "${marketInfo?.offerPrice1}"
                                                              .isValidNumber
                                                          ? double.tryParse(marketInfo
                                                                  ?.offerPrice1Color
                                                                  .toString() ??
                                                              '0')
                                                          : null,
                                                      type: HighLightType.PRICE,
                                                      child: Text(
                                                          "${marketInfo?.offerPrice1 ?? 0}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 60,
                                              child: HighLight(
                                                symbol: marketInfo?.symbol,
                                                value: "$oQtty1".isValidNumber
                                                    ? double.tryParse(
                                                        oQtty1.toString())
                                                    : null,
                                                type: HighLightType.PRICE,
                                                child: customTextStyleBody(
                                                  text: Utils()
                                                      .formatNumber(oQtty1),
                                                  txalign: TextAlign.end,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60,
                                              height: 20,
                                              alignment: Alignment.centerLeft,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: (oQtty2 / maxQtty) *
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    38) /
                                                                2 -
                                                            60),
                                                    decoration: BoxDecoration(
                                                      color: backgroundColorRealTime[
                                                              marketInfo
                                                                  ?.offerPrice2Color] ??
                                                          colors,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 4,
                                                    top: 1,
                                                    child: HighLight(
                                                      symbol:
                                                          marketInfo?.symbol,
                                                      textStyle: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: colorRealTime[
                                                            marketInfo
                                                                ?.offerPrice2Color],
                                                        fontSize: 14,
                                                      ),
                                                      value: "${marketInfo?.offerPrice2}"
                                                              .isValidNumber
                                                          ? double.tryParse(marketInfo
                                                                  ?.offerPrice2Color
                                                                  .toString() ??
                                                              '0')
                                                          : null,
                                                      type: HighLightType.PRICE,
                                                      child: Text(
                                                          "${marketInfo?.offerPrice2 ?? 0}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 60,
                                              child: HighLight(
                                                symbol: marketInfo?.symbol,
                                                value: "$oQtty2".isValidNumber
                                                    ? double.tryParse(
                                                        oQtty2.toString())
                                                    : null,
                                                type: HighLightType.PRICE,
                                                child: customTextStyleBody(
                                                  text: Utils()
                                                      .formatNumber(oQtty2),
                                                  txalign: TextAlign.end,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Container(
                                              width: (MediaQuery.of(context)
                                                              .size
                                                              .width -
                                                          38) /
                                                      2 -
                                                  60,
                                              height: 20,
                                              alignment: Alignment.centerLeft,
                                              child: Stack(
                                                clipBehavior: Clip.none,
                                                children: [
                                                  Container(
                                                    width: (oQtty3 / maxQtty) *
                                                        ((MediaQuery.of(context)
                                                                        .size
                                                                        .width -
                                                                    38) /
                                                                2 -
                                                            60),
                                                    decoration: BoxDecoration(
                                                      color: backgroundColorRealTime[
                                                              marketInfo
                                                                  ?.offerPrice3Color] ??
                                                          colors,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 4,
                                                    top: 1,
                                                    child: HighLight(
                                                      symbol:
                                                          marketInfo?.symbol,
                                                      textStyle: theme
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                        color: colorRealTime[
                                                            marketInfo
                                                                ?.offerPrice3Color],
                                                        fontSize: 14,
                                                      ),
                                                      value: "${marketInfo?.offerPrice3}"
                                                              .isValidNumber
                                                          ? double.tryParse(marketInfo
                                                                  ?.offerPrice3Color
                                                                  .toString() ??
                                                              '0')
                                                          : null,
                                                      type: HighLightType.PRICE,
                                                      child: Text(
                                                          "${marketInfo?.offerPrice3 ?? 0}"),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 60,
                                              child: HighLight(
                                                symbol: marketInfo?.symbol,
                                                value: "$oQtty3".isValidNumber
                                                    ? double.tryParse(
                                                        oQtty3.toString())
                                                    : null,
                                                type: HighLightType.PRICE,
                                                child: customTextStyleBody(
                                                  text: Utils()
                                                      .formatNumber(oQtty3),
                                                  txalign: TextAlign.end,
                                                  color: Theme.of(context)
                                                      .primaryColor,
                                                  size: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Loại lệnh
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          height: 32,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            children: [
                              Tooltip(
                                triggerMode: TooltipTriggerMode.tap,
                                margin: EdgeInsets.only(
                                  left: 4,
                                  right: MediaQuery.of(context).size.width / 3,
                                ),
                                textStyle: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).primaryColor,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                message: (typeCommand == "SLTP")
                                    ? "Stop Loss/Take Profit (SL/TP) là lệnh mua kèm lệnh điều kiện chốt lãi/cắt lỗ, nhằm đảm bảo lợi nhuận hoặc giới hạn rủi do trong mức cho phép của nhà đầu tư"
                                    : (typeCommand == "SO")
                                        ? "Stop order là lệnh đặt chờ, với giá đặt và giá kích hoạt được xác định trước. Khi giá thị trường vượt hơn hoặc giảm so với mức giá kích hoạt, lệnh sẽ được đẩy vào hệ thống với mức giá khách hàng đã đặt"
                                        : (typeCommand == "TCO")
                                            ? "TCO là lệnh mua/bán với số lượng và giá xác định trước, được đặt trước phiên giao dịch từ một đến nhiều ngày cho đến khi lệnh được khớp hết hoặc bị huỷ."
                                            : (typeCommand == "TS")
                                                ? "Trailing Stop là lệnh đặt với giá mua/bán được tự động điều chỉnh bám sát xu thế của thị trường để đạt được mức giá tối ưu nhất."
                                                : "Pro Competitive (PCO) là lệnh sẵn sàng mua, bán ở bất cứ mức giá nào ưu tiên nhất. Nhà đầu tư sẵn sàng mua ở các mức giá ATO/trần/ATC và bán ở các mức giá ATO/sàn/ATC",
                                child: (typeCommand == "NORMAL")
                                    ? Container()
                                    : Icon(
                                        Icons.info_outline,
                                        size: 16,
                                        color: Theme.of(context).hintColor,
                                      ),
                              ),
                              Flexible(
                                fit: FlexFit.loose,
                                child: SearchField(
                                  controller: _selectedCommand,
                                  hint: hintTextCommand,
                                  searchStyle: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  textAlign: TextAlign.center,
                                  searchInputDecoration: const InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(bottom: 11),
                                  ),
                                  onTap: () {
                                    setState(() {
                                      hintTextCommand = _selectedCommand.text;
                                      _selectedCommand.clear();
                                    });
                                  },
                                  itemHeight: 32,
                                  onSuggestionTap: (p0) {
                                    setState(() {
                                      _selectedCommand.text = p0.searchKey;
                                      typeCommand = p0.item.toString();
                                      khoiluong.clear();
                                      checkKhoiluongEdited = false;
                                      a = null;
                                      giakichhoat.clear();
                                      checkGiaKhEdited = false;
                                      giaKH = null;
                                      //////
                                      giaCatLo.clear();
                                      checkGiaCatLoEdited = false;
                                      validateGiaCatLo = null;
                                      giaChotLai.clear();
                                      checkGiaChotLaiEdited = false;
                                      validateGiaChotLai = null;
                                      biendoCatLo.clear();

                                      ///
                                      bienTruot.clear();
                                      checkBienTruotEdited = false;
                                      validateBienTruot = null;
                                      bienDoGia.clear();
                                    });
                                    print("typeCM: $typeCommand");
                                  },
                                  suggestionAction: SuggestionAction.unfocus,
                                  onSubmit: (p0) {
                                    if (p0 == "") {
                                      setState(() {
                                        _selectedCommand.text = hintTextCommand;
                                      });
                                    } else {
                                      setState(() {
                                        _selectedCommand.text = p0;
                                      });
                                    }
                                  },
                                  onTapOutside: (_) {
                                    if (_selectedCommand.text.isEmpty) {
                                      setState(() {
                                        _selectedCommand.text = hintTextCommand;
                                      });
                                    }
                                  },
                                  suggestions: [
                                    for (var i in commandData)
                                      SearchFieldListItem(
                                        (language == 'vi')
                                            ? i['vN_CDCONTENT']
                                            : i['cdcontent'],
                                        item: i['cdval'],
                                        child: Text(
                                          (language == 'vi')
                                              ? ((i['cdval'] != "NORMAL")
                                                  ? "${i['vN_CDCONTENT']} (${i['cdcontent']})"
                                                  : "${i['vN_CDCONTENT']}")
                                              : ("${i['cdcontent']}"),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Theme.of(context).hintColor,
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Khối lượng
                            customTextStyleBody(
                              text: appLocal.addCommandForm('volume'),
                              color: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .color!,
                              fontWeight: FontWeight.w500,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 6, bottom: 8),
                              height: checkKhoiluongEdited
                                  ? ((errorkhoiluong != null) ? 56 : 32)
                                  : (a == null ? 32 : 56),
                              child: TextField(
                                controller: khoiluong,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  if (value.startsWith('0')) {
                                    khoiluong.text = value.substring(1);
                                    khoiluong.selection =
                                        TextSelection.fromPosition(
                                      TextPosition(
                                          offset: khoiluong.text.length),
                                    );
                                  }
                                },
                                cursorColor: Theme.of(context).primaryColor,
                                textAlign: TextAlign.center,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  errorStyle: const TextStyle(fontSize: 10),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).hintColor),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context).hintColor),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  errorText:
                                      checkKhoiluongEdited ? errorkhoiluong : a,
                                  errorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  focusedErrorBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.red,
                                      width: 1,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.only(
                                      top: (checkKhoiluongEdited)
                                          ? ((errorkhoiluong != null) ? 25 : 0)
                                          : (a == null ? 0 : 25)),
                                  hintText: appLocal.addCommandForm('volume'),
                                  hintStyle: const TextStyle(fontSize: 12),
                                  prefixIcon: GestureDetector(
                                    onTap: () {
                                      String kl;
                                      if (khoiluong.text.isEmpty) {
                                        return;
                                      } else {
                                        kl = khoiluong.text
                                            .replaceAll(RegExp(r','), '');
                                      }
                                      int value = int.parse(kl);
                                      if (value > 100) {
                                        setState(() {
                                          value -= 100;
                                        });
                                        khoiluong.text = value.toString();
                                      } else if (value > 0) {
                                        setState(() {
                                          value--;
                                        });
                                        khoiluong.text = value.toString();
                                      } else {
                                        khoiluong.clear();
                                      }
                                    },
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: (checkKhoiluongEdited)
                                              ? ((errorkhoiluong != null)
                                                  ? 16
                                                  : 8)
                                              : (a == null ? 8 : 16)),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: const Icon(
                                        Icons.remove,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                  suffixIcon: GestureDetector(
                                    onTap: () {
                                      String kl;
                                      if (khoiluong.text.isEmpty) {
                                        kl = "0";
                                      } else {
                                        kl = khoiluong.text
                                            .replaceAll(RegExp(r','), '');
                                      }
                                      int value = int.parse(kl);
                                      if (value > 99 || value == 0) {
                                        setState(() {
                                          value += 100;
                                        });
                                      } else {
                                        setState(() {
                                          value++;
                                        });
                                      }
                                      khoiluong.text = value.toString();
                                    },
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: (checkKhoiluongEdited)
                                              ? ((errorkhoiluong != null)
                                                  ? 16
                                                  : 8)
                                              : (a == null ? 8 : 16)),
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      child: const Icon(
                                        Icons.add,
                                        size: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // KL mua bán tối đa
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                  text:
                                      "${appLocal.addCommandForm('maxQuan')}: ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                  ),
                                ),
                                TextSpan(
                                  text: Utils().formatNumber(
                                      responseInfoOrder.first.canbuyqtty),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xff4FD08A),
                                  ),
                                ),
                                TextSpan(
                                  text: " | ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context)
                                        .textTheme
                                        .titleSmall!
                                        .color!,
                                  ),
                                ),
                                TextSpan(
                                  text: Utils().formatNumber(int.parse(
                                      responseInfoOrder.first.tradeqtty)),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xffF04A47),
                                  ),
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            //gia kich hoat : Lệnh dừng
                            (typeCommand == "SO")
                                ? Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          height: checkGiaKhEdited
                                              ? ((errorGiaKH != null) ? 56 : 32)
                                              : (giaKH == null ? 32 : 56),
                                          width: 80,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              alignment: Alignment.center,
                                              iconStyleData: IconStyleData(
                                                icon: const Icon(
                                                    Icons.keyboard_arrow_down),
                                                iconSize: 16,
                                                iconEnabledColor:
                                                    Theme.of(context).hintColor,
                                              ),
                                              value: highOrlow,
                                              items: [
                                                DropdownMenuItem(
                                                  value: 0,
                                                  child: customTextStyleBody(
                                                    text: ">=",
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                    size: 14,
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value: 1,
                                                  child: customTextStyleBody(
                                                    text: "<=",
                                                    size: 14,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ],
                                              onChanged: (value) {
                                                setState(() {
                                                  highOrlow = value!;
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, bottom: 8),
                                          height: checkGiaKhEdited
                                              ? ((errorGiaKH != null) ? 56 : 32)
                                              : (giaKH == null ? 32 : 56),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              112,
                                          child: TextField(
                                            controller: giakichhoat,
                                            onChanged: (value) {},
                                            onSubmitted: (value) {
                                              setState(() {
                                                giakichhoat.text = value;
                                              });
                                            },
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              errorText: checkGiaKhEdited
                                                  ? errorGiaKH
                                                  : giaKH,
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              errorStyle:
                                                  const TextStyle(fontSize: 10),
                                              contentPadding: EdgeInsets.only(
                                                  top: (checkGiaKhEdited)
                                                      ? ((errorGiaKH != null)
                                                          ? 25
                                                          : 0)
                                                      : (giaKH == null
                                                          ? 0
                                                          : 25)),
                                              hintText: appLocal.addCommandForm(
                                                  'activationprice'),
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
                                              prefixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = giakichhoat.text;
                                                  String market =
                                                      marketInfo?.marketCode ??
                                                          "";
                                                  dynamic giaKichHoatDouble = 0;
                                                  if (gia.isEmpty) {
                                                    giaKichHoatDouble = null;
                                                  } else {
                                                    giaKichHoatDouble =
                                                        double.parse(gia);
                                                  }
                                                  print(market);
                                                  if (market == "STO") {
                                                    if (giaKichHoatDouble <=
                                                        0) {
                                                      giaKichHoatDouble = 0;
                                                    } else if (giaKichHoatDouble <
                                                        10) {
                                                      giaKichHoatDouble -= 0.01;
                                                    } else if (giaKichHoatDouble <=
                                                        49.95) {
                                                      giaKichHoatDouble -= 0.05;
                                                    } else {
                                                      giaKichHoatDouble -= 0.1;
                                                    }
                                                  } else {
                                                    if (giaKichHoatDouble <=
                                                        0) {
                                                      giaKichHoatDouble = 0;
                                                    } else {
                                                      giaKichHoatDouble -= 0.1;
                                                    }
                                                  }
                                                  String formattedText =
                                                      giaKichHoatDouble
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  giakichhoat.text =
                                                      formattedText;
                                                },
                                                child: Container(
                                                  height: 16,
                                                  width: 16,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical:
                                                          (errorGiaKH != null)
                                                              ? 16
                                                              : 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = giakichhoat.text;
                                                  String market =
                                                      marketInfo?.marketCode ??
                                                          "";
                                                  double giaKHDouble = 0;
                                                  if (gia.isEmpty) {
                                                    giaKHDouble = marketInfo
                                                            ?.floorPrice ??
                                                        0;
                                                  } else {
                                                    giaKHDouble =
                                                        double.parse(gia);
                                                  }
                                                  if (market == "STO") {
                                                    if (giaKHDouble < 10) {
                                                      giaKHDouble += 0.01;
                                                    } else if (giaKHDouble <=
                                                        49.95) {
                                                      giaKHDouble += 0.05;
                                                    } else {
                                                      giaKHDouble += 0.1;
                                                    }
                                                  } else {
                                                    giaKHDouble += 0.1;
                                                  }

                                                  String formattedText =
                                                      giaKHDouble
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  giakichhoat.text =
                                                      formattedText;
                                                },
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical:
                                                          (errorGiaKH != null)
                                                              ? 16
                                                              : 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(),
                            //gia dat
                            (typeCommand == "TS" ||
                                    typeCommand == "PRIORITYODR")
                                ? Container()
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text:
                                            "${appLocal.addCommandForm('price')} (x1000 VND)",
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 6, bottom: 8),
                                        height: (errorGiaDat != null) ? 56 : 32,
                                        child: TextField(
                                          controller: giadat,
                                          onChanged: (value) {
                                            if (value.startsWith('0')) {
                                              giadat.text = value.substring(1);
                                              giadat.selection =
                                                  TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: giadat.text.length),
                                              );
                                            }
                                          },
                                          onSubmitted: (value) {
                                            double giaDatDouble =
                                                double.parse(value);
                                            String formattedText =
                                                giaDatDouble.toStringAsFixed(2);
                                            if (formattedText.contains('.') &&
                                                formattedText.endsWith('0')) {
                                              // Loại bỏ số 0 ở cuối nếu có
                                              formattedText =
                                                  formattedText.substring(0,
                                                      formattedText.length - 1);
                                              if (formattedText.contains('.') &&
                                                  formattedText.endsWith('0')) {
                                                formattedText =
                                                    formattedText.substring(
                                                        0,
                                                        formattedText.length -
                                                            1);
                                                // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                if (formattedText
                                                    .endsWith('.')) {
                                                  formattedText =
                                                      formattedText.substring(
                                                          0,
                                                          formattedText.length -
                                                              1);
                                                }
                                              }
                                            }
                                            giadat.text = formattedText;
                                            setState(() {
                                              isClick = true;
                                            });
                                          },
                                          readOnly: disabledGiaDat,
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          textAlign: TextAlign.center,
                                          // keyboardType: (typeGiaDat == 0)
                                          //     ? TextInputType.number
                                          //     : TextInputType.text,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            errorText: errorGiaDat,
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            errorStyle:
                                                const TextStyle(fontSize: 10),
                                            contentPadding: EdgeInsets.only(
                                                top: (errorGiaDat != null)
                                                    ? 25
                                                    : 0),
                                            hintText: "Giá đặt",
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            prefixIcon: GestureDetector(
                                              onTap: disabledGiaDat
                                                  ? null
                                                  : () {
                                                      String gia = giadat.text;
                                                      String market = marketInfo
                                                              ?.marketCode ??
                                                          "";
                                                      dynamic giaDatDouble = 0;
                                                      if (gia.isEmpty) {
                                                        giaDatDouble = null;
                                                      } else {
                                                        giaDatDouble =
                                                            double.parse(gia);
                                                      }
                                                      print(market);
                                                      if (market == "STO") {
                                                        if (giaDatDouble <= 0) {
                                                          giaDatDouble = 0;
                                                        } else if (giaDatDouble <
                                                            10) {
                                                          giaDatDouble -= 0.01;
                                                        } else if (giaDatDouble <=
                                                            49.95) {
                                                          giaDatDouble -= 0.05;
                                                        } else {
                                                          giaDatDouble -= 0.1;
                                                        }
                                                      } else {
                                                        if (giaDatDouble <= 0) {
                                                          giaDatDouble = 0;
                                                        } else {
                                                          giaDatDouble -= 0.1;
                                                        }
                                                      }
                                                      String formattedText =
                                                          giaDatDouble
                                                              .toStringAsFixed(
                                                                  2);
                                                      if (formattedText
                                                              .contains('.') &&
                                                          formattedText
                                                              .endsWith('0')) {
                                                        // Loại bỏ số 0 ở cuối nếu có
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                        if (formattedText
                                                                .contains(
                                                                    '.') &&
                                                            formattedText
                                                                .endsWith(
                                                                    '0')) {
                                                          formattedText =
                                                              formattedText.substring(
                                                                  0,
                                                                  formattedText
                                                                          .length -
                                                                      1);
                                                          // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                          if (formattedText
                                                              .endsWith('.')) {
                                                            formattedText =
                                                                formattedText.substring(
                                                                    0,
                                                                    formattedText
                                                                            .length -
                                                                        1);
                                                          }
                                                        }
                                                      }
                                                      giadat.text =
                                                          formattedText;
                                                      setState(() {
                                                        isClick = true;
                                                      });
                                                    },
                                              child: Container(
                                                height: 16,
                                                width: 16,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical:
                                                        (errorGiaDat != null)
                                                            ? 16
                                                            : 8),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            suffixIcon: GestureDetector(
                                              onTap: disabledGiaDat
                                                  ? null
                                                  : () {
                                                      String gia = giadat.text;
                                                      String market = marketInfo
                                                              ?.marketCode ??
                                                          "";
                                                      double giaDatDouble = 0;
                                                      if (gia.isEmpty) {
                                                        giaDatDouble = marketInfo
                                                                ?.matchPrice ??
                                                            0;
                                                      } else {
                                                        giaDatDouble =
                                                            double.parse(gia);
                                                      }
                                                      if (market == "STO") {
                                                        if (giaDatDouble < 10) {
                                                          giaDatDouble += 0.01;
                                                        } else if (giaDatDouble <=
                                                            49.95) {
                                                          giaDatDouble += 0.05;
                                                        } else {
                                                          giaDatDouble += 0.1;
                                                        }
                                                      } else {
                                                        giaDatDouble += 0.1;
                                                      }

                                                      String formattedText =
                                                          giaDatDouble
                                                              .toStringAsFixed(
                                                                  2);
                                                      if (formattedText
                                                              .contains('.') &&
                                                          formattedText
                                                              .endsWith('0')) {
                                                        // Loại bỏ số 0 ở cuối nếu có
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                        if (formattedText
                                                                .contains(
                                                                    '.') &&
                                                            formattedText
                                                                .endsWith(
                                                                    '0')) {
                                                          formattedText =
                                                              formattedText.substring(
                                                                  0,
                                                                  formattedText
                                                                          .length -
                                                                      1);
                                                          // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                          if (formattedText
                                                              .endsWith('.')) {
                                                            formattedText =
                                                                formattedText.substring(
                                                                    0,
                                                                    formattedText
                                                                            .length -
                                                                        1);
                                                          }
                                                        }
                                                      }
                                                      giadat.text =
                                                          formattedText;
                                                      setState(() {
                                                        isClick = true;
                                                      });
                                                    },
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical:
                                                        (errorGiaDat != null)
                                                            ? 16
                                                            : 8),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            //bien truot
                            (typeCommand == "TS")
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text:
                                            appLocal.addCommandForm('slippage'),
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 6, bottom: 8),
                                        height: checkBienTruotEdited
                                            ? ((errorBienTrout != null)
                                                ? 56
                                                : 32)
                                            : (validateBienTruot == null
                                                ? 32
                                                : 56),
                                        child: TextField(
                                          controller: bienTruot,
                                          onSubmitted: (value) {
                                            bienTruot.text = value;
                                          },
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            errorText: checkBienTruotEdited
                                                ? errorBienTrout
                                                : validateBienTruot,
                                            errorBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.red),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            errorStyle:
                                                const TextStyle(fontSize: 10),
                                            contentPadding: EdgeInsets.only(
                                                top: (checkBienTruotEdited)
                                                    ? ((errorBienTrout != null)
                                                        ? 25
                                                        : 0)
                                                    : (validateBienTruot == null
                                                        ? 0
                                                        : 25)),
                                            hintText: "Biên trượt",
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            prefixIcon: GestureDetector(
                                              onTap: () {
                                                String bien = bienTruot.text;
                                                dynamic doubleBien = 0;
                                                if (bien.isEmpty) {
                                                  doubleBien = null;
                                                } else {
                                                  doubleBien =
                                                      double.parse(bien);
                                                }
                                                if (doubleBien <= 0) {
                                                  doubleBien = 0;
                                                } else {
                                                  doubleBien -= 0.01;
                                                }
                                                String formattedText =
                                                    doubleBien
                                                        .toStringAsFixed(2);
                                                if (formattedText
                                                        .contains('.') &&
                                                    formattedText
                                                        .endsWith('0')) {
                                                  // Loại bỏ số 0 ở cuối nếu có
                                                  formattedText =
                                                      formattedText.substring(
                                                          0,
                                                          formattedText.length -
                                                              1);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                    if (formattedText
                                                        .endsWith('.')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                    }
                                                  }
                                                }
                                                bienTruot.text = formattedText;
                                              },
                                              child: Container(
                                                height: 16,
                                                width: 16,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical:
                                                        (errorBienTrout != null)
                                                            ? 16
                                                            : 8),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                String bien = bienTruot.text;

                                                double doubleBien = 0;
                                                if (bien.isEmpty) {
                                                  doubleBien = 0;
                                                } else {
                                                  doubleBien =
                                                      double.parse(bien);
                                                }
                                                doubleBien += 0.01;

                                                String formattedText =
                                                    doubleBien
                                                        .toStringAsFixed(2);
                                                if (formattedText
                                                        .contains('.') &&
                                                    formattedText
                                                        .endsWith('0')) {
                                                  // Loại bỏ số 0 ở cuối nếu có
                                                  formattedText =
                                                      formattedText.substring(
                                                          0,
                                                          formattedText.length -
                                                              1);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                    if (formattedText
                                                        .endsWith('.')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                    }
                                                  }
                                                }
                                                bienTruot.text = formattedText;
                                              },
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical:
                                                        (errorBienTrout != null)
                                                            ? 16
                                                            : 8),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),

                            //loai gia dat
                            (typeCommand == "TS" ||
                                    typeCommand == "PRIORITYODR")
                                ? Container()
                                : Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          for (var i = 0;
                                              i < listPrice.length;
                                              i++)
                                            GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  typeGiaDat = i;
                                                  if (typeGiaDat != 0) {
                                                    giadat.text =
                                                        listPrice[typeGiaDat];
                                                    disabledGiaDat = true;

                                                    fetchInfoOrder(
                                                        symbol.text,
                                                        (marketInfo?.ceilPrice ??
                                                                0) *
                                                            1000);
                                                  } else {
                                                    giadat.text = marketInfo
                                                            ?.matchPrice
                                                            .toString() ??
                                                        "0";
                                                    disabledGiaDat = false;
                                                    fetchInfoOrder(
                                                        symbol.text,
                                                        (marketInfo?.matchPrice ??
                                                                0) *
                                                            1000);
                                                  }
                                                });
                                                print(giadat.text);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    right: 6),
                                                decoration: BoxDecoration(
                                                  color: typeGiaDat == i
                                                      ? Theme.of(context)
                                                          .colorScheme
                                                          .secondary
                                                      : Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                width: 49,
                                                height: 16,
                                                child: FittedBox(
                                                  fit: BoxFit.none,
                                                  child: customTextStyleBody(
                                                    text: listPrice[i],
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                            //bien do gia TS
                            (typeCommand == "TS")
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: appLocal
                                            .addCommandForm('pricerange'),
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 6, bottom: 8),
                                        height: 32,
                                        child: TextField(
                                          controller: bienDoGia,
                                          onSubmitted: (value) {
                                            bienDoGia.text = value;
                                          },
                                          cursorColor:
                                              Theme.of(context).primaryColor,
                                          textAlign: TextAlign.center,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(),
                                            hintText: "Biên độ giá",
                                            hintStyle:
                                                const TextStyle(fontSize: 12),
                                            prefixIcon: GestureDetector(
                                              onTap: () {
                                                String bien = bienDoGia.text;
                                                dynamic doubleBienDG = 0;
                                                if (bien.isEmpty) {
                                                  doubleBienDG = null;
                                                } else {
                                                  doubleBienDG =
                                                      double.parse(bien);
                                                }
                                                if (doubleBienDG <= 0) {
                                                  doubleBienDG = 0;
                                                } else {
                                                  doubleBienDG -= 0.01;
                                                }
                                                String formattedText =
                                                    doubleBienDG
                                                        .toStringAsFixed(2);
                                                if (formattedText
                                                        .contains('.') &&
                                                    formattedText
                                                        .endsWith('0')) {
                                                  // Loại bỏ số 0 ở cuối nếu có
                                                  formattedText =
                                                      formattedText.substring(
                                                          0,
                                                          formattedText.length -
                                                              1);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                    if (formattedText
                                                        .endsWith('.')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                    }
                                                  }
                                                }
                                                bienDoGia.text = formattedText;
                                              },
                                              child: Container(
                                                height: 16,
                                                width: 16,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: const Icon(
                                                  Icons.remove,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                            suffixIcon: GestureDetector(
                                              onTap: () {
                                                String bien = bienDoGia.text;

                                                double doubleBienDG = 0;
                                                if (bien.isEmpty) {
                                                  doubleBienDG = 0;
                                                } else {
                                                  doubleBienDG =
                                                      double.parse(bien);
                                                }
                                                doubleBienDG += 0.01;

                                                String formattedText =
                                                    doubleBienDG
                                                        .toStringAsFixed(2);
                                                if (formattedText
                                                        .contains('.') &&
                                                    formattedText
                                                        .endsWith('0')) {
                                                  // Loại bỏ số 0 ở cuối nếu có
                                                  formattedText =
                                                      formattedText.substring(
                                                          0,
                                                          formattedText.length -
                                                              1);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                    if (formattedText
                                                        .endsWith('.')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                    }
                                                  }
                                                }
                                                bienDoGia.text = formattedText;
                                              },
                                              child: Container(
                                                width: 16,
                                                height: 16,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 8),
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                child: const Icon(
                                                  Icons.add,
                                                  size: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            // gia cat lo, gia chot lai, bien do cat lo SLTP

                            (typeCommand == "SLTP")
                                ? Column(children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTextStyleBody(
                                          text: appLocal
                                              .addCommandForm('stoplossprice'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, bottom: 8),
                                          height: checkGiaCatLoEdited
                                              ? ((errorGiaCatLo != null)
                                                  ? 56
                                                  : 32)
                                              : (validateGiaCatLo == null
                                                  ? 32
                                                  : 56),
                                          child: TextField(
                                            controller: giaCatLo,
                                            onSubmitted: (value) {
                                              giaCatLo.text = value;
                                            },
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              errorText: checkGiaCatLoEdited
                                                  ? errorGiaCatLo
                                                  : validateGiaCatLo,
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              errorStyle:
                                                  const TextStyle(fontSize: 10),
                                              contentPadding: EdgeInsets.only(
                                                  top: (checkGiaCatLoEdited)
                                                      ? ((errorGiaCatLo != null)
                                                          ? 25
                                                          : 0)
                                                      : (validateGiaCatLo ==
                                                              null
                                                          ? 0
                                                          : 25)),
                                              hintText: appLocal.addCommandForm(
                                                  'stoplossprice'),
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
                                              prefixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = giaCatLo.text;
                                                  String market =
                                                      marketInfo?.marketCode ??
                                                          "";
                                                  dynamic giaCatLoDouble = 0;
                                                  if (gia.isEmpty) {
                                                    giaCatLoDouble = null;
                                                  } else {
                                                    giaCatLoDouble =
                                                        double.parse(gia);
                                                  }
                                                  print(market);
                                                  if (market == "STO") {
                                                    if (giaCatLoDouble <= 0) {
                                                      giaCatLoDouble = 0;
                                                    } else if (giaCatLoDouble <
                                                        10) {
                                                      giaCatLoDouble -= 0.01;
                                                    } else if (giaCatLoDouble <=
                                                        49.95) {
                                                      giaCatLoDouble -= 0.05;
                                                    } else {
                                                      giaCatLoDouble -= 0.1;
                                                    }
                                                  } else {
                                                    if (giaCatLoDouble <= 0) {
                                                      giaCatLoDouble = 0;
                                                    } else {
                                                      giaCatLoDouble -= 0.1;
                                                    }
                                                  }
                                                  String formattedText =
                                                      giaCatLoDouble
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  giaCatLo.text = formattedText;
                                                },
                                                child: Container(
                                                  height: 16,
                                                  width: 16,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical:
                                                          (errorGiaCatLo !=
                                                                  null)
                                                              ? 16
                                                              : 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = giaCatLo.text;
                                                  String market =
                                                      marketInfo?.marketCode ??
                                                          "";
                                                  double giaCatLoDouble = 0;
                                                  if (gia.isEmpty) {
                                                    giaCatLoDouble = marketInfo
                                                            ?.floorPrice ??
                                                        0;
                                                  } else {
                                                    giaCatLoDouble =
                                                        double.parse(gia);
                                                  }
                                                  if (market == "STO") {
                                                    if (giaCatLoDouble < 10) {
                                                      giaCatLoDouble += 0.01;
                                                    } else if (giaCatLoDouble <=
                                                        49.95) {
                                                      giaCatLoDouble += 0.05;
                                                    } else {
                                                      giaCatLoDouble += 0.1;
                                                    }
                                                  } else {
                                                    giaCatLoDouble += 0.1;
                                                  }

                                                  String formattedText =
                                                      giaCatLoDouble
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  giaCatLo.text = formattedText;
                                                },
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical:
                                                          (errorGiaCatLo !=
                                                                  null)
                                                              ? 16
                                                              : 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTextStyleBody(
                                          text: appLocal.addCommandForm(
                                              'takeprofitprice'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, bottom: 8),
                                          height: checkGiaChotLaiEdited
                                              ? ((errorGiaChotLai != null)
                                                  ? 56
                                                  : 32)
                                              : (validateGiaChotLai == null
                                                  ? 32
                                                  : 56),
                                          child: TextField(
                                            controller: giaChotLai,
                                            onSubmitted: (value) {
                                              giaChotLai.text = value;
                                            },
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              errorText: checkGiaChotLaiEdited
                                                  ? errorGiaChotLai
                                                  : validateGiaChotLai,
                                              errorBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              focusedErrorBorder:
                                                  OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              errorStyle:
                                                  const TextStyle(fontSize: 10),
                                              contentPadding: EdgeInsets.only(
                                                  top: (checkGiaChotLaiEdited)
                                                      ? ((errorGiaChotLai !=
                                                              null)
                                                          ? 25
                                                          : 0)
                                                      : (validateGiaChotLai ==
                                                              null
                                                          ? 0
                                                          : 25)),
                                              hintText: appLocal.addCommandForm(
                                                  'takeprofitprice'),
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
                                              prefixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = giaChotLai.text;
                                                  String market =
                                                      marketInfo?.marketCode ??
                                                          "";
                                                  dynamic giaChotLaiDouble = 0;
                                                  if (gia.isEmpty) {
                                                    giaChotLaiDouble = null;
                                                  } else {
                                                    giaChotLaiDouble =
                                                        double.parse(gia);
                                                  }
                                                  print(market);
                                                  if (market == "STO") {
                                                    if (giaChotLaiDouble <= 0) {
                                                      giaChotLaiDouble = 0;
                                                    } else if (giaChotLaiDouble <
                                                        10) {
                                                      giaChotLaiDouble -= 0.01;
                                                    } else if (giaChotLaiDouble <=
                                                        49.95) {
                                                      giaChotLaiDouble -= 0.05;
                                                    } else {
                                                      giaChotLaiDouble -= 0.1;
                                                    }
                                                  } else {
                                                    if (giaChotLaiDouble <= 0) {
                                                      giaChotLaiDouble = 0;
                                                    } else {
                                                      giaChotLaiDouble -= 0.1;
                                                    }
                                                  }
                                                  String formattedText =
                                                      giaChotLaiDouble
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  giaChotLai.text =
                                                      formattedText;
                                                },
                                                child: Container(
                                                  height: 16,
                                                  width: 16,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical:
                                                          (errorGiaChotLai !=
                                                                  null)
                                                              ? 16
                                                              : 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = giaChotLai.text;
                                                  String market =
                                                      marketInfo?.marketCode ??
                                                          "";
                                                  double giaChotLaiDouble = 0;
                                                  if (gia.isEmpty) {
                                                    giaChotLaiDouble =
                                                        marketInfo
                                                                ?.floorPrice ??
                                                            0;
                                                  } else {
                                                    giaChotLaiDouble =
                                                        double.parse(gia);
                                                  }
                                                  if (market == "STO") {
                                                    if (giaChotLaiDouble < 10) {
                                                      giaChotLaiDouble += 0.01;
                                                    } else if (giaChotLaiDouble <=
                                                        49.95) {
                                                      giaChotLaiDouble += 0.05;
                                                    } else {
                                                      giaChotLaiDouble += 0.1;
                                                    }
                                                  } else {
                                                    giaChotLaiDouble += 0.1;
                                                  }

                                                  String formattedText =
                                                      giaChotLaiDouble
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  giaChotLai.text =
                                                      formattedText;
                                                },
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical:
                                                          (errorGiaChotLai !=
                                                                  null)
                                                              ? 16
                                                              : 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        customTextStyleBody(
                                          text: appLocal.addCommandForm('SLs'),
                                          color: Theme.of(context)
                                              .textTheme
                                              .titleSmall!
                                              .color!,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 6, bottom: 8),
                                          height: 32,
                                          child: TextField(
                                            controller: biendoCatLo,
                                            onSubmitted: (value) {
                                              biendoCatLo.text = value;
                                            },
                                            cursorColor:
                                                Theme.of(context).primaryColor,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Theme.of(context)
                                                        .hintColor),
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                              ),
                                              contentPadding:
                                                  const EdgeInsets.only(),
                                              hintText: appLocal
                                                  .addCommandForm('SLs'),
                                              hintStyle:
                                                  const TextStyle(fontSize: 12),
                                              prefixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = biendoCatLo.text;
                                                  dynamic doubleGia = 0;
                                                  if (gia.isEmpty) {
                                                    doubleGia = null;
                                                  } else {
                                                    doubleGia =
                                                        double.parse(gia);
                                                  }
                                                  if (doubleGia <= 0) {
                                                    doubleGia = 0;
                                                  } else {
                                                    doubleGia -= 0.01;
                                                  }
                                                  String formattedText =
                                                      doubleGia
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  biendoCatLo.text =
                                                      formattedText;
                                                },
                                                child: Container(
                                                  height: 16,
                                                  width: 16,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.remove,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  String gia = biendoCatLo.text;

                                                  double doubleGia = 0;
                                                  if (gia.isEmpty) {
                                                    doubleGia = 0;
                                                  } else {
                                                    doubleGia =
                                                        double.parse(gia);
                                                  }
                                                  doubleGia += 0.01;

                                                  String formattedText =
                                                      doubleGia
                                                          .toStringAsFixed(2);
                                                  if (formattedText
                                                          .contains('.') &&
                                                      formattedText
                                                          .endsWith('0')) {
                                                    // Loại bỏ số 0 ở cuối nếu có
                                                    formattedText =
                                                        formattedText.substring(
                                                            0,
                                                            formattedText
                                                                    .length -
                                                                1);
                                                    if (formattedText
                                                            .contains('.') &&
                                                        formattedText
                                                            .endsWith('0')) {
                                                      formattedText =
                                                          formattedText.substring(
                                                              0,
                                                              formattedText
                                                                      .length -
                                                                  1);
                                                      // Nếu sau khi loại bỏ số 0, ký tự cuối cùng là dấu '.', cũng loại bỏ dấu '.'
                                                      if (formattedText
                                                          .endsWith('.')) {
                                                        formattedText =
                                                            formattedText.substring(
                                                                0,
                                                                formattedText
                                                                        .length -
                                                                    1);
                                                      }
                                                    }
                                                  }
                                                  biendoCatLo.text =
                                                      formattedText;
                                                },
                                                child: Container(
                                                  width: 16,
                                                  height: 16,
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8),
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ])
                                : Container(),

                            //suc mua && ti le cho vay
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text:
                                                "${appLocal.addCommandForm('buyingPower')}: ",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .textTheme
                                                  .titleSmall!
                                                  .color!,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                "${Utils().formatNumber(responseInfoOrder.first.buyingpower)} VND",
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.add_box_outlined,
                                      size: 16,
                                      color: Theme.of(context).hintColor,
                                    ),
                                  ],
                                ),
                                (acctno.endsWith("NM"))
                                    ? Container()
                                    : RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${appLocal.addCommandForm('loanRatio')}: ",
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .color!,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            TextSpan(
                                              text: responseInfoOrder
                                                  .first.mgdensity,
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        // tong gia tri lenh
                        (typeGiaDat == 0 && typeCommand == "NORMAL")
                            ? Column(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "${appLocal.addCommandForm('totalordervalue')}: ",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        TextSpan(
                                          text: Utils()
                                              .formatNumber(tonggiatrilenh),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        TextSpan(
                                          text: " VND",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .textTheme
                                                .titleSmall!
                                                .color!,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              )
                            : Container(),

                        // Ngày bat dau,  kết thúc
                        Row(
                          mainAxisAlignment:
                              (typeCommand == "TCO" || typeCommand == "SLTP")
                                  ? MainAxisAlignment.spaceBetween
                                  : MainAxisAlignment.start,
                          children: [
                            //bat dau
                            (typeCommand == "TCO" || typeCommand == "SLTP")
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text: appLocal
                                            .addCommandForm('startDate'),
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 6, bottom: 8),
                                        height:
                                            errorStartDate == null ? 32 : 58,
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    45) /
                                                2,
                                        child: TextField(
                                          controller: startDate,
                                          onTap: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  DateFormat('dd/MM/yyy')
                                                      .parse(startDate.text),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        const ColorScheme.light(
                                                      primary: Colors
                                                          .green, // Màu sắc chính
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                startDate.text =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(picked);
                                              });
                                            }
                                          },
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                            errorText: errorStartDate,
                                            errorStyle:
                                                const TextStyle(fontSize: 8),
                                            errorMaxLines: 2,
                                            errorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: const BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: const BorderSide(
                                                color: Colors.red,
                                              ),
                                            ),
                                            suffixIcon: Image.asset(
                                              'assets/icons/Vector.png',
                                            ),
                                            contentPadding: EdgeInsets.only(
                                                left: 8,
                                                top: errorStartDate == null
                                                    ? 0
                                                    : 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                            //ket thuc
                            (typeCommand == "SO" ||
                                    typeCommand == "TCO" ||
                                    typeCommand == "TS" ||
                                    typeCommand == "SLTP" ||
                                    typeCommand == "PRIORITYODR")
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      customTextStyleBody(
                                        text:
                                            appLocal.addCommandForm('endDate'),
                                        color: Theme.of(context)
                                            .textTheme
                                            .titleSmall!
                                            .color!,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(
                                            top: 6, bottom: 8),
                                        height: 32,
                                        width:
                                            (MediaQuery.of(context).size.width -
                                                    45) /
                                                2,
                                        child: TextField(
                                          controller: endDate,
                                          onTap: () async {
                                            DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate:
                                                  DateFormat('dd/MM/yyy')
                                                      .parse(endDate.text),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2100),
                                              builder: (BuildContext context,
                                                  Widget? child) {
                                                return Theme(
                                                  data: ThemeData.light()
                                                      .copyWith(
                                                    colorScheme:
                                                        const ColorScheme.light(
                                                      primary: Colors
                                                          .green, // Màu sắc chính
                                                    ),
                                                  ),
                                                  child: child!,
                                                );
                                              },
                                            );
                                            if (picked != null) {
                                              setState(() {
                                                endDate.text =
                                                    DateFormat('dd/MM/yyyy')
                                                        .format(picked);
                                              });
                                            }
                                          },
                                          readOnly: true,
                                          decoration: InputDecoration(
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              borderSide: BorderSide(
                                                  color: Theme.of(context)
                                                      .hintColor),
                                            ),
                                            suffixIcon: Image.asset(
                                              'assets/icons/Vector.png',
                                            ),
                                            contentPadding:
                                                const EdgeInsets.only(left: 8),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),

                        // button mua, ban
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //  Mua
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff0FB159),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: Size(
                                    (typeCommand == "SLTP")
                                        ? (MediaQuery.of(context).size.width -
                                            32)
                                        : 155.5,
                                    34),
                              ),
                              onPressed: () async {
                                if (typeCommand == "NORMAL") {
                                  if (errorGiaDat == null &&
                                      errorkhoiluong == null &&
                                      khoiluong.text.isNotEmpty &&
                                      giadat.text.isNotEmpty) {
                                    if (int.parse(khoiluong.text
                                            .replaceAll(RegExp(r','), '')) >
                                        responseInfoOrder.first.canbuyqtty) {
                                      fToast.showToast(
                                        child: msgNotification(
                                          color: Colors.red,
                                          icon: Icons.error,
                                          text:
                                              "Khối lượng phải nhỏ hơn hoặc bằng khối lượng mua tối đa",
                                        ),
                                        gravity: ToastGravity.TOP,
                                        toastDuration:
                                            const Duration(seconds: 2),
                                      );
                                    } else if (tonggiatrilenh >
                                        responseInfoOrder.first.buyingpower) {
                                      fToast.showToast(
                                        child: msgNotification(
                                          color: Colors.red,
                                          icon: Icons.error,
                                          text: "Không đủ sức mua để đặt lệnh",
                                        ),
                                        gravity: ToastGravity.TOP,
                                        toastDuration:
                                            const Duration(seconds: 2),
                                      );
                                    } else {
                                      final response = await checkFivePercent(
                                          acctno,
                                          "NB",
                                          int.parse(khoiluong.text
                                              .replaceAll(RegExp(r','), '')),
                                          currentSymbol);
                                      if (response.statusCode == 200) {
                                        if (response.data['message'] ==
                                                "Success" &&
                                            response.data['status'] == "N") {
                                          XacNhanDatLenh(context, "NB", "Mua",
                                              Colors.green);
                                        }
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      a = "Khối lượng không được để trống";
                                    });
                                  }
                                } else if (typeCommand == "SO") {
                                  if (errorGiaDat == null &&
                                      errorkhoiluong == null &&
                                      khoiluong.text.isNotEmpty &&
                                      giadat.text.isNotEmpty &&
                                      giakichhoat.text.isNotEmpty) {
                                    SOconditional(context, "NB");
                                  } else {
                                    setState(() {
                                      a = "Khối lượng không được để trống";
                                      giaKH =
                                          "Giá kích hoạt không được để trống";
                                    });
                                  }
                                } else if (typeCommand == "TCO") {
                                  if (errorGiaDat == null &&
                                      errorkhoiluong == null &&
                                      khoiluong.text.isNotEmpty &&
                                      giadat.text.isNotEmpty &&
                                      errorStartDate == null) {
                                    TCOconditional(context, "NB");
                                  } else {
                                    setState(() {
                                      a = "Khối lượng không được để trống";
                                    });
                                  }
                                } else if (typeCommand == "SLTP") {
                                  if (errorGiaDat == null &&
                                      errorkhoiluong == null &&
                                      khoiluong.text.isNotEmpty &&
                                      giadat.text.isNotEmpty &&
                                      errorStartDate == null &&
                                      errorGiaCatLo == null &&
                                      giaCatLo.text.isNotEmpty &&
                                      errorGiaChotLai == null &&
                                      giaChotLai.text.isNotEmpty) {
                                    if (biendoCatLo.text.isEmpty) {
                                      SLTPconditional(context, "NB");
                                    } else {
                                      if (double.parse(biendoCatLo.text) %
                                              0.05 !=
                                          0) {
                                        fToast.showToast(
                                          gravity: ToastGravity.TOP,
                                          toastDuration:
                                              const Duration(seconds: 2),
                                          child: msgNotification(
                                            color: Colors.red,
                                            icon: Icons.error,
                                            text:
                                                "Biên độ cắt lỗ không hợp lệ, bước giá phải là 0.05",
                                          ),
                                        );
                                      } else {
                                        SLTPconditional(context, "NB");
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      a = "Khối lượng không được để trống";
                                      validateGiaCatLo =
                                          "Cần nhập giá cắt lỗ hoặc giá chốt lãi";
                                      validateGiaChotLai =
                                          "Cần nhập giá cắt lỗ hoặc giá chốt lãi";
                                    });
                                  }
                                } else if (typeCommand == "TS") {
                                  if (errorkhoiluong == null &&
                                      khoiluong.text.isNotEmpty &&
                                      bienTruot.text.isNotEmpty &&
                                      errorBienTrout == null) {
                                    TSconditional(context, "NB");
                                  } else {
                                    setState(() {
                                      a = "Khối lượng không được để trống";
                                      validateBienTruot =
                                          "Biên trượt không được để trống.";
                                    });
                                  }
                                } else if (typeCommand == "PRIORITYODR") {
                                  if (errorkhoiluong == null &&
                                      khoiluong.text.isNotEmpty) {
                                    PRIORITYODRconditional(context, "B");
                                  } else {
                                    setState(() {
                                      a = "Khối lượng không được để trống";
                                    });
                                  }
                                }
                              },
                              child: customTextStyleBody(
                                text: appLocal.buttonForm('buyButton'),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            //  Ban
                            (typeCommand == "SLTP")
                                ? Container()
                                : ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xffDD2E15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      fixedSize: const Size(155.5, 34),
                                    ),
                                    onPressed: () async {
                                      if (typeCommand == "NORMAL") {
                                        if (errorGiaDat == null &&
                                            errorkhoiluong == null &&
                                            khoiluong.text.isNotEmpty &&
                                            giadat.text.isNotEmpty) {
                                          if (int.parse(khoiluong.text
                                                  .replaceAll(
                                                      RegExp(r','), '')) >
                                              int.parse(responseInfoOrder
                                                  .first.tradeqtty)) {
                                            fToast.showToast(
                                              child: msgNotification(
                                                color: Colors.red,
                                                icon: Icons.error,
                                                text:
                                                    "Khối lượng phải nhỏ hơn hoặc bằng khối lượng bán tối đa",
                                              ),
                                              gravity: ToastGravity.TOP,
                                              toastDuration:
                                                  const Duration(seconds: 2),
                                            );
                                          } else {
                                            final response =
                                                await checkFivePercent(
                                                    acctno,
                                                    "NS",
                                                    int.parse(khoiluong
                                                        .text
                                                        .replaceAll(
                                                            RegExp(r','), '')),
                                                    currentSymbol);
                                            if (response.statusCode == 200) {
                                              if (response.data['message'] ==
                                                      "Success" &&
                                                  response.data['status'] ==
                                                      "N") {
                                                XacNhanDatLenh(context, "NS",
                                                    "Bán", Colors.red);
                                              }
                                            }
                                          }
                                        } else {
                                          setState(() {
                                            a = "Khối lượng không được để trống";
                                          });
                                        }
                                      } else if (typeCommand == "SO") {
                                        if (errorGiaDat == null &&
                                            errorkhoiluong == null &&
                                            khoiluong.text.isNotEmpty &&
                                            giadat.text.isNotEmpty &&
                                            giakichhoat.text.isNotEmpty) {
                                          SOconditional(context, "NS");
                                        } else {
                                          setState(() {
                                            a = "Khối lượng không được để trống";
                                            giaKH =
                                                "Giá kích hoạt không được để trống";
                                          });
                                        }
                                      } else if (typeCommand == "TCO") {
                                        if (errorGiaDat == null &&
                                            errorkhoiluong == null &&
                                            khoiluong.text.isNotEmpty &&
                                            giadat.text.isNotEmpty &&
                                            errorStartDate == null) {
                                          TCOconditional(context, "NS");
                                        } else {
                                          setState(() {
                                            a = "Khối lượng không được để trống";
                                          });
                                        }
                                      } else if (typeCommand == "TS") {
                                        if (errorkhoiluong == null &&
                                            khoiluong.text.isNotEmpty &&
                                            bienTruot.text.isNotEmpty &&
                                            errorBienTrout == null) {
                                          TSconditional(context, "NS");
                                        } else {
                                          setState(() {
                                            a = "Khối lượng không được để trống";
                                            validateBienTruot =
                                                "Biên trượt không được để trống.";
                                          });
                                        }
                                      } else if (typeCommand == "PRIORITYODR") {
                                        if (errorkhoiluong == null &&
                                            khoiluong.text.isNotEmpty) {
                                          PRIORITYODRconditional(context, "S");
                                        } else {
                                          setState(() {
                                            a = "Khối lượng không được để trống";
                                          });
                                        }
                                      }
                                    },
                                    child: customTextStyleBody(
                                      text: appLocal.buttonForm('sellButton'),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          );
  }

  // lenh dung (SO):
  Future<dynamic> SOconditional(BuildContext context, String mb) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: customTextStyleBody(
            text: "Xác nhận đặt lệnh dừng",
            size: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Tài khoản",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: acctno,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Loại lệnh",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: "Stop order",
                      color: Colors.orange[800]!,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Bán/mua",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: mb == "NB" ? "Mua" : "Bán",
                      color: mb == "NB" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Mã CK",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: symbol.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Khối lượng",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: khoiluong.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Giá đặt",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: giadat.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "ĐK kích hoạt",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: (highOrlow == 0)
                          ? ">= ${giakichhoat.text}"
                          : "<= ${giakichhoat.text}",
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Ngày kết thúc",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: endDate.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              customTextStyleBody(
                text:
                    "*Lệnh được kích hoạt duy nhất 1 lần trong thời gian hiệu lực",
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                txalign: TextAlign.start,
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: customTextStyleBody(
                text: "Đóng",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
            ),
            CupertinoDialogAction(
              child: customTextStyleBody(
                text: "Xác nhận",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
              onPressed: () async {
                final response = await stopOrderCon(
                  acctno,
                  (highOrlow == 0) ? ">=" : "<=",
                  mb,
                  giakichhoat.text,
                  int.parse(khoiluong.text.replaceAll(RegExp(r','), '')),
                  giadat.text,
                  symbol.text,
                  endDate.text,
                  "O",
                );
                if (response.statusCode == 200 && response.data['code'] == 0) {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.green,
                      icon: Icons.check_circle,
                      text: response.data['msg'],
                    ),
                  );
                } else {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.red,
                      icon: Icons.error,
                      text: response.data['msg'],
                    ),
                  );
                }
                setState(() {
                  khoiluong.clear();
                  checkKhoiluongEdited = false;
                  a = null;
                  giakichhoat.clear();
                  checkGiaKhEdited = false;
                  giaKH = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> TCOconditional(BuildContext context, String mb) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: customTextStyleBody(
            text: "Xác nhận đặt lệnh trước ngày",
            size: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Tài khoản",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: acctno,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Loại lệnh",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: "TCO",
                      color: Colors.orange[800]!,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Bán/mua",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: mb == "NB" ? "Mua" : "Bán",
                      color: mb == "NB" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Mã CK",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: symbol.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Khối lượng",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: khoiluong.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Giá đặt",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: giadat.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Ngày bắt đầu",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: startDate.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Ngày kết thúc",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: endDate.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              customTextStyleBody(
                text:
                    "* Quý khách đang đặt lệnh nhiều ngày. Lệnh sẽ hết hạn khi khớp toàn bộ hoặc đến ngày hết hạn",
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                txalign: TextAlign.start,
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: customTextStyleBody(
                text: "Đóng",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
            ),
            CupertinoDialogAction(
              child: customTextStyleBody(
                text: "Xác nhận",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
              onPressed: () async {
                final response = await tcoCon(
                  acctno,
                  mb,
                  startDate.text,
                  int.parse(khoiluong.text.replaceAll(RegExp(r','), '')),
                  giadat.text,
                  symbol.text,
                  endDate.text,
                  "O",
                );
                if (response.statusCode == 200 && response.data['code'] == 0) {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.green,
                      icon: Icons.check_circle,
                      text: response.data['msg'],
                    ),
                  );
                } else {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.red,
                      icon: Icons.error,
                      text: response.data['msg'],
                    ),
                  );
                }
                setState(() {
                  khoiluong.clear();
                  checkKhoiluongEdited = false;
                  a = null;
                  giakichhoat.clear();
                  checkGiaKhEdited = false;
                  giaKH = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> SLTPconditional(BuildContext context, String mb) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: customTextStyleBody(
            text: "Xác nhận đặt lệnh cắt lỗ/ chốt lãi",
            size: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Tài khoản",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: acctno,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Loại lệnh",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: "Stop loss/Take profit",
                      color: Colors.orange[800]!,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Bán/mua",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: mb == "NB" ? "Mua" : "Bán",
                      color: mb == "NB" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Mã CK",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: symbol.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Khối lượng",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: khoiluong.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Giá đặt",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: giadat.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Giá cắt lỗ",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: giaCatLo.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Giá chốt lãi",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: giaChotLai.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Biên độ cắt lỗ",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: biendoCatLo.text.isEmpty ? "--" : biendoCatLo.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Ngày bắt đầu",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: startDate.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Ngày kết thúc",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: endDate.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              customTextStyleBody(
                text:
                    "*Lệnh được kích hoạt duy nhất 1 lần trong thời gian hiệu lực",
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                txalign: TextAlign.start,
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: customTextStyleBody(
                text: "Đóng",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
            ),
            CupertinoDialogAction(
              child: customTextStyleBody(
                text: "Xác nhận",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
              onPressed: () async {
                final response = await SLTPCon(
                    acctno,
                    int.parse(khoiluong.text.replaceAll(RegExp(r','), '')),
                    giadat.text,
                    giaCatLo.text,
                    giaChotLai.text,
                    biendoCatLo.text,
                    symbol.text,
                    endDate.text,
                    'O');
                if (response.statusCode == 200 && response.data['code'] == 0) {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.green,
                      icon: Icons.check_circle,
                      text: response.data['msg'],
                    ),
                  );
                } else {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.red,
                      icon: Icons.error,
                      text: response.data['msg'],
                    ),
                  );
                }
                setState(() {
                  khoiluong.clear();
                  checkKhoiluongEdited = false;
                  a = null;
                  giaCatLo.clear();
                  checkGiaCatLoEdited = false;
                  validateGiaCatLo = null;
                  giaChotLai.clear();
                  checkGiaChotLaiEdited = false;
                  validateGiaChotLai = null;
                  biendoCatLo.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> TSconditional(BuildContext context, String mb) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: customTextStyleBody(
            text: "Xác nhận đặt lệnh xu hướng",
            size: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Tài khoản",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: acctno,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Loại lệnh",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: "Trailing stop",
                      color: Colors.orange[800]!,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Bán/mua",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: mb == "NB" ? "Mua" : "Bán",
                      color: mb == "NB" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Mã CK",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: symbol.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Khối lượng",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: khoiluong.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Biên trượt giá",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: bienTruot.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Biên độ giá",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: bienDoGia.text.isEmpty ? "--" : bienDoGia.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Ngày kết thúc",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: endDate.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              customTextStyleBody(
                text:
                    "*Lệnh được kích hoạt duy nhất 1 lần trong thời gian hiệu lực",
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                txalign: TextAlign.start,
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: customTextStyleBody(
                text: "Đóng",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
            ),
            CupertinoDialogAction(
              child: customTextStyleBody(
                text: "Xác nhận",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
              onPressed: () async {
                final res = await tsCon(
                    acctno,
                    mb,
                    int.parse(khoiluong.text.replaceAll(RegExp(r','), '')),
                    bienDoGia.text,
                    bienTruot.text,
                    symbol.text,
                    endDate.text,
                    "O");

                if (res.statusCode == 200 && res.data['code'] == 0) {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.green,
                      icon: Icons.check_circle,
                      text: res.data['msg'],
                    ),
                  );
                } else {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.red,
                      icon: Icons.error,
                      text: res.data['msg'],
                    ),
                  );
                }
                setState(() {
                  khoiluong.clear();
                  checkKhoiluongEdited = false;
                  a = null;
                  bienTruot.clear();
                  checkBienTruotEdited = false;
                  validateBienTruot = null;
                  bienDoGia.clear();
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<dynamic> PRIORITYODRconditional(BuildContext context, String mb) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: customTextStyleBody(
            text: "Xác nhận đặt lệnh tranh mua, tranh bán",
            size: 16,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w500,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Tài khoản",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: acctno,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Loại lệnh",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: "PRIORITYODR",
                      color: Colors.orange[800]!,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Bán/mua",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: mb == "B" ? "Mua" : "Bán",
                      color: mb == "B" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Mã CK",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: symbol.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Khối lượng",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: khoiluong.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    customTextStyleBody(
                      text: "Ngày kết thúc",
                      color: Theme.of(context).textTheme.titleSmall!.color!,
                      fontWeight: FontWeight.w400,
                    ),
                    customTextStyleBody(
                      text: endDate.text,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
              ),
              customTextStyleBody(
                text:
                    "*Lệnh sẽ được kích hoạt liên tục cho đến khi lệnh khớp hết, hoặc hết ngày hiệu lực",
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w500,
                txalign: TextAlign.start,
              ),
            ],
          ),
          actions: <CupertinoDialogAction>[
            CupertinoDialogAction(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: customTextStyleBody(
                text: "Đóng",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
            ),
            CupertinoDialogAction(
              child: customTextStyleBody(
                text: "Xác nhận",
                color: Theme.of(context).secondaryHeaderColor,
                size: 16,
              ),
              onPressed: () async {
                // final res = await tsCon(
                //     acctno,
                //     mb,
                //     int.parse(khoiluong.text.replaceAll(RegExp(r','), '')),
                //     bienDoGia.text,
                //     bienTruot.text,
                //     symbol.text,
                //     endDate.text,
                //     "O");
                final res = await PROCOMconditional(
                  acctno,
                  endDate.text,
                  mb,
                  int.parse(khoiluong.text.replaceAll(RegExp(r','), '')),
                  symbol.text,
                  "O",
                );
                print(res);
                if (res.statusCode == 200) {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.green,
                      icon: Icons.check_circle,
                      text: res.data,
                    ),
                  );
                } else {
                  fToast.showToast(
                    gravity: ToastGravity.TOP,
                    toastDuration: const Duration(seconds: 2),
                    child: msgNotification(
                      color: Colors.red,
                      icon: Icons.error,
                      text: res.data,
                    ),
                  );
                }
                setState(() {
                  khoiluong.clear();
                  checkKhoiluongEdited = false;
                  a = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String? get errorkhoiluong {
    final kl = khoiluong.value.text.replaceAll(RegExp(r','), '');
    if (kl.isNotEmpty) {
      checkKhoiluongEdited = true;
    }

    int a = 0;
    if (kl.isEmpty && checkKhoiluongEdited == true) {
      return "Khối lượng không được để trống";
    } else if (kl.isNotEmpty && checkKhoiluongEdited == true) {
      a = int.parse(kl);
      if (a > 100 && a % 100 != 0) {
        return "Khối lượng nhập phải là lô chẵn hoặc lô lẻ";
      }
    }
    return null;
  }

  String? get errorGiaDat {
    final gia = giadat.value.text;

    if (gia.isEmpty) {
      return "Giá đặt không được để trống";
    } else {
      if (disabledGiaDat) {
        return null;
      } else {
        double giaDouble = double.parse(gia);
        if (giaDouble < floor || giaDouble > ceil) {
          return validateGiaDat;
        }
      }
    }
    return null;
  }

  String? get errorGiaKH {
    final gia = giakichhoat.value.text;
    if (gia.isNotEmpty) {
      checkGiaKhEdited = true;
    }
    if (gia.isEmpty && checkGiaKhEdited == true) {
      return "Giá kích hoạt không được để trống";
    }
    return null;
  }

  String? get errorStartDate {
    DateTime a = DateFormat('dd/MM/yyyy').parse(startDate.text);
    DateTime b = DateFormat('dd/MM/yyyy').parse(endDate.text);
    if (a.isAfter(b)) {
      return "Ngày bắt đầu Phải nhỏ hơn hoặc bằng ngày kết thúc";
    }
    return null;
  }

  String? get errorGiaCatLo {
    final gia = giaCatLo.value.text;
    if (gia.isNotEmpty) {
      checkGiaCatLoEdited = true;
    }
    if (gia.isEmpty && checkGiaCatLoEdited == true) {
      return "Cần nhập giá cắt lỗ hoặc giá chốt lãi";
    }
    return null;
  }

  String? get errorGiaChotLai {
    final gia = giaChotLai.value.text;
    final gia2 = giadat.value.text;
    if (gia.isNotEmpty) {
      checkGiaChotLaiEdited = true;
    }
    if (gia.isEmpty && checkGiaChotLaiEdited == true) {
      return "Cần nhập giá cắt lỗ hoặc giá chốt lãi";
    } else if (gia.isNotEmpty && checkGiaChotLaiEdited == true) {
      double a = double.parse(gia);
      double b = double.parse(gia2);
      if (a < b) {
        return "Giá chốt lãi phải lớn hơn giá đặt";
      }
    }
    return null;
  }

  String? get errorBienTrout {
    final bien = bienTruot.value.text;
    if (bien.isNotEmpty) {
      checkBienTruotEdited = true;
    }
    if (bien.isEmpty && checkBienTruotEdited) {
      return "Biên trượt không được để trống.";
    } else if (bien == "0" && checkBienTruotEdited) {
      return "Biên trượt phải khác 0.";
    }
    return null;
  }

  //lenh thuong
  Future<dynamic> XacNhanDatLenh(
    BuildContext context,
    String orderType,
    String mb,
    Color colorMB,
  ) {
    return showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState2) {
            return CupertinoAlertDialog(
              title: customTextStyleBody(
                text: "Xác nhận đặt lệnh",
                size: 18,
                color: Theme.of(context).secondaryHeaderColor,
              ),
              content: SizedBox(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    confirmInfo(
                      textTitle: "Tài khoản",
                      textContent: acctno,
                      colorContent: Theme.of(context).primaryColor,
                    ),
                    confirmInfo(
                      textTitle: "Loại lệnh",
                      textContent: mb,
                      colorContent: mb == "Mua"
                          ? const Color(0xff4FD08A)
                          : const Color(0xffF04A47),
                    ),
                    confirmInfo(
                      textTitle: "Mã CK",
                      textContent: currentSymbol,
                      colorContent: Theme.of(context).primaryColor,
                    ),
                    confirmInfo(
                      textTitle: "Khối lượng",
                      textContent: Utils().formatNumber(int.parse(
                          khoiluong.text.replaceAll(RegExp(r','), ''))),
                      colorContent: Theme.of(context).primaryColor,
                    ),
                    confirmInfo(
                      textTitle: "Giá đặt",
                      textContent: giadat.text,
                      colorContent: Theme.of(context).primaryColor,
                    ),
                    confirmInfo(
                      textTitle: "Giá trị (VND)",
                      textContent: Utils().formatNumber(tonggiatrilenh),
                      colorContent: Theme.of(context).primaryColor,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          child: customTextStyleBody(
                            text: "Mật khẩu GD",
                            color:
                                Theme.of(context).textTheme.titleSmall!.color!,
                            fontWeight: FontWeight.w400,
                            txalign: TextAlign.start,
                          ),
                        ),
                        Card(
                          color: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          elevation: 0,
                          child: SizedBox(
                            width: 88,
                            height: checkPassTransaction ? 50 : 30,
                            child: TextField(
                              obscureText: !checkObscure,
                              cursorColor: Theme.of(context).primaryColor,
                              controller: passTransaction,
                              style: const TextStyle(fontSize: 14),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  setState2(() {
                                    checkPassTransaction = false;
                                  });
                                } else {
                                  setState2(() {
                                    checkPassTransaction = true;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                errorStyle: const TextStyle(fontSize: 8),
                                errorMaxLines: 2,
                                errorText: checkPassTransaction
                                    ? passTransactionValidate
                                    : null,
                                errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: BorderSide(
                                    color: Theme.of(context).hintColor,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(left: 8, bottom: 8),
                                suffix: GestureDetector(
                                  onTap: () {
                                    setState2(() {
                                      checkObscure = !checkObscure;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      checkObscure
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      size: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Material(
                              type: MaterialType.transparency,
                              child: SizedBox(
                                width: 24,
                                height: 24,
                                child: Checkbox(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  visualDensity: VisualDensity.compact,
                                  activeColor:
                                      Theme.of(context).secondaryHeaderColor,
                                  value: savePassTransaction,
                                  onChanged: (bool? value) {
                                    setState2(() {
                                      savePassTransaction = value!;
                                      HydratedBloc.storage.write(
                                          'savePassTransaction',
                                          savePassTransaction);
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            customTextStyleBody(
                              text: "Lưu",
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ],
                    ),
                    customTextStyleBody(
                      text:
                          "* Vui lòng nhập mật khẩu giao dịch được cấp khi mở tài khoản!",
                      color: Theme.of(context).secondaryHeaderColor,
                      fontWeight: FontWeight.w400,
                      txalign: TextAlign.start,
                    ),
                  ],
                ),
              ),
              actions: <CupertinoDialogAction>[
                CupertinoDialogAction(
                  onPressed: () {
                    setState2(() {
                      checkPassTransaction = false;
                    });
                    setState(() {
                      if (savePassTransaction) {
                        HydratedBloc.storage
                            .write('passTransaction', passTransaction.text);
                      } else {
                        HydratedBloc.storage.delete('passTransaction');
                        passTransaction.clear();
                      }
                    });
                    Navigator.of(context).pop();
                  },
                  child: customTextStyleBody(
                    text: "Đóng",
                    color: Theme.of(context).secondaryHeaderColor,
                    size: 16,
                  ),
                ),
                CupertinoDialogAction(
                  child: customTextStyleBody(
                    text: "Xác nhận",
                    color: Theme.of(context).secondaryHeaderColor,
                    size: 16,
                  ),
                  onPressed: () async {
                    if (passTransaction.text.isEmpty) {
                      setState2(() {
                        checkPassTransaction = true;
                      });
                    } else {
                      setState2(() {
                        checkPassTransaction = false;
                      });
                      final response = await OrderExcute(
                        acctno,
                        orderType,
                        passTransaction.text,
                        giadat.text,
                        int.parse(khoiluong.text.replaceAll(RegExp(r','), '')),
                        currentSymbol,
                      );
                      if (response.isNotEmpty) {
                        //print(response[0]['code']);
                        print(response);
                        if (response[0] == 400) {
                          fToast.showToast(
                            gravity: ToastGravity.TOP,
                            toastDuration: const Duration(seconds: 2),
                            child: msgNotification(
                              color: Colors.red,
                              icon: Icons.error,
                              text: "Thất bại, ${response[1]}",
                            ),
                          );
                        } else if (response[0]['code'] == 200) {
                          fToast.showToast(
                            gravity: ToastGravity.TOP,
                            toastDuration: const Duration(seconds: 2),
                            child: msgNotification(
                              color: Colors.green,
                              icon: Icons.check_circle,
                              text: response[0]['msg'],
                            ),
                          );
                        } else {
                          fToast.showToast(
                            gravity: ToastGravity.TOP,
                            toastDuration: const Duration(seconds: 2),
                            child: msgNotification(
                              color: Colors.red,
                              icon: Icons.error,
                              text: "Thất bại, ${response[0]['msg']}",
                            ),
                          );
                        }
                      } else {
                        fToast.showToast(
                          gravity: ToastGravity.TOP,
                          toastDuration: const Duration(seconds: 2),
                          child: msgNotification(
                            color: Colors.red,
                            icon: Icons.error,
                            text: "Thất bại",
                          ),
                        );
                      }
                      setState(() {
                        if (savePassTransaction) {
                          HydratedBloc.storage
                              .write('passTransaction', passTransaction.text);
                        } else {
                          HydratedBloc.storage.delete('passTransaction');
                          passTransaction.clear();
                        }
                        khoiluong.clear();
                        checkKhoiluongEdited = false;
                        a = null;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }
}

// lenh thuong
class confirmInfo extends StatelessWidget {
  confirmInfo({
    super.key,
    required this.textTitle,
    required this.textContent,
    required this.colorContent,
  });

  final String textTitle;
  String textContent;
  Color colorContent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          customTextStyleBody(
            text: textTitle,
            color: Theme.of(context).textTheme.titleSmall!.color!,
            fontWeight: FontWeight.w400,
          ),
          SizedBox(
            width: 120,
            child: customTextStyleBody(
              text: textContent,
              color: colorContent,
              fontWeight: FontWeight.w500,
              txalign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
