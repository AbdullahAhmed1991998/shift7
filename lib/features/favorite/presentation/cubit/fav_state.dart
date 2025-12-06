part of 'fav_cubit.dart';

class FavState extends Equatable {
  final ApiStatus favStatus;
  final WishlistResponseModel? favList;
  final String errorMessage;
  final ApiStatus setFavStatus;
  final List<dynamic> favItems;
  final bool favLoadingMore;
  final bool favHasMore;
  final int favCurrentPage;

  const FavState({
    this.favStatus = ApiStatus.initial,
    this.setFavStatus = ApiStatus.initial,
    this.favList,
    this.errorMessage = '',
    this.favItems = const [],
    this.favLoadingMore = false,
    this.favHasMore = true,
    this.favCurrentPage = 0,
  });

  factory FavState.initial() {
    return const FavState();
  }

  FavState copyWith({
    ApiStatus? favStatus,
    WishlistResponseModel? favList,
    String? errorMessage,
    ApiStatus? setFavStatus,
    List<dynamic>? favItems,
    bool? favLoadingMore,
    bool? favHasMore,
    int? favCurrentPage,
  }) {
    return FavState(
      favStatus: favStatus ?? this.favStatus,
      favList: favList ?? this.favList,
      errorMessage: errorMessage ?? this.errorMessage,
      setFavStatus: setFavStatus ?? this.setFavStatus,
      favItems: favItems ?? this.favItems,
      favLoadingMore: favLoadingMore ?? this.favLoadingMore,
      favHasMore: favHasMore ?? this.favHasMore,
      favCurrentPage: favCurrentPage ?? this.favCurrentPage,
    );
  }

  @override
  List<Object?> get props => [
    favStatus,
    favList,
    errorMessage,
    setFavStatus,
    favItems,
    favLoadingMore,
    favHasMore,
    favCurrentPage,
  ];
}
