import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/eva.dart';
import 'package:raskop_fe_backoffice/res/strings.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/order/presentation/screens/create_order_screen.dart';
import 'package:raskop_fe_backoffice/src/supplier/presentation/widgets/positioned_directional_backdrop_blur_widget.dart';

///
class OrderScreen extends StatefulWidget {
  ///
  const OrderScreen({super.key});

  ///
  static const String route = 'order';

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isCreating = false;
  bool isDetailPanelVisible = false;
  @override
  Widget build(BuildContext context) {
    void toggleDetailPanel() {
      setState(() {
        isDetailPanelVisible = !isDetailPanelVisible;
      });
    }

    void toggleCreateScreen() {
      setState(() {
        isCreating = !isCreating;
      });
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: isCreating
          ? CreateOrderScreen(
              onBack: toggleCreateScreen,
            )
          : Scaffold(
              body: Stack(
                children: [
                  AnimatedContainer(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: hexToColor('#1f4940'),
                              ),
                              onPressed: toggleCreateScreen,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                child: const Text(
                                  AppStrings.tambahBtn,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 12.h, bottom: 7.h),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 15.h,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'ID',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#202224'),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'ID RESERVASI',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#202224'),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'NAMA',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#202224'),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'KONTAK',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: hexToColor('#202224'),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Text(
                                      'DETAIL ORDER',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: hexToColor('#202224'),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: 20,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(bottom: 7.h),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(18),
                                  color: hexToColor('#E1E1E1'),
                                ),
                                child: Slidable(
                                  endActionPane: ActionPane(
                                    extentRatio: 0.08,
                                    motion: const BehindMotion(),
                                    children: [
                                      Expanded(
                                        child: SizedBox.expand(
                                          child: GestureDetector(
                                            onTap: () {},
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.only(
                                                  topRight: Radius.circular(15),
                                                  bottomRight:
                                                      Radius.circular(15),
                                                ),
                                                color: hexToColor('#E1E1E1'),
                                              ),
                                              child: Center(
                                                child: Container(
                                                  width: 25.w,
                                                  height: 28.h,
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(30),
                                                    ),
                                                    color:
                                                        hexToColor('#F64C4C'),
                                                  ),
                                                  child: const Iconify(
                                                    Eva.trash_fill,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(18),
                                      color: Colors.white,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10.w,
                                      vertical: 8.h,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '00001',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '00005',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            'Christine Brooks',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            '+621234567890',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: hexToColor('#202224'),
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Center(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.h,
                                              ),
                                              child: TextButton(
                                                onPressed: toggleDetailPanel,
                                                style: TextButton.styleFrom(
                                                  backgroundColor:
                                                      hexToColor('#f6e9e0'),
                                                  minimumSize: const Size(
                                                    double.infinity,
                                                    40,
                                                  ),
                                                ),
                                                child: Text(
                                                  'Lihat',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        hexToColor('#E38D5D'),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  PositionedDirectionalBackdropBlurWidget(
                    isPanelVisible: isDetailPanelVisible,
                    end: -MediaQuery.of(context).size.width * 0.3,
                    content: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: IconButton(
                          padding: const EdgeInsets.all(10),
                          color: hexToColor('#1F4940'),
                          icon: const Icon(Icons.arrow_back),
                          onPressed: toggleDetailPanel,
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: ListView.builder(
                          itemCount: 3,
                          itemBuilder: (ctx, idx) {
                            return Card.filled(
                              margin: EdgeInsets.only(bottom: 15.h),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                              ),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 10.h,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'ID : 00001',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black,
                                        fontSize: 8.sp,
                                        overflow: TextOverflow.fade,
                                      ),
                                    ),
                                    const Divider(),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Nama Menu : \t ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black26,
                                              fontSize: 9.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Mocktail',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 9.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Catt : \t\t\t',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black26,
                                              fontSize: 8.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                              width: 33.w,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Jangan pakai es',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 8.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Jumlah : \t',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black26,
                                              fontSize: 8.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                              width: 25.w,
                                            ),
                                          ),
                                          TextSpan(
                                            text: '2',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 8.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: 'Subtotal : \t',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black26,
                                              fontSize: 8.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                          WidgetSpan(
                                            child: SizedBox(
                                              width: 22.w,
                                            ),
                                          ),
                                          TextSpan(
                                            text: 'Rp50.000,00',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: Colors.black,
                                              fontSize: 8.sp,
                                              overflow: TextOverflow.fade,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Card.filled(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        color: Colors.white,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10.w,
                            vertical: 12.h,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Grand Total : \t ',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black26,
                                  fontSize: 8.sp,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Rp150.000,00',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black,
                                  fontSize: 8.sp,
                                  overflow: TextOverflow.fade,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    width: MediaQuery.of(context).size.width * 0.3,
                  ),
                ],
              ),
            ),
    );
  }
}
