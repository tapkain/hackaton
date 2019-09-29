import 'package:flutter/material.dart';
import 'dart:async';


typedef PaginatedListPredicate<T> = bool Function(T value);

abstract class PaginatedListEvent<T> {}

class PaginatedListRefresh<T> extends PaginatedListEvent<T> {
  final bool isLoading;

  PaginatedListRefresh({this.isLoading = true});
}

class PaginatedListClean<T> extends PaginatedListEvent<T> {}

class PaginatedListLoadNext<T> extends PaginatedListEvent<T> {}

class PaginatedListAdd<T> extends PaginatedListEvent<T> {
  final T value;

  PaginatedListAdd({this.value});
}

class PaginatedListUpdate<T> extends PaginatedListEvent<T> {
  final T value;
  final PaginatedListPredicate<T> predicate;

  PaginatedListUpdate({this.value, this.predicate});
}

class PaginatedListDelete<T> extends PaginatedListEvent<T> {
  final PaginatedListPredicate<T> predicate;

  PaginatedListDelete({this.predicate});
}

abstract class PaginatedListState<T> {}

class PaginatedListEmpty<T> extends PaginatedListState<T> {}

class PaginatedListLoaded<T> extends PaginatedListState<T> {
  final bool hasReachedEnd;
  final List<T> list;

  int get length =>
      hasReachedEnd != null && hasReachedEnd ? list.length : list.length + 1;

  PaginatedListLoaded({this.hasReachedEnd, this.list});
}

class PaginatedListLoading<T> extends PaginatedListState<T> {}

class PaginatedListController<T> {
  var _currentPage = 0;
  var _hasReachedEnd = false;
  var _isFetching = false;
  List<T> _cachedModels = [];

  List<T> get cache => _cachedModels;
  final scrollController = ScrollController();

  Function fetchPage;
  final int maxPage;
  final int pageSize;
  Function uniquePredicate;

  final _eventStream = StreamController<PaginatedListEvent<T>>.broadcast();
  final _stateStream = StreamController<PaginatedListState<T>>.broadcast();
  PaginatedListState<T> currentState = PaginatedListLoading<T>();

  Stream<PaginatedListState<T>> get stateChanged => _stateStream.stream;
  StreamSubscription<PaginatedListEvent<T>> _eventListener;

  List<T> makeUnique<T>(List<T> list, Function predicate) {
    final unique = list.map((p) => predicate(p)).toSet().toList();
    return list
        .where(
            (p) => unique.contains(predicate(p)) && unique.remove(predicate(p)))
        .toList();
  }

  PaginatedListController({
    this.fetchPage,
    this.maxPage,
    this.uniquePredicate,
    this.pageSize = 20,
  }) {
    if (uniquePredicate == null) {
      uniquePredicate = (p) => p.id;
    }

    _eventListener = _eventStream.stream.listen((event) {
      if (event is PaginatedListClean<T>) {
        _currentPage = 0;
        _hasReachedEnd = false;
        _isFetching = false;
        _cachedModels = [];
        currentState = PaginatedListLoading<T>();
      }

      if (event is PaginatedListRefresh<T>) {
        _cachedModels = [];
        _hasReachedEnd = false;
        _currentPage = 0;
        _isFetching = false;

        if (event.isLoading) {
          _dispatchState(PaginatedListLoading<T>());
        }

        _loadNextPage(refresh: true);
      }

      if (event is PaginatedListLoadNext<T>) {
        _loadNextPage();
      }

      if (event is PaginatedListAdd<T>) {
        _cachedModels.insert(0, event.value);
        _cachedModels = makeUnique(_cachedModels, uniquePredicate);
        _dispatchState(
          PaginatedListLoaded<T>(
            hasReachedEnd: _hasReachedEnd,
            list: _cachedModels,
          ),
        );
      }

      if (event is PaginatedListDelete<T>) {
        _cachedModels.removeWhere(event.predicate);
        if (_cachedModels.length == 0) {
          _dispatchState(PaginatedListEmpty<T>());
        } else {
          _dispatchState(
            PaginatedListLoaded<T>(
              hasReachedEnd: _hasReachedEnd,
              list: _cachedModels,
            ),
          );
        }
      }

      if (event is PaginatedListUpdate<T>) {
        final index = _cachedModels.indexWhere(event.predicate);
        _cachedModels.removeAt(index);
        _cachedModels.insert(index, event.value);
        _dispatchState(
          PaginatedListLoaded<T>(
            hasReachedEnd: _hasReachedEnd,
            list: _cachedModels,
          ),
        );
      }
    });
  }

