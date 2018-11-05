#!/bin/bash
#Daniel Uzcátegui
#Telos-Venezula
source ~/.bashrc
set -e

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
    echo "usage: ./NodeBranching.sh [Initialize, Setup or Version] [OPTIONS]  ";
    echo " Positional (Initialize, Setup, Version,Wizard)";
	echo " OPTIONS: ";
	echo " [Initialize] first setup run once";
	echo " [Setup] Build Nodeos and creates start and stop scripts";
	echo " [Version] Select which version to control";
    echo "  -a | --CHECKOUT           : git branch name";
	echo "  -w | --WALLET             : Port to use for tkeosd defaults 8900";
	echo "  -c | --CONFIGDIR          : Directory of your config.ini file defaults /home/"$USER"/control/defaults";
	echo "  -p | --P2P                : Nodeos P2P Port default  9876";
	echo "  -t | --HTTP               : Nodeos Http Port default 8888";
	echo "  -d | --DATADIR            : Directory of Blocks/state  defaults to /data";
	echo "  -f | --CONTROL            : Directory of control scripts defaults /home/${USER}/control/scripts";
	echo "  -h | --help               : This message";
	
}

function parse_args
{
  # positional args
  args=()

  # named args
  while [ "$1" != "" ]; do
      case "$1" in
          -a | --CHECKOUT )               CHECKOUT="$2";             shift;;
		  -w | --WALLET )        WALLET="$2";      shift;;
		  -d | --DATADIR )        DATADIR="$2";      shift;;
		  -c | --CONFIGDIR )        CONFIGDIR="$2";      shift;;
		  -f | --CONTROL )           CONTROL="$2";      shift;;
          -h | --help )                 usage;                   exit;; # quit and show usage
          * )                           args+=("$1")             # if no match, add it to the positional args
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
      echo "No Initialize or Setup positional argument given"
      usage
      exit;
  fi
  
  # set defaults
  if [[ -z "$WALLET" ]]; then
      WALLET="8900";
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
}


function run
{
  parse_args "$@"

PROGRAMS=/opt/Nodes/$CHECKOUT/build/programs

#  echo "positional arg 1: $positional_1"
#  echo "positional arg 2: $positional_2"

if [[ -z "${CONTROL}"  ]]; then
      echo "You need to Initialize first, run ./NodeBranching.sh Initialize"
      exit;
fi
if [[ -z "${CHECKOUT}"  ]]; then
      echo "No Checkout provided so I will exit"
      exit;
fi	  
cd /opt/Nodes
git clone --quiet --progress  https://github.com/Telos-Foundation/telos $CHECKOUT
cd $CHECKOUT
git checkout $CHECKOUT
git submodule update --init --recursive
yes '1' | ./telos_build.sh
mkdir $CONTROL/$CHECKOUT 
echo "$PROGRAMS/nodeos/nodeos --p2p-listen-endpoint 0.0.0.0:${P2P} --http-server-address 127.0.0.1:${HTTP} --config-dir ${CONFIGDIR} --data-dir ${DATADIR} " '$@' " &> "$CONTROL/$CHECKOUT/"tlos.log &  echo " '$!' " > " $CONTROL/$CHECKOUT/"nodeos.pid" >> $CONTROL/$CHECKOUT/nodeos.sh 
echo "$PROGRAMS/teclos/teclos -u http://127.0.0.1:${HTTP} ---wallet-url http://127.0.0.1:${WALLET} " '$@'  >> $CONTROL/$CHECKOUT/teclos.sh
echo "$PROGRAMS/tkeosd/tkeosd --http-server-address http://127.0.0.1:${WALLET} " '$@' >> $CONTROL/$CHECKOUT/tkeosd.sh
chmod +x $CONTROL/$CHECKOUT/teclos.sh $CONTROL/$CHECKOUT/nodeos.sh $CONTROL/$CHECKOUT/tkeosd.sh
echo "export NODESET=${CONTROL}/${CHECKOUT} " >> ~/.bashrc
}

function Initial
{
yes | sudo apt-get update
yes | sudo apt-get upgrade
sudo timedatectl set-ntp no
yes | sudo apt-get install ntp
### Create Telos Home and make  usr propietary
sudo mkdir /opt/Nodes
sudo chown $USER /opt/Nodes
sudo mkdir /data
sudo chown $USER /data
#### Scripts for control location
cd
mkdir control
mkdir control/defaults
mkdir control/scripts
echo "export CONTROL=${CONTROL}" >> ~/.bashrc
echo "export DEFAULTS=${DEFAULTS}" >> ~/.bashrc
echo "export CONFIGDIR=${CONFIGDIR}" >> ~/.bashrc
echo "export DATADIR=${DATADIR}" >> ~/.bashrc
sudo dd of=start.sh << 'EOF'
#!/bin/bash
source ~/.bashrc
stopnode
$NODESET/nodeos.sh "$@"
EOF
#
sudo dd of=stop.sh << 'EOF'
#!/bin/bash
source ~/.bashrc
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
source ~/.bashrc
nohup stopnode $
cp -r $DATADIR/blocks $DATADIR/blockstemp
cp -r $DATADIR/state $DATADIR/statetemp
nohup startnode &
rm $DATADIR/backup.tar.gz.1
mv $DATADIR/backup.tar.gz backup.tar.gz.1
tar czvf $DATADIR/backup.tar.gz $DATADIR/blockstemp $DATADIR/statetemp
rm -rf $DATADIR/blockstemp
rm -rf $DATADIR/statetemp
EOF
echo alias showlog='"tail -f ${NODESET}/tlos.log"' >> ~/.bashrc
echo alias version='"${HOME}/NodeBranching.sh Version"' >> ~/.bashrc
sudo chmod 777 start.sh && sudo chmod 777 stop.sh && sudo cp start.sh /usr/bin/startnode && sudo cp stop.sh /usr/bin/stopnode && sudo chmod 777 backupnode && sudo mv backupnode /usr/bin
}
function version
{
	 export Directory=$(ls -lhp -1 -d $CONTROL/*/ | awk -F ' ' ' { print $9 " " $5 } ')
     export newpath=$(whiptail --menu "Select nodeos version to control" 40 50 30 --cancel-button Cancel --ok-button Select $Directory 3>&1 1>&2 2>&3)
     echo "export NODESET=${newpath}" >> ~/.bashrc
}
function Wizard
{


CHECKOUT=$(whiptail --inputbox "Enter Github Telos branch to build" 8 78 stage3.0 --title " Dialog" 3>&1 1>&2 2>&3); 
WALLET=$(whiptail --inputbox "Port to use for tkeosd defaults" 8 78 8900 --title " Dialog" 3>&1 1>&2 2>&3);
CONFIGDIR=$(whiptail --inputbox " Directory of your config.ini file" 8 78 /home/"$USER"/control/defaults --title " Dialog" 3>&1 1>&2 2>&3);
DATADIR=$(whiptail --inputbox "Directory of Blocks/state" 8 78 /data --title " Dialog" 3>&1 1>&2 2>&3);
CONTROL=$(whiptail --inputbox "Directory of control scripts" 8 78 /home/${USER}/control/scripts --title " Dialog" 3>&1 1>&2 2>&3);

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
	 "Wizard")
     Wizard "$@";
	 run "$@";
	 ;;
	 * ) usage;                 
	 ;;
	 esac
}

fun "$@";