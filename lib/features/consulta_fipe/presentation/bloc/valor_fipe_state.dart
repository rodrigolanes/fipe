import 'package:equatable/equatable.dart';

import '../../domain/entities/valor_fipe_entity.dart';

/// Estados do ValorFipeBloc
abstract class ValorFipeState extends Equatable {
  const ValorFipeState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class ValorFipeInitial extends ValorFipeState {
  const ValorFipeInitial();
}

/// Estado de carregamento
class ValorFipeLoading extends ValorFipeState {
  const ValorFipeLoading();
}

/// Estado de sucesso com valor FIPE
class ValorFipeLoaded extends ValorFipeState {
  final ValorFipeEntity valorFipe;

  const ValorFipeLoaded(this.valorFipe);

  @override
  List<Object?> get props => [valorFipe];
}

/// Estado de erro
class ValorFipeError extends ValorFipeState {
  final String message;

  const ValorFipeError(this.message);

  @override
  List<Object?> get props => [message];
}
