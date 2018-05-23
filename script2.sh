#!/usr/bin/env bash
# (c) 2018 Nokia Proprietary - Nokia Internal Use

set -x

CURRENT_DIR="/tmp/shaharTests/"  #The directory of the script


usage()
        {

cat << EOF
usage: $0 [OPTIONS...]
OPTIONS:
   -p PRODUCT                   cbnd or cbis
   -v VERSION                   version 17.5, 18 or 18.5
   -d DEV                       dev version 18.0.0.1 , 18.5.0.1 etc
   -r RELEASE                   release build
   -k PACKAGE                   package
   -c CYCLE                     cycle
   -h                           show this help and exit
EOF
        }

        while getopts "p:v:d:r:k:c:h" opt; do
        case $opt in

         p)
                PRODUCT=$OPTARG
                ;;
         v)
                VERSION=$OPTARG
                ;;
         d)     DEV=$OPTARG
                ;;

         r)
                RELEASE=$OPTARG
                ;;
         k)
                PACKAGE="_"$OPTARG
                ;;

         c)     CYCLE="_"$OPTARG
                ;;

         h)
                usage
                exit 1
                ;;
         *)
                usage
                exit 1
                ;;

        esac

        done


        function init() {
        BUILD_DIR="CloudBand_${PRODUCT}_R${VERSION}${PACKAGE}${CYCLE}"
        echo "${BUILD_DIR}"
        mkdir -p ${BUILD_DIR}
        cd ${BUILD_DIR}
        mkdir sources docs artifacts

        }


        function clone_repo() {
        if [ ${PRODUCT} == "CBND" ]
        then

        {

        cd docs
        wget -r -l1 -nd -A 'CBND*.*,cbnd*.*' http://yum.cloud-band.com/nfvo_local_repo/CBNDReleases/CBND${VERSION}/CustomerDocumantation/

        cd ../sources
        git clone ssh://prod-barch@stash.cloud-band.com:7999/nfvo/nfvo.git

                cd ../artifacts
        wget -r -l1 -nd -A 'cbnd*.*' http://yum.cloud-band.com/nfvo_local_repo/${DEV}/${RELEASE}/

        }

elif [ ${PRODUCT} == "CBIS" ]
                then
                {


        cd artifacts
        wget -r -l1 -nd -A 'cbis*' http://yum.cloud-band.com/cbis_local_repo/${DEV}/${RELEASE}/
        cd ../docs

        git clone ssh://git@stash.cloud-band.com:7999/cnode/cbis-component-cudo.git
        cd ..

        mv -f ${WORKSPACE}/${BUILD_DIR}/docs/cbis-component-cudo/content/ ${WORKSPACE}/${BUILD_DIR}/docs/
        rm -rf ${WORKSPACE}/${BUILD_DIR}/docs/cbis-component-cudo/

        cd sources/
        cp ${WORKSPACE}/repo_list .

        for repo in `cat repo_list` ; do
        #echo item: $repo
        git clone ssh://git@stash.cloud-band.com:7999/cnode/$repo.git

done
        cd ..


        }
        else

        exit 1
fi
        }


function create_archive() {

        
        if [ ${PRODUCT} == "CBND" ]
        then

   {

        cd ..
        tar czvf cloudband-${PRODUCT}.${DEV}-${RELEASE}-source.tar.gz sources/
        tar czvf cloudband-${PRODUCT}.${DEV}-${RELEASE}-docs.tar.gz docs/
        tar czvf cloudband-${PRODUCT}.${DEV}-${RELEASE}-artifacts.tar.gz artifacts/

        rm -rf sources docs artifacts

   }
        else
                
        tar czvf cloudband-${PRODUCT}.${DEV}-${RELEASE}-source.tar.gz sources/
        tar czvf cloudband-${PRODUCT}.${DEV}-${RELEASE}-docs.tar.gz docs/
        tar czvf cloudband-${PRODUCT}.${DEV}-${RELEASE}-artifacts.tar.gz artifacts/
        rm -rf sources docs artifacts

fi

   }

        echo "Making folder"
        init

        echo "Clone from git"
        clone_repo

        echo "create archive"
        create_archive



