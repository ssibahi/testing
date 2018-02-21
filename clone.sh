
#!/usr/bin/env bash
# (c) 2016 Nokia Proprietary - Nokia Internal Use

set -x

CURRENT_DIR="/tmp/shaharTests/"  #The directory of the script


usage()
        {

cat << EOF
usage: $0 [OPTIONS...]

OPTIONS:
   -p PRODUCT                   cbnd or cbis
   -v VERSION                   version release
   -b BUILD_NUMBER              current build
   -s SUFFIX                    P7 or P8 etc
   -h                           show this help and exit

EOF
        }

        while getopts "p:v:b:s:h" opt; do
        case $opt in

         p)
                PRODUCT=$OPTARG
                ;;
         v)
                VERSION=$OPTARG
                ;;
         b)
                BUILD_NUMBER=$OPTARG
                ;;
         s)
                SUFFIX="_"$OPTARG
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
        BUILD_DIR="CloudBand_${PRODUCT}_R${VERSION}${SUFFIX}"
        mkdir -p ${BUILD_DIR}
        cd ${BUILD_DIR}
        mkdir sources docs

        }


        function clone_repo() {
        if [ ${PRODUCT} == "CBND" ]
        then

        {

        cd docs
        wget -r -l1 -nd -A 'CBND*.*,cbnd*.*' http://yum.cloud-band.com/nfvo_local_repo/CBNDReleases/CBND${VERSION}/CustomerDocumantation/
        cd ..
        cd sources/
        git clone ssh://prod-barch@stash.cloud-band.com:7999/nfvo/nfvo.git
        cd ..
        }

elif [ ${PRODUCT} == "CBIS" ]
then    {

        cd docs
        git clone ssh://git@stash.cloud-band.com:7999/cnode/cbis-component-cudo.git
        cd ..

        mv /tmp/shaharTests/ggg/${BUILD_DIR}/docs/cbis-component-cudo/content/* /tmp/shaharTests/ggg/${BUILD_DIR}/docs/
        rm -rf /tmp/shaharTests/ggg/${BUILD_DIR}/docs/cbis-component-cudo/


        cd sources/
        cp /tmp/shaharTests/ggg/repo_list1 .

        for repo in `cat repo_list1` ; do
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
        tar czvf cloudband-cbnd.${VERSION}-${BUILD_NUMBER}-source.tar.gz sources/
        tar czvf cloudband-cbnd.${VERSION}-${BUILD_NUMBER}-docs.tar.gz docs/
        rm -rf sources docs

   }
        else
        tar czvf cloudband-cbis.${VERSION}-${BUILD_NUMBER}-source.tar.gz sources/
        tar czvf cloudband-cbis.${VERSION}-${BUILD_NUMBER}-docs.tar.gz docs/
        rm -rf sources docs

fi

   }

        echo "Making folder"
        init

        echo "Clone from git"
        clone_repo

        echo "create archive"
        create_archive


