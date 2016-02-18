#!/bin/bash
# $1 : Premier fichier
# $2 : Second fichier

echo -e "\n_____________________\n";

#Comparaison output avec outputbis
echo "Vérification de présence des fichiers de $1 sur $2 :"
echo "Fichier(s) manquant(s) sur $2 :"
compteur=0;
while read line 
do   
	#res=$(find $PWD/$2 -name "$2" -exec grep $line {} \;);
	res=$(grep $line $2 | head -n 1)
	if [ "$res" = "$line" ] 
	then 
		compteur=`expr "$compteur" + 1` 
	else 
		echo : "-> $line";
	fi
done < $1
nombredeligne=$(wc -l < $1);

if [ "$compteur" = "$nombredeligne" ] 
then 
	echo "Aucun !";
fi 


echo -n "$compteur/$nombredeligne fichier(s) de la machine $2 sont sur la machine $1 soit en pourcentage : " ;
echo "scale=2; $compteur/$nombredeligne * 100" | bc
echo -e "\n_____________________";
#Comparaison outputbis avec output
echo " ";
echo "Vérification de présence des fichiers de $2 sur $1 :"
echo "Fichier(s) manquant(s) sur $1:"
compteur=0;
while read line  
do   
	#res=$(find $PWD/$1 -name "$1" -exec grep $line {} \;)
	res=$(grep $line $1 | head -n 1)
	if [ "$res" = "$line" ] 
	then 
		compteur=`expr "$compteur" + 1` 
	else 
		echo : "-> $line";
	fi
done < $2

nombredeligne=$(wc -l < $2);
if [ "$compteur" = "$nombredeligne" ] 
then 
	echo "Aucun !";
fi 
echo -n "$compteur/$nombredeligne fichier(s) de la machine $1 sont sur la machine $2 soit en pourcentage : " ;
echo "scale=2; $compteur/$nombredeligne * 100" | bc
echo -e "\n_____________________";







