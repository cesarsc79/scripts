#!/bin/bash
clear
cd $HOME

user=$(whoami)
dirhome=/home/$user
dirscripts=$dirhome/scripts
dirdevelopers=$dirscripts/developers
dirmodulos=$dirhome/modulos
dirdeployment=$dirhome/deployment
diraddons=$dirdeployment/addons
dirconfig=$dirscripts/config
rutagit=https://github.com
odooversion=11.0

cd $dirdevelopers
developers=$(ls)

if [ -d $dirmodulos ]
    then
        rm -rf $dirmodulos
fi

mkdir $dirmodulos
cd $dirmodulos

for dev in $developers
    do
        mkdir $dev
        cd $dev
        repos=$(cat $dirdevelopers/$dev)
        for repo in $repos
            do
                git clone $rutagit/$dev/$repo.git -b $odooversion --depth=1
                cd $repo
                if [ -f requirements.txt ]
                    then
                        sudo -H pip3 install -r requirements.txt
                    else
                        echo "No existe el archivo requirements.txt"
                fi
                cd ..
            done
        cd ..         
    done

if [ -d $dirdeployment ]
    then
        rm -rf $dirdeployment
fi

mkdir $dirdeployment
cd $dirdeployment

mkdir odoo
cd odoo

enlaces=$(ls /home/$user/modulos/OCA/OCB)

for enlace in $enlaces
        do
                ln -s /home/$user/modulos/OCA/OCB/$enlace
        done
cd ..

mkdir $diraddons
cd $diraddons

############################################################################
mkdir odoo-default-addons
cd odoo-default-addons

enlaces=$(ls /home/$user/modulos/OCA/OCB/addons)

for enlace in $enlaces
        do
                ln -s /home/$user/modulos/OCA/OCB/addons/$enlace
        done
cd ..

mkdir l10n-spain
cd l10n-spain

enlaces=$(ls /home/$user/modulos/OCA/l10n-spain)

for enlace in $enlaces
        do
                ln -s /home/$user/modulos/OCA/l10n-spain/$enlace
        done
cd ..


mkdir OCA
cd OCA

enlaces=$(ls /home/$user/modulos/OCA)

for enlace in $enlaces
        do
            modulos=$(ls /home/$user/modulos/OCA/$enlace)    
            for modulo in $modulos
                do
                    ln -s /home/$user/modulos/OCA/$enlace/$modulo                                
                done
        done

rm l10n-spain
rm OCB

cd ..


mkdir others-addons
cd others-addons

enlaces=$(ls /home/$user/modulos)

for enlace in $enlaces
        do
                if [ $enlace = OCA ]
                    then
                        echo "paso de OCA"
                else
                    repos=$(ls /home/$user/modulos/$enlace)    
                    for repo in $repos
                        do
                            modulos=$(ls /home/$user/modulos/$enlace/$repo)
                            for modulo in $modulos
                                do
                                    ln -s /home/$user/modulos/$enlace/$repo/$modulo
                                done                                
                        done
                fi
        done
cd ..
#########################################################################################

cp $dirconfig/* $dirdeployment
