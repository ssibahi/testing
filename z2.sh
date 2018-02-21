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
   -v VERSION                   version
   -d DEV                       dev version
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
                PACKAGE=$OPTARG
                ;;

         c)     CYCLE=$OPTARG
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
        wget -r -l1 -nd -A 'cbnd-apidocs*.*' http://yum.cloud-band.com/nfvo_local_repo/${DEV}/${RELEASE}/

        }

elif [ ${PRODUCT} == "CBIS" ]
                then
                {

echo "1111111111111111111111111111111111111111111111111"
pwd

        cd artifacts
        wget -r -l1 -nd -A 'cbis-ci*' http://yum.cloud-band.com/cbis_local_repo/${DEV}/${RELEASE}/
        cd ../docs

                git clone ssh://git@stash.cloud-band.com:7999/cnode/cbis-component-cudo.git
        cd ..

echo "2222222222222222222222222222222222222222222222222"
pwd

        mv -f ${env.WORKSPACE}/${BUILD_DIR}/docs/cbis-component-cudo/content/ ${env.WORKSPACE}/${BUILD_DIR}/docs/
        rm -rf ${env.WORKSPACE}/${BUILD_DIR}/docs/cbis-component-cudo/

echo "3333333333333333333333333333333333333333333333333"
pwd
        cd sources/
        cp ${env.WORKSPACE}/repo_list ${env.WORKSPACE}/sources/repo_list

		git clone ssh://git@stash.cloud-band.com:7999/cnode/cbis.git

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

        pwd
        if [ ${PRODUCT} == "CBND" ]
        then

   {


        cd ..
        tar czvf cloudband-cbnd.${DEV}-${RELEASE}-source.tar.gz sources/
        tar czvf cloudband-cbnd.${DEV}-${RELEASE}-docs.tar.gz docs/
        tar czvf cloudband-cbnd.${DEV}-${RELEASE}-artifacts.tar.gz artifacts/

        #rm -rf sources docs artifacts

   }
            else
                pwd

        tar czvf cloudband-cbis.${DEV}-${RELEASE}-source.tar.gz sources/
        tar czvf cloudband-cbis.${DEV}-${RELEASE}-docs.tar.gz docs/
        tar czvf cloudband-cbis.${DEV}-${RELEASE}-artifacts.tar.gz artifacts/
       #rm -rf sources docs artifacts

fi

   }

        echo "Making folder"
        init

        echo "Clone from git"
        clone_repo

        echo "create archive"
        create_archive




