class Estudante{
  final String name;
  final String ID;
  final String curso;
  final String status;
  final String foto;
  final bool isCotista;
  final double saldo;


  Estudante({
    required this.name,
    required this.ID,
    required this.curso,
    required this.status,
    required this.foto,
    required this.isCotista,
    required this.saldo,
});
}

final Estudante simularEstudante = Estudante(
    name: 'Renan Souza do Nascimento',
    ID: '202520401811',
    curso: 'Ciência da Computação',
    status: 'Ativo',
    foto: 'assets/images/teste.jpeg',
    isCotista: true,
    saldo: 15.0,
);