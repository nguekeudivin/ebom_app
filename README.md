### Modification

Et aussi en ce qui concerne se message:

Voici les éléments à régler au moins pour lundi:

- [ok]Avoir la liste des produits par catégories (quand on clique sur une catégorie, on doit voir les produits ou services de cette catégorie là

  Mon commentaire:
  C'est ce que je fais deja. Pour garder les choses simples, lorsque qu'on clique sur une categorie une recherche automatique est effectue avec le nom de la categorie comme mot cle. C'est ce que j'expliquais tantot dans mon document concernant la recherche. Il faut un system assez robust pour prendre en compte a lui seul le systeme de recherche. Si plusieurs endpoints font potentiellement la meme chose c'est pas tres efficient selon moi. Dans ce sens que d'avoir un endpoints pour recuperer les produits d'une categorie, mieux vaut une fois configurer la recherche pour qu'elle puisse une fois prendre en compte cela.

- [ok] Avoir les bons résultats de la recherche quand on fait une recherche générale à l'accueil, avoir tous les résultats. S'il fait au niveau des produits la requête est /search?produits=1 (paramètres en GET pour signaler la recherche uniquement de produits et récupérer dans le tableau des résultats (cf doc API). C'est pareil pour les services (/search?services=1) et pour les entreprises (/search?entreprises=1)

- [ok] Avoir la liste des produits et services d'une entreprise sur la page d'une entreprise par catégories. Et si une catégorie n'a pas de produit ou de service, ne pas l'afficher

- [ok] Pouvoir modifier son profil les infos utilisateur s'affiche pour modifier le compte mais quand on valide le formulaire rien ne se passe

- [ok] Changer le texte de l'option partager l'App par Découvre avec moi l'application E-Bom pour trouver n'importe quoi n'importe où et à n'importe quel prix en un clic. https://ebom-market.com (quelque chose comme ça)

### Chat

- [ok] Creer une conversation a partir de la page d'une entreprise.

- [ok] Creer une conversation a partir de la page d'un produit.

- [ok] Charger les messages d'une conversation.

- [ok] Envoyer un message.

- [ok] Supprimer un message.
