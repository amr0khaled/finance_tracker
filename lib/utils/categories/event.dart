part of "./bloc.dart";

class CategoryEvent extends Equatable {
  const CategoryEvent();
  @override
  get props => [];
}

class CategoriesEvent extends Equatable {
  const CategoriesEvent();
  @override
  get props => [];
}

class AddCategoryEvent extends CategoriesEvent {
  const AddCategoryEvent(this.value);
  final String value;

  @override
  get props => [value];
}

class DeleteCategoryEvent extends CategoriesEvent {
  const DeleteCategoryEvent(this.value);
  final String value;

  @override
  get props => [];
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

class EditCategoryEvent extends CategoryEvent {
  const EditCategoryEvent(this.newValue);
  final String newValue;

  @override
  List<Object?> get props => [newValue];
}
