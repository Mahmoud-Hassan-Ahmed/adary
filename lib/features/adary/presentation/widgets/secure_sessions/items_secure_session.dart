import 'package:adary/core/bloc/base_bloc.dart';
import 'package:adary/features/adary/data/models/requests_model.dart';
import 'package:adary/features/adary/domain/entities/change_status_entity.dart';
import 'package:adary/features/adary/domain/entities/pagination_entity.dart';
import 'package:adary/features/adary/domain/usecases/get_requests_use_case.dart';
import 'package:adary/features/adary/presentation/bloc/scure_session.dart/secure_session_bloc.dart'
    show
        ChangeStatusEvent,
        SecureSessionBloc,
        SecureSessionState,
        ChangeStatusDone;
import 'package:adary/features/adary/presentation/widgets/secure_sessions/card_secure_session.dart';
import 'package:adary/features/adary/presentation/widgets/text/label_main_text.dart';
import 'package:adary/injections/injection_main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../core/utils/app_utils.dart';

class ItemsSecureSession extends StatefulWidget {
  const ItemsSecureSession({super.key, required this.status});
  final RequestStatus status;

  @override
  State<ItemsSecureSession> createState() => _ItemsSecureSessionState();
}

class _ItemsSecureSessionState extends State<ItemsSecureSession> {
  final PagingController<int, LeaveRequestModel> _pagingController =
      PagingController(firstPageKey: 1);
  final entity = PaginationEntity(page: 1);
  final getRequestsUseCase = sl<GetRequestsUseCase>();
  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    var result = await getRequestsUseCase(entity
      ..page = pageKey
      ..teacher = widget.status.name);
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
    return BlocBuilder<SecureSessionBloc, SecureSessionState>(
      builder: (context, state) {
        if (state is ChangeStatusDone) {
          _pagingController.refresh();
        }
        return PagedListView<int, LeaveRequestModel>(
            padding: const EdgeInsets.all(10),
            physics: const BouncingScrollPhysics(),
            pagingController: _pagingController,
            builderDelegate: PagedChildBuilderDelegate<LeaveRequestModel>(
                noItemsFoundIndicatorBuilder: (context) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/add.png'),
                          const SizedBox(
                            height: 10,
                          ),
                          const LabelMainText(
                            text: 'لا يوجد طلبات للعرض',
                            color: Colors.black,
                          )
                        ],
                      ),
                    ),
                itemBuilder: (context, item, index) {
                  return LeaveRequestCard(
                    leaveRequestModel: item,
                    status: widget.status,
                    onAccept: () {
                      BaseBloc.get<SecureSessionBloc>(context).add(
                          ChangeStatusEvent(
                              entity: ChangeStatusEntity(
                                  id: item.id,
                                  status: RequestStatus.accepted.name)));
                    },
                    onReject: () {
                      BaseBloc.get<SecureSessionBloc>(context).add(
                          ChangeStatusEvent(
                              entity: ChangeStatusEntity(
                                  id: item.id,
                                  status: RequestStatus.rejected.name)));
                    },
                  );
                }));
      },
    );
  }
}
