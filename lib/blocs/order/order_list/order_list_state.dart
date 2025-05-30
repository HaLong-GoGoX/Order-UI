import 'package:order_ui/models/order.dart';

class OrderListState {
  final List<Order> orders;
  final bool isLoading;
  final bool hasMore;
  final String? errorMessage;
  final String filter;

  OrderListState({
    this.orders = const [],
    this.isLoading = false,
    this.hasMore = true,
    this.errorMessage,
    this.filter = 'all',
  });

  OrderListState copyWith({
    List<Order>? orders,
    bool? isLoading,
    bool? hasMore,
    String? errorMessage,
    String? filter,
  }) {
    return OrderListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage ?? this.errorMessage,
      filter: filter ?? this.filter,
    );
  }
}