  bool handleScrollNotification(ScrollNotification notification) {
    if (scrollController.positions.isEmpty) {
      return true;
    }

    if (scrollController.position.extentBefore < 1500) {
      return true;
    }

    if (scrollController.position.extentAfter < 2000) {
      _loadNextPage();
    }

    return true;
  }

  _loadNextPage({bool refresh = false}) async {
    if (_hasReachedEnd || _isFetching) {
      return;
    }

    _isFetching = true;
    final models = await fetchPage(_currentPage, refresh);
    _cachedModels.addAll(models);
    _isFetching = false;

    if (models.length == 0 && _cachedModels.length == 0) {
      _dispatchState(PaginatedListEmpty<T>());
    } else if (models.length < pageSize && _currentPage == 0) {
      _hasReachedEnd = true;
      _cachedModels = makeUnique(_cachedModels, uniquePredicate);
      _dispatchState(
        PaginatedListLoaded<T>(
          hasReachedEnd: _hasReachedEnd,
          list: _cachedModels,
        ),
      );
    } else {
      _currentPage++;
      _hasReachedEnd = models.length == 0;
      if (maxPage != null && !_hasReachedEnd) {
        _hasReachedEnd = _currentPage >= maxPage;
      }

      _cachedModels = makeUnique(_cachedModels, uniquePredicate);
      _dispatchState(
        PaginatedListLoaded<T>(
          hasReachedEnd: _hasReachedEnd,
          list: _cachedModels,
        ),
      );
    }
  }

  void dispatch(PaginatedListEvent<T> event) {
    if (_eventStream.isClosed) {
      return;
    }
    _eventStream.add(event);
  }

  void _dispatchState(PaginatedListState<T> state) {
    if (_stateStream.isClosed) {
      return;
    }
    _stateStream.add(state);
  }

  Future<void> dispose() async {
    scrollController.dispose();
    await _eventListener.cancel();
    await _eventStream.close();
    await _stateStream.close();
  }
}

class PaginatedList<T> extends StatefulWidget {
  final PaginatedListController<T> controller;
  final Function builder;
  final double top;
  final double bottom;
  final Key key;
  final bool reverse;
  final int pageSize;

  PaginatedList({
    this.controller,
    this.builder,
    this.top = 0.0,
    this.bottom = 80.0,
    this.key,
    this.reverse = false,
    this.pageSize = 20,
  });

  @override
  _PaginatedListState createState() => _PaginatedListState<T>();
}

class _PaginatedListState<T> extends State<PaginatedList> {
  StreamSubscription<PaginatedListState<T>> _onStateChanged;

  @override
  void initState() {
    if (widget.controller.currentState is PaginatedListLoading<T>) {
      Future.delayed(Duration(milliseconds: 100), () {
        widget.controller.dispatch(PaginatedListLoadNext<T>());
      });
    }

    _onStateChanged = widget.controller.stateChanged.listen((state) {
      setState(() {
        widget.controller.currentState = state;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _onStateChanged.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildBody(context);
  }

  Widget _buildBody(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: widget.controller.handleScrollNotification,
      child: RefreshIndicator(
        onRefresh: () {
          widget.controller.dispatch(PaginatedListRefresh<T>(isLoading: false));
          return Future.delayed(Duration(seconds: 3));
        },
        child: widget.controller.currentState is PaginatedListLoaded<T>
            ? _buildList(widget.controller.currentState)
            : ListView(children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.5,
                ),
                _buildStates(),
              ]),
      ),
    );
  }

  Widget _buildStates() {
    final theme = Theme.of(context);
    if (widget.controller.currentState is PaginatedListEmpty<T>) {
      return Center(
        child: Text(
          'EMPTY',
          style: theme.textTheme.display1.apply(color: Colors.white),
        ),
      );
    }

    if (widget.controller.currentState is PaginatedListLoading<T>) {
      return Center(child: CircularProgressIndicator());
    }

    return Container();
  }

  Widget _buildList(PaginatedListLoaded<T> state) {
    return ListView.builder(
      reverse: widget.reverse,
      controller: widget.controller.scrollController,
      physics: BouncingScrollPhysics(),
      itemCount: state.length + 2,
      itemBuilder: (context, index) {
        if (index == 0) {
          return SizedBox(height: widget.top);
        }

        index -= 1;

        if (index > state.list.length) {
          return _buildPageLoadingRow();
        }

        if (index == state.list.length &&
            state.hasReachedEnd &&
            state.list.length < widget.pageSize) {
          return SizedBox(height: MediaQuery.of(context).size.height);
        }

        if (index == state.list.length) {
          return SizedBox(height: widget.bottom);
        }

        return widget.builder(context, state.list[index]);
      },
    );
  }

  Widget _buildPageLoadingRow() {
    return Container(
      padding: EdgeInsets.all(8),
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }
}
