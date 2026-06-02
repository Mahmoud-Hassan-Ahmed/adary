import 'package:adary/core/conts/app_colors.dart';
import 'package:adary/core/enums/snack_bar_type_enum.dart';
import 'package:adary/core/share/widgets/bottom_navigator_bar.dart';
import 'package:adary/core/utils/app_utils.dart';
import 'package:adary/features/adary/data/models/note_entity_model.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/note_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/note/note_bloc.dart';
import 'package:adary/features/adary/presentation/pages/add_note_page.dart';
import 'package:adary/features/adary/presentation/widgets/notes/item_notes.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({
    super.key,
  });

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final PagingController<int, NoteModel> _pagingController =
      PagingController(firstPageKey: 1);
  late PaginationEntity entity;

  final getModel20useCase = sl<NoteUseCase>();
  @override
  void initState() {
    entity = PaginationEntity(
      page: 1,
    );
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    var result = await getModel20useCase(entity..page = pageKey);
    try {
      result.fold((l) => null, (paginationModel) {
        final isLastPage = paginationModel.next == null;
        if (isLastPage) {
          _pagingController.appendLastPage(paginationModel.results);
        } else {
          _pagingController.appendPage(paginationModel.results, pageKey + 1);
        }
      });
    } catch (error) {
      _pagingController.error = error;
      AppUtils.log(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NoteBloc>(),
      child: BlocBuilder<NoteBloc, NoteState>(
        builder: (context, state) {
          if (state is DoneDeleteNoteState) {
            AppUtils.showCustomSnackbar(
                'deleted_health'.tr(), SnackType.SUCESS);
            _pagingController.refresh();
          }
          return SafeArea(
            child: Scaffold(
              // bottomNavigationBar: BottomNavigatorBar(items: [
              //   ElevatedButton(
              //     onPressed: () {
              //       showModalBottomSheet(
              //         isScrollControlled: true,
              //         context: context,
              //         builder: (context) {
              //           return FractionallySizedBox(
              //             child: AddNotePage(
              //               pagingController: _pagingController,
              //             ),
              //           );
              //         },
              //       );
              //     },
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.black,
              //       elevation: 4,
              //     ),
              //     child: Text(
              //       'new_note'.tr(),
              //       style: const TextStyle(color: Colors.white),
              //     ),
              //   ),
              // ]),

              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'nots_list'.tr(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.checkbox),
                    ),
                  ),
                  Expanded(
                    child: PagedListView<int, NoteModel>(
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        pagingController: _pagingController,
                        builderDelegate: PagedChildBuilderDelegate<NoteModel>(
                            noItemsFoundIndicatorBuilder: (context) => Center(
                                  child: Image.asset('assets/images/add.png'),
                                ),
                            itemBuilder: (context, item, index) {
                              return ItemNotes(
                                visitModel: item,
                                pagingController: _pagingController,
                              );
                            })),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
