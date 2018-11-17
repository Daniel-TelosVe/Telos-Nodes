#!/bin/bash
#Daniel Uzcátegui
#Telos-Venezuela
echo "#" >> ~/.nodeviroment
source ~/.nodeviroment

set -e
LOC=$PWD
function usage
{
    echo "
████████╗███████╗██╗      ██████╗ ███████╗      ██╗   ██╗███████╗███╗   ██╗███████╗███████╗██╗   ██╗███████╗██╗      █████╗ 
╚══██╔══╝██╔════╝██║     ██╔═══██╗██╔════╝      ██║   ██║██╔════╝████╗  ██║██╔════╝╚══███╔╝██║   ██║██╔════╝██║     ██╔══██╗
   ██║   █████╗  ██║     ██║   ██║███████╗█████╗██║   ██║█████╗  ██╔██╗ ██║█████╗    ███╔╝ ██║   ██║█████╗  ██║     ███████║
   ██║   ██╔══╝  ██║     ██║   ██║╚════██║╚════╝╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██╔══╝   ███╔╝  ██║   ██║██╔══╝  ██║     ██╔══██║
   ██║   ███████╗███████╗╚██████╔╝███████║       ╚████╔╝ ███████╗██║ ╚████║███████╗███████╗╚██████╔╝███████╗███████╗██║  ██║
   ╚═╝   ╚══════╝╚══════╝ ╚═════╝ ╚══════╝        ╚═══╝  ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
                                           CREATING A BETTER WORLD, BLOCK BY BLOCK.                                                                                                                          
";
    echo "usage: ./NodeBranching.sh [Initialize, Setup , Version , Wizard] [OPTIONS]  ";
	echo " OPTIONS: ";
	echo " [Initialize] first setup run once";
	echo " [Setup] Build Nodeos and creates start and stop scripts";
	echo " [Version] Select which version to control";
	echo " [Wizard] Wizard setup";
	echo "  -i | --INSDIR             : Installation Directory defaults: /opt/Nodes";
    echo "  -a | --CHECKOUT           : git branch name";
	echo "  -w | --WALLET             : Port to use for tkeosd defaults: 8900";
	echo "  -c | --CONFIGDIR          : Directory of your config.ini file defaults: /home/${USER}/control/defaults";
	echo "  -p | --P2P                : Nodeos P2P Port defaults:  9876";
	echo "  -t | --HTTP               : Nodeos Http Port defaults: 8888";
	echo "  -d | --DATADIR            : Directory of Blocks/state  defaults: /data";
	echo "  -f | --CONTROL            : Directory of control scripts defaults: /home/${USER}/control/scripts";
	echo "  -g | --GENESIS            : Genesis URL";
	echo "  -h | --help               : This message";
	
}

function parse_args
{
  # positional args
  args=()

  # named args
  while [ "$1" != "" ]; do
      case "$1" in
	      -i | --INSDIR )      INSDIR="$2";             shift;;
          -a | --CHECKOUT )     CHECKOUT="$2";             shift;;
		  -w | --WALLET )        WALLET="$2";      shift;;
		  -d | --DATADIR )        DATADIR="$2";      shift;;
		  -p | --P2P)              P2P="$2";      shift;;
		  -t | --HTTP)              HTTP="$2";      shift;;
		  -c | --CONFIGDIR )         CONFIGDIR="$2";      shift;;
		  -f | --CONTROL )            CONTROL="$2";      shift;;
		  -g | --GENESIS)              GENESIS="$2";      shift;;
          -h | --help )                 usage;                   exit;; # quit and show usage
          * )                            args+=("$1")             # if no match, add it to the positional args
      esac
      shift # move to next kv pair
  done

  # restore positional args
  set -- "${args[@]}"

  # set positionals to vars
  positional_1="${args[0]}"
  positional_2="${args[1]}"

  # validate required args
  
  if [[ -z "${positional_1}"  ]]; then
     menu;
  fi
  
  # set defaults
  if [[ -z "$WALLET" ]]; then
      WALLET="8900";
  fi
  if [[ -z "$INSDIR" ]]; then
      INSDIR="/opt/Nodes";
  fi
  if [[ -z "${CONFIGDIR}" ]]; then
      CONFIGDIR="/home/${USER}/control/defaults";
  fi
  if [[ -z "${DATADIR}" ]]; then
      DATADIR="/data";
  fi
  if [[ -z "${CONTROL}" ]]; then
      CONTROL="/home/${USER}/control/scripts";
  fi
  if [[ -z "${P2P}" ]]; then
      P2P="9876";
  fi
  if [[ -z "${HTTP}" ]]; then
      HTTP="8888";
  fi
  if [[ -z "${GENESIS}" ]]; then
      GENESIS="http://testnet.telosfoundation.io/assets/files/genesis.json";
  fi
  
}


