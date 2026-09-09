/// Fundos-foto GRÁTIS do editor de imagem (seção "Fotos" da tela Criar).
///
/// As imagens vêm do Lorem Picsum (fotos do Unsplash — licença livre para uso
/// comercial: https://unsplash.com/license). Os ids foram CURADOS manualmente
/// (conferidos um a um): só paisagens/natureza, nada de pessoas/animais que
/// altere a classificação do app.
///
/// São carregadas da internet e cacheadas no disco pelo `cached_network_image`.
/// Depois de abertas 1x, seguem disponíveis mesmo SEM internet.
class PhotoBackground {
  const PhotoBackground(this.id, {this.pexels = false});

  /// Id estável da foto (Picsum por padrão; Pexels quando [pexels] = true).
  final String id;

  /// Se true, a foto vem do Pexels (fotos de pessoas/amizade, licença grátis
  /// para uso comercial: https://www.pexels.com/license/). Senão, Lorem Picsum
  /// (paisagens/natureza).
  final bool pexels;

  /// Imagem em alta para o fundo do cartão (story 9:16, com folga para os
  /// formatos quadrado/retrato via BoxFit.cover).
  String get full => pexels
      ? 'https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&w=1080&h=1920&fit=crop'
      : 'https://picsum.photos/id/$id/1080/1920';

  /// Miniatura leve para o seletor.
  String get thumb => pexels
      ? 'https://images.pexels.com/photos/$id/pexels-photo-$id.jpeg?auto=compress&cs=tinysrgb&w=160&h=240&fit=crop'
      : 'https://picsum.photos/id/$id/160/240';
}

/// Catálogo curado de fundos-foto. Primeiro PESSOAS & AMIZADE (Pexels), depois
/// paisagens/natureza (Picsum). Facilmente ampliável.
const photoBackgrounds = <PhotoBackground>[
  // ---- PESSOAS & AMIZADE (Pexels, licença livre p/ uso comercial) ----
  PhotoBackground('12801971', pexels: true), // amigos felizes juntos
  PhotoBackground('3756513', pexels: true),  // grupo de pessoas sorrindo
  PhotoBackground('19471610', pexels: true), // grupo de amigos sorrindo
  PhotoBackground('9287491', pexels: true),  // grupo de amigos rindo
  PhotoBackground('9353491', pexels: true),  // amigos se abraçando em grupo
  PhotoBackground('7148409', pexels: true),  // amigos rindo juntos
  PhotoBackground('10549083', pexels: true), // amigos no sofá rindo
  PhotoBackground('4746216', pexels: true),  // dois amigos sorrindo
  PhotoBackground('5085571', pexels: true),  // amigos próximos
  PhotoBackground('8570885', pexels: true),  // abraço entre amigos
  PhotoBackground('4820215', pexels: true),  // amigas de mãos dadas
  PhotoBackground('9630204', pexels: true),  // mãos unidas
  PhotoBackground('3830752', pexels: true),  // mãos empilhadas (união)
  PhotoBackground('4672717', pexels: true),  // mãos se encontrando
  PhotoBackground('3851943', pexels: true),  // mãos de amigos
  PhotoBackground('7322769', pexels: true),  // grupo unindo as mãos
  // ---- Paisagens / natureza (Picsum) ----
  PhotoBackground('1015'), // fiorde / penhasco
  PhotoBackground('1057'), // costa ao pôr do sol
  PhotoBackground('1037'), // nascer do sol entre árvores
  PhotoBackground('1018'), // montanhas verdes e estrada
  PhotoBackground('1039'), // cachoeira e vale verde
  PhotoBackground('1043'), // vale de Yosemite
  PhotoBackground('1045'), // montanha verde
  PhotoBackground('1051'), // cais de madeira no lago
  PhotoBackground('1036'), // montanhas nevadas
  PhotoBackground('1016'), // cânion no fim de tarde
  PhotoBackground('1064'), // neblina sobre as colinas
  PhotoBackground('1044'), // floresta com névoa
  PhotoBackground('1041'), // mar sereno / gelo
  PhotoBackground('1038'), // costa gelada
  PhotoBackground('1052'), // praia de rocha negra
  PhotoBackground('1055'), // lago calmo ao amanhecer
  PhotoBackground('1019'), // mar sob céu nublado
  PhotoBackground('1061'), // praia serena
  PhotoBackground('1023'), // campos vistos do alto
  // ---- ampliação (paisagens/natureza, licença Unsplash) ----
  PhotoBackground('1002'), // cidade à noite
  PhotoBackground('1003'), // folhas de outono
  PhotoBackground('1004'), // rua arborizada
  PhotoBackground('1008'), // arranha-céus
  PhotoBackground('1013'), // costa rochosa
  PhotoBackground('1014'), // mar e horizonte
  PhotoBackground('1020'), // rio na floresta
  PhotoBackground('1021'), // fachada / arquitetura
  PhotoBackground('1024'), // montanhas e lago
  PhotoBackground('1029'), // trilho na floresta
  PhotoBackground('1031'), // campo dourado
  PhotoBackground('1033'), // estrada no campo
  PhotoBackground('1035'), // montanha nevada
  PhotoBackground('1042'), // vale verde
  PhotoBackground('1047'), // rua antiga
  PhotoBackground('1048'), // cidade e ponte
  PhotoBackground('1049'), // praia tropical
  PhotoBackground('1050'), // cidade litorânea
  PhotoBackground('1053'), // pôr do sol no mar
  PhotoBackground('1054'), // ilha e mar
  PhotoBackground('1056'), // vale ensolarado
  PhotoBackground('1058'), // estrada e montanha
  PhotoBackground('1059'), // trilha na mata
  PhotoBackground('1060'), // cais e lago
  PhotoBackground('1062'), // outono dourado
  PhotoBackground('1063'), // neve e árvores
  PhotoBackground('1065'), // vista aérea da costa
  PhotoBackground('1066'), // colinas verdes
  PhotoBackground('1069'), // lago e montanhas
  PhotoBackground('1070'), // floresta densa
  PhotoBackground('1071'), // céu e nuvens
  PhotoBackground('1072'), // deserto ao entardecer
  PhotoBackground('1073'), // dunas
  PhotoBackground('1074'), // campo aberto
  PhotoBackground('1075'), // praia e falésias
  PhotoBackground('1076'), // horizonte urbano
  PhotoBackground('1077'), // lago espelhado
  PhotoBackground('1080'), // vinhedos
  PhotoBackground('1081'), // rua histórica
  PhotoBackground('1082'), // campo florido
  PhotoBackground('1083'), // montanha ao amanhecer
  PhotoBackground('1084'), // costa e farol
];
