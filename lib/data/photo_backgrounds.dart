/// Fundos-foto GRÁTIS do editor de imagem (seção "Fotos" da tela Criar).
///
/// Curadoria PAIXÃO/CLIMA QUENTE para o tema de cantadas: pôr do sol, luzes de
/// cidade à noite, entardecer dourado e cenários românticos (sem pessoas, tom
/// quente). Vêm do Lorem Picsum (fotos do Unsplash — licença livre p/ uso
/// comercial). São cacheadas em disco: depois de abertas 1x, seguem offline.
class PhotoBackground {
  const PhotoBackground(this.id, {this.pexels = false});

  /// Id estável da foto (Picsum por padrão; Pexels quando [pexels] = true).
  final String id;

  /// Se true, a foto vem do Pexels. Senão, Lorem Picsum.
  final bool pexels;

  /// Imagem em alta para o fundo do cartão (story 9:16).
  String get full => pexels
      ? 'https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&w=1080&h=1920&fit=crop'
      : 'https://picsum.photos/id/$id/1080/1920';

  /// Miniatura leve para o seletor.
  String get thumb => pexels
      ? 'https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&w=160&h=240&fit=crop'
      : 'https://picsum.photos/id/$id/160/240';
}

/// Catálogo curado — clima romântico/quente (as mais "cantada" primeiro).
const photoBackgrounds = <PhotoBackground>[
  // ---- Pôr do sol / entardecer (romântico) ----
  PhotoBackground('1057'), // costa ao pôr do sol
  PhotoBackground('1053'), // pôr do sol no mar
  PhotoBackground('1016'), // cânion no fim de tarde
  PhotoBackground('1072'), // deserto ao entardecer
  PhotoBackground('1015'), // fiorde ao entardecer
  PhotoBackground('1084'), // costa e farol
  PhotoBackground('1075'), // praia e falésias
  PhotoBackground('1054'), // ilha e mar
  PhotoBackground('1049'), // praia tropical
  PhotoBackground('1065'), // vista aérea da costa
  // ---- Luzes de cidade à noite (clima de date) ----
  PhotoBackground('1002'), // cidade à noite
  PhotoBackground('1048'), // cidade e ponte iluminada
  PhotoBackground('1050'), // cidade litorânea
  PhotoBackground('1076'), // horizonte urbano
  // ---- Dourado / quente ----
  PhotoBackground('1062'), // outono dourado
  PhotoBackground('1031'), // campo dourado
  PhotoBackground('1080'), // vinhedos
  PhotoBackground('1074'), // campo aberto
  PhotoBackground('1073'), // dunas quentes
  PhotoBackground('1056'), // vale ensolarado
  PhotoBackground('1051'), // cais no lago ao entardecer
  PhotoBackground('1060'), // cais e lago
  PhotoBackground('1055'), // lago ao amanhecer
  PhotoBackground('1013'), // costa rochosa
];