function run
{
  parse_args "$@"
sudo mkdir -p $CONTROL $DEFAULTS $CONFIGDIR $DATADIR $INSDIR
sudo chown $USER $CONTROL $DEFAULTS $CONFIGDIR $DATADIR $INSDIR
  
echo "export CONTROL=${CONTROL}" >> ~/.nodeviroment
echo "export DEFAULTS=${DEFAULTS}" >> ~/.nodeviroment
echo "export CONFIGDIR=${CONFIGDIR}" >> ~/.nodeviroment
echo "export DATADIR=${DATADIR}" >> ~/.nodeviroment
  
PROGRAMS=$INSDIR/$CHECKOUT/build/programs

#  echo "positional arg 1: $positional_1"
#  echo "positional arg 2: $positional_2"

if [[ -z "${CHECKOUT}"  ]]; then
      echo "No Checkout provided so I will exit"
      exit;
fi	  
cd $INSDIR
git clone --quiet --progress  https://github.com/Telos-Foundation/telos $CHECKOUT
cd $CHECKOUT
git checkout $CHECKOUT
git submodule update --init --recursive
yes '1' | ./telos_build.sh
mkdir -p $CONTROL/$CHECKOUT 
echo "$PROGRAMS/nodeos/nodeos --p2p-listen-endpoint 0.0.0.0:${P2P} --http-server-address 127.0.0.1:${HTTP} --config-dir ${CONFIGDIR} --data-dir ${DATADIR} " '$@' " &> "$CONTROL/$CHECKOUT/"tlos.log &  echo " '$!' " > " $CONTROL/$CHECKOUT/"nodeos.pid" >> $CONTROL/$CHECKOUT/nodeos.sh 
echo "$PROGRAMS/teclos/teclos -u http://127.0.0.1:${HTTP} ---wallet-url http://127.0.0.1:${WALLET} " '$@'  >> $CONTROL/$CHECKOUT/teclos.sh
echo "$PROGRAMS/tkeosd/tkeosd --http-server-address http://127.0.0.1:${WALLET} " '$@' >> $CONTROL/$CHECKOUT/tkeosd.sh
chmod +x $CONTROL/$CHECKOUT/teclos.sh $CONTROL/$CHECKOUT/nodeos.sh $CONTROL/$CHECKOUT/tkeosd.sh
echo "export NODESET=${CONTROL}/${CHECKOUT} " >> ~/.nodeviroment
wget -o $DEFAULTS/genesis.json $GENESIS
}

