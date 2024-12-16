import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raskop_fe_backoffice/shared/const.dart';
import 'package:raskop_fe_backoffice/src/menu/presentation/widgets/switch_widget.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  static const String route = 'menu';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: hexToColor('#1f4940')),
                    onPressed: () => {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 10.h),
                      child: Text(
                        "Tambah",
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
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.white,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 15.h),
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
                        flex: 4,
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
                        flex: 3,
                        child: Text(
                          'KATEGORI',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: hexToColor('#202224'),
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'HARGA',
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
                            'JUMLAH',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: hexToColor('#202224'),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Center(
                          child: Text(
                            'DESKRIPSI, GAMBAR',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: hexToColor('#202224'),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Center(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: hexToColor('#47B881'),
                                shape: BoxShape.circle,
                              ),
                            ),
                            SizedBox(width: 5),
                            Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: hexToColor('#F64C4C'),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        )),
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
                        border: Border.all(color: Colors.grey, width: 1),
                        borderRadius: BorderRadius.circular(18),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 8.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              flex: 4,
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
                              flex: 3,
                              child: Text(
                                'Mocktail',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: hexToColor('#202224'),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Rp80.000,00',
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
                                child: Text(
                                  '4',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: hexToColor('#202224'),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 28.h),
                                  child: TextButton(
                                    onPressed: () {},
                                    style: TextButton.styleFrom(
                                      backgroundColor: hexToColor('#f6e9e0'),
                                      minimumSize: Size(double.infinity, 40),
                                    ),
                                    child: Text(
                                      'Lihat',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: hexToColor('#E38D5D'),
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: CustomSwitch(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
