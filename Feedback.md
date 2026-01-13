LES ROUTES INTERESSANTES
------------------------
- Celle pour avoir la liste des categories de produits et services associes a une entreprise
- Celle pour avoir les produits et services en fonction d'une entreprise et d'une catégorie

Ce qui te permet facilement de gérer la page d'une entreprise. Tu récuperes d'abord les categories de produits et services associes a une entreprise, ensuite a partir de leurs ds et de l'id de l'entreprise tu récuperes les produits et services correspondants

Les informations d'une entreprise sont gérées par la route Marketplace. Donc avec l'd de l'entreprise (quand on clique sur elle), tu récupere les infos pour le marketplace, tu récuperes la liste des categories de produits et services, puis en jumelant avec l'id des categories tu obtiens la liste des produits et services correspondants a chaque catégorie pour une entreprise



Revue Ebom Market 

Urgent à faire
•⁠  ⁠Revoir la description d'une entreprise : listing des produits et services par catégorie (certains s'affichent et d'autres non)
•⁠  ⁠Possibilité de charger la liste des produits services et entreprises par lots de 10 ou 15 pour éviter de tout charger à la fois 
•⁠  ⁠Ajouter services similaires dans la description d'un service 
•⁠  ⁠Bouton contacter l'entreprise dans la description d'un service 
•⁠  ⁠Demande de paiement constante après souscription de la recherche 
•⁠  ⁠Possibilité de contourner la souscription du chat
•⁠  ⁠Possibilité d'ouvrir le WhatsApp d'une entreprise quand on clique sur son numéro dans sa description 
•⁠  ⁠Possibilité d'ouvrir l'envoi de mail quand on clique sur l'adresse mail d'une entreprise quand on clique dessus 

A faire
•⁠  ⁠Dans la liste complète des produits, services et entreprises, les grouper par catégories (uniquement les catégories, pas les sous-catégorie): design de l'accueil 
•⁠  ⁠Mettre un voir plus à ce niveau pour lister ensuite toutes les produits, services ou entreprises d'une catégorie (par lot de 10 ou 15 au fur et à mesure qu'on Scroll vers le bas

Amélioration APIs 
•⁠  ⁠il faut forcer l'actualisation du cache des APIs pour voir les mises à jour 
•⁠  ⁠Le marketplace fourni toutes les infos d'une entreprise 
•⁠  ⁠les paiements des abonnements sont optimisés côté serveur, c'est le serveur qui check si la transaction est passée ou pas et créé l'abonnement correspondant . Tout ce que l'appli va faire c'est check si le paiement est terminé ou pas (moins de deux minutes max).
•⁠  ⁠Check si un abonnement est actif ou pas avant de demander de payer ou pas (voir code de retour sur l'API des abonnements en cas d'abonnement expiré)