function Initial
{

yes | sudo apt-get update
yes | sudo apt-get upgrade
sudo timedatectl set-ntp no
yes | sudo apt-get install ntp
### Create Telos Home and make  usr propietary
sudo mkdir -p $INSDIR
sudo chown $USER $INSDIR
sudo dd of=status << 'EOF'
#!/bin/bash
pgrep tkeosd | xargs printf " -p %d" | xargs lsof -Pani
pgrep nodeos | xargs printf " -p %d" | xargs lsof -Pani
EOF

sudo dd of=start.sh << 'EOF'
#!/bin/bash
source ~/.nodeviroment
stopnode
$NODESET/nodeos.sh $@
EOF
sudo dd of=nodeos << 'EOF'
#!/bin/bash
source ~/.nodeviroment
$NODESET/nodeos.sh $@
EOF
sudo dd of=teclos << 'EOF'
#!/bin/bash
source ~/.nodeviroment
$NODESET/teclos.sh $@
EOF
sudo dd of=tkeosd << 'EOF'
#!/bin/bash
source ~/.nodeviroment
$NODESET/tkeosd.sh $@
EOF
#
sudo dd of=stop.sh << 'EOF'
#!/bin/bash
source ~/.nodeviroment
DIR=$NODESET
    if [ -f $DIR"/nodeos.pid" ]; then
        pid=$(cat $DIR"/nodeos.pid")
        echo $pid
        kill $pid
        rm -r $DIR"/nodeos.pid"

        echo -ne "Stoping Nodeos"

        while true; do
            [ ! -d "/proc/$pid/fd" ] && break
            echo -ne "."
            sleep 1
        done
        echo -ne "\rNodeos stopped. \n"
    fi
EOF
sudo dd of=backupnode << 'EOF'
#!/bin/bash
source ~/.nodeviroment
nohup stopnode $
cp -r $DATADIR/blocks $DATADIR/blockstemp
cp -r $DATADIR/state $DATADIR/statetemp
nohup startnode &
rm $DATADIR/backup.tar.gz.1
mv $DATADIR/backup.tar.gz $DATADIR/backup.tar.gz.1
tar czvf $DATADIR/backup.tar.gz $DATADIR/blockstemp $DATADIR/statetemp
rm -rf $DATADIR/blockstemp
rm -rf $DATADIR/statetemp
EOF
sudo dd of=confnode << 'EOF'
#!/bin/bash
source ~/.nodeviroment
nano $DEFAULTS/config.ini
EOF
sudo dd of=showlog << 'EOF'
#!/bin/bash
source ~/.nodeviroment
tail -f ${NODESET}/tlos.log
EOF
sudo dd of=version << 'EOF'
#!/bin/bash
source ~/.nodeviroment
${LOC}/NodeBranching.sh Version
EOF

sudo chmod +x confnode showlog version start.sh stop.sh backupnode nodeos teclos tkeosd status
sudo mv status /usr/bin/ 
sudo mv confnode /usr/bin/ 
sudo mv showlog /usr/bin/  
sudo mv version /usr/bin/     
sudo mv start.sh /usr/bin/startnode 
sudo mv stop.sh /usr/bin/stopnode   
sudo mv backupnode /usr/bin   
sudo mv nodeos /usr/bin/   
sudo mv teclos /usr/bin/   
sudo mv tkeosd /usr/bin/
}
function version
{
	 cd $CONTROL
	 export Directory=$(ls -lhp -1 -d */ | awk -F ' ' ' { print $9 " " $5 } ')
     export newpath=$(whiptail --menu "Select nodeos version to control" 40 50 30 --cancel-button Cancel --ok-button Select $Directory 3>&1 1>&2 2>&3)
     echo "export NODESET=${CONTROL}/${newpath}" >> ~/.nodeviroment
}
function update
{ 
     cd $INSDIR
	 export Directory=$(ls -lhp -1 -d $INSDIR/*/ | awk -F ' ' ' { print $9 " " $5 } ')
     export newpath=$(whiptail --menu "Select version to update" 40 50 30 --cancel-button Cancel --ok-button Select $Directory 3>&1 1>&2 2>&3)
	 CHECKOUT=$(whiptail --inputbox "Enter Github Telos branch to build" 8 78 stage3.0 --title " Dialog" 3>&1 1>&2 2>&3);
     cd $newpath
	 git pull
	 git checkout $CHECKOUT
	 git submodule update --init --recursive
	 ./telos_build.sh
	 cd ..
	 mv $newpath $CHECKOUT
	 mv $CONTROL/$newpath $CONTROL/$CHECKOUT
	 echo "export NODESET=${CONTROL}/${newpath}" >> ~/.nodeviroment
	 
}
function Wizard
{


CHECKOUT=$(whiptail --inputbox "Enter Github Telos branch to build" 8 78 stage3.0 --title " Dialog" 3>&1 1>&2 2>&3); 
WALLET=$(whiptail --inputbox "Port to use for tkeosd" 8 78 8900 --title " Dialog" 3>&1 1>&2 2>&3);
P2P=$(whiptail --inputbox "Port to use for P2P" 8 78 9876 --title " Dialog" 3>&1 1>&2 2>&3);
HTTP=$(whiptail --inputbox "Port to use for HTTP" 8 78 8888 --title " Dialog" 3>&1 1>&2 2>&3);
CONFIGDIR=$(whiptail --inputbox " Directory of your config.ini file" 8 78 /home/"$USER"/control/defaults --title " Dialog" 3>&1 1>&2 2>&3);
DATADIR=$(whiptail --inputbox "Directory of Blocks/state" 8 78 /data --title " Dialog" 3>&1 1>&2 2>&3);
CONTROL=$(whiptail --inputbox "Directory of control scripts" 8 78 /home/${USER}/control/scripts --title " Dialog" 3>&1 1>&2 2>&3);
GENESIS=$(whiptail --inputbox "URL of Genesis.json file" 8 78 http://testnet.telosfoundation.io/assets/files/genesis.json --title " Dialog" 3>&1 1>&2 2>&3);

}
function menu
{
positional_1=$(whiptail --title "Menu" --menu "Choose an option" 25 78 5 \
"Wizard" "Run the wizard tool." \
"Initialize" "First run only ." \
"Version" "Select which version to control." 
"Update"  "Select Telos version to update." 3>&1 1>&2 2>&3);
}

function fun
{
parse_args "$@"
#
case $positional_1 in
   "Initialize")
     Initial;
     ;;
	 "Setup")
	 run "$@";
	 ;;
	 "Version")
     version;
	 ;;
	 "Update")
     update;
	 ;;
	 "Wizard")
     Wizard "$@";
	 run "$@";
	 ;;
	 * ) menu;                 
	 ;;
	 esac
}


fun "$@";