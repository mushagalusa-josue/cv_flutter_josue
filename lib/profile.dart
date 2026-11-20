const name = 'Mushagalusa Metre Josué';
const role = 'Développeur full stack IA junior';
const city = 'Goma, Nord-Kivu, RDC';
const photo = 'assets/profile.jpg'; // Exemple : assets/portraits/josue.jpg
const phone = '+243 985 095 747';
const email = 'mushagalusajosue5@gmail.com';
const github = 'josue25';
const linkedIn = 'josue mushagalusa';

class Relative {
  const Relative(this.name, this.relationship, this.description,
      {this.photo = ''});

  final String name;
  final String relationship;
  final String description;
  final String photo;
}

const parents = [
  Relative('Metre Bacibone Dug Gustav', 'Père',
      'Professeur ordinaire en mathématiques · Père de neuf enfants'),
  Relative('Sifa Bashige Yvette', 'Mère de neuf enfants', 'Mère au foyer'),
];

const siblings = [
  Relative('Baguma Metre Yves', 'Frère',
      'QA et développeur full stack intermédiaire'),
  Relative(
      'Murhula Metre Lemoisson', 'Frère', 'Développeur full stack IA senior'),
  Relative('Ciragane Metre Nicole', 'Sœur', 'Développeuse full stack IA'),
  Relative('Cikwanine Metre', 'Membre de la fratrie', 'Ingénieur agronome'),
  Relative(name, 'Moi · 5ᵉ enfant', role, photo: photo),
  Relative('Aganze Metre Pierre', 'Frère', 'Développeur full stack junior'),
  Relative('Alanga Metre Justine', 'Sœur', 'Étudiante en communication'),
  Relative(
      'Akuzwe Metre Marie-Reine', 'Sœur', 'Élève en troisième scientifique'),
  Relative('Ayagirwe Metre Aurélie', 'Sœur', 'Élève en première scientifique'),
];
