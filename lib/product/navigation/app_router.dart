import 'package:auto_route/auto_route.dart';
import 'package:edumind_intro_app/feature/auth/questionnaire/view/questionnaire_view.dart';
import 'package:edumind_intro_app/feature/book/book_list_view.dart';
import 'package:edumind_intro_app/feature/book/book_view.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: AppRouter._replaceRouteName)

/// Project is using [AutoRoute] for navigation
final class AppRouter extends RootStackRouter {
  /// [AppRouter] constructor
  static const _replaceRouteName = 'View,Route';

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: QuestionnaireRoute.page,
        ),
        AutoRoute(
          page: BookRoute.page,
          fullscreenDialog: true,
        ),
        AutoRoute(
          page: BookListRoute.page,
        ),
      ];
}
