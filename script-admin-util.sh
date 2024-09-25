#!/bin/bash

# Liste les utilisateurs de la machine en excluant daemon et nobody
users=$(dscl . list /Users | grep -v "^_" | grep -v "daemon" | grep -v "nobody")

# Initialiser une variable pour suivre la présence d'un compte utilisateur standard
user_found=false

# Boucle sur chaque utilisateur
for user in $users
do
    # Vérifie si l'utilisateur appartient au groupe admin
    is_admin=$(dsmemberutil checkmembership -U $user -G admin)

    if [[ $is_admin == *"not a member"* ]]; then
        echo "Utilisateur standard trouvé : $user"
        user_found=true
    fi
done

# Si un utilisateur standard a été trouvé, exit 0
if [ "$user_found" == true ]; then
    exit 0
else
    # Si aucun utilisateur standard n'est trouvé, exit 1
    echo "Aucun utilisateur standard trouvé."
    exit 1
fi
