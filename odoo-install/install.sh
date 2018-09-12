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
                git clone $rutagit/$dev/$repo.git -b 11.0 --depth=1
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

ln -s $dirmodulos/OCA/OCB odoo

mkdir $diraddons

cd $diraddons

ln -s $dirmodulos/OCA/OCB/addons odoo-default-addons
ln -s $dirmodulos/OCA/l10n-spain l10n-spain

cd l10n-spain
rm *.* LICENSE
cd ..


cd $diraddons
mkdir OCA

cd OCA
repos=$(ls $dirmodulos/OCA)

for repo in $repos

    do
        modulos=$(ls $dirmodulos/OCA/$repo)

        for modulo in $modulos

            do
                ln -s $dirmodulos/OCA/$repo/$modulo $modulo
            done
    done

rm -rf l10n_es*
rm *.*

files=$(ls $dirmodulos/OCA/OCB)

for file in $files
    do
        rm -rf $file
    done

cd ..

cd $diraddons
mkdir others-addons

cd others-addons

ln -s $dirmodulos/Openworx/backend_theme/backend_theme_v11 backend_theme_v11
ln -s $dirmodulos/cytex124/odoo-drag-and-drop/drag-and-drop drag-and-drop
ln -s $dirmodulos/cesarsc79/odoo-modules/all all

cp $dirconfig/* $dirdeployment