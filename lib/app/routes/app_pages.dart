import 'package:get/get.dart';

import '../modules/detail_kelas/bindings/detail_kelas_binding.dart';
import '../modules/detail_kelas/views/detail_kelas_view.dart';
import '../modules/detail_presensi/bindings/detail_presensi_binding.dart';
import '../modules/detail_presensi/views/detail_presensi_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/lis_kelas/bindings/lis_kelas_binding.dart';
import '../modules/lis_kelas/views/lis_kelas_view.dart';
import '../modules/lis_presensi/bindings/lis_presensi_binding.dart';
import '../modules/lis_presensi/views/lis_presensi_view.dart';
import '../modules/lis_user/bindings/lis_user_binding.dart';
import '../modules/lis_user/views/lis_user_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile_admin/bindings/profile_admin_binding.dart';
import '../modules/profile_admin/views/profile_admin_view.dart';
import '../modules/reset_password/bindings/reset_password_binding.dart';
import '../modules/reset_password/views/reset_password_view.dart';
import '../modules/riwayat_presensi/bindings/riwayat_presensi_binding.dart';
import '../modules/riwayat_presensi/views/riwayat_presensi_view.dart';
import '../modules/tambah_kelas/bindings/tambah_kelas_binding.dart';
import '../modules/tambah_kelas/views/tambah_kelas_view.dart';
import '../modules/tambah_user/bindings/tambah_user_binding.dart';
import '../modules/tambah_user/views/tambah_user_view.dart';
import '../modules/ubah_password/bindings/ubah_password_binding.dart';
import '../modules/ubah_password/views/ubah_password_view.dart';
import '../modules/ubahprofile/bindings/ubahprofile_binding.dart';
import '../modules/ubahprofile/views/ubahprofile_view.dart';
import '../modules/ubahprofile_admin/bindings/ubahprofile_admin_binding.dart';
import '../modules/ubahprofile_admin/views/ubahprofile_admin_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
        name: _Paths.HOME,
        page: () => HomeView(),
        binding: HomeBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.LOGIN,
        page: () => LoginView(),
        binding: LoginBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.PROFILE,
        page: () => ProfileView(),
        binding: ProfileBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.HOME_ADMIN,
        page: () => HomeAdminView(),
        binding: HomeAdminBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.PROFILE_ADMIN,
        page: () => ProfileAdminView(),
        binding: ProfileAdminBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.RESET_PASSWORD,
        page: () => ResetPasswordView(),
        binding: ResetPasswordBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.TAMBAH_USER,
        page: () => TambahUserView(),
        binding: TambahUserBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.UBAH_PASSWORD,
        page: () => UbahPasswordView(),
        binding: UbahPasswordBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.TAMBAH_KELAS,
        page: () => TambahKelasView(),
        binding: TambahKelasBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.LIS_USER,
        page: () => LisUserView(),
        binding: LisUserBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.LIS_KELAS,
        page: () => LisKelasView(),
        binding: LisKelasBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.RIWAYAT_PRESENSI,
        page: () => RiwayatPresensiView(),
        binding: RiwayatPresensiBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.UBAHPROFILE,
        page: () => UbahprofileView(),
        binding: UbahprofileBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.UBAHPROFILE_ADMIN,
        page: () => UbahprofileAdminView(),
        binding: UbahprofileAdminBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.LIS_PRESENSI,
        page: () => LisPresensiView(),
        binding: LisPresensiBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
        name: _Paths.DETAIL_PRESENSI,
        page: () => DetailPresensiView(),
        binding: DetailPresensiBinding(),
        transition: Transition.fadeIn,
        transitionDuration: Duration(milliseconds: 300)),
    GetPage(
      name: _Paths.DETAIL_KELAS,
      page: () => DetailKelasView(),
      binding: DetailKelasBinding(),
      transition: Transition.fadeIn,
      transitionDuration: Duration(milliseconds: 300)),
  ];
}
