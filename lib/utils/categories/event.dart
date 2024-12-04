part of "./bloc.dart";

class CategoriesEvent extends Equatable {
  const CategoriesEvent();
  @override
  get props => [];
}

class AddCategoryEvent extends CategoriesEvent {
  const AddCategoryEvent(this.value);
  final CategoryData value;

  @override
  get props => [value];
}

class DeleteCategoryEvent extends CategoriesEvent {
  const DeleteCategoryEvent(this.value);
  final CategoryData value;

  @override
  get props => [value];
}

class SaveCategoriesEvent extends CategoriesEvent {
  const SaveCategoriesEvent();

  @override
  get props => [];
}

class LoadCategoriesEvent extends CategoriesEvent {
  const LoadCategoriesEvent();

  @override
  get props => [];
}

class UndoCategoriesEvent extends CategoriesEvent {
  const UndoCategoriesEvent();

  @override
  get props => [];
}
