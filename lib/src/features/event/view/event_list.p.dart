import 'package:flutter/material.dart';
import 'package:prototype/src/features/event/model/event_list.st.dart';
import 'package:prototype/src/features/event/view/di/event_list.vm.dart';
import 'package:prototype/src/view_model/view.abs.dart';
import 'package:prototype/src/widgets/card_event.dart';
import 'package:prototype/src/widgets/loading.dart';

class EventListPage extends View<EventListViewModel> {
  const EventListPage({required EventListViewModel viewModel, Key? key})
      : super.model(viewModel, key: key);

  @override
  _EventListPage createState() => _EventListPage(viewModel);
}

class _EventListPage extends ViewState<EventListPage, EventListViewModel> {
  _EventListPage(super.viewModel);

  @override
  void initState() {
    super.initState();
    listenToRoutesSpecs(viewModel.routes);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    viewModel.getEvents();
  }

  @override
  void didPopNext() {
    super.didPopNext();
    viewModel.getEvents();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EventListState>(
        stream: viewModel.state,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final state = snapshot.data!;

          return Stack(
            children: [
              Scaffold(
                appBar: AppBar(
                  title: Text(
                    'Event Party',
                    style: Theme.of(context).textTheme.headlineSmall?.merge(
                          const TextStyle(color: Colors.white),
                        ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () => viewModel.goToCreateEvent(),
                      icon: const Icon(Icons.add),
                    )
                  ],
                ),
                body: SafeArea(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2
                    ), 
                    itemBuilder: (context, index) {
                      return CardEvent(
                        eventName: state.events[index].name ?? "",
                      );
                    },
                    itemCount: state.events.length,
                  )
                ),
              ),
              Visibility(
                visible: state.isLoading,
                child: const Loading(),
              ),
            ],
          );
        });
  }
}
