████████╗███████╗██╗      ██████╗ ███████╗      ██╗   ██╗███████╗███╗   ██╗███████╗███████╗██╗   ██╗███████╗██╗      █████╗
╚══██╔══╝██╔════╝██║     ██╔═══██╗██╔════╝      ██║   ██║██╔════╝████╗  ██║██╔════╝╚══███╔╝██║   ██║██╔════╝██║     ██╔══██╗
   ██║   █████╗  ██║     ██║   ██║███████╗█████╗██║   ██║█████╗  ██╔██╗ ██║█████╗    ███╔╝ ██║   ██║█████╗  ██║     ███████║
   ██║   ██╔══╝  ██║     ██║   ██║╚════██║╚════╝╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██╔══╝   ███╔╝  ██║   ██║██╔══╝  ██║     ██╔══██║
   ██║   ███████╗███████╗╚██████╔╝███████║       ╚████╔╝ ███████╗██║ ╚████║███████╗███████╗╚██████╔╝███████╗███████╗██║  ██║
   ╚═╝   ╚══════╝╚══════╝ ╚═════╝ ╚══════╝        ╚═══╝  ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
                                           CREATING A BETTER WORLD, BLOCK BY BLOCK.                                                                                              


./NodeBranching.sh [Initialize, Setup , Version , Wizard] [OPTIONS]
 OPTIONS:
 [Initialize] first setup run once
 [Setup] Build Nodeos and creates start and stop scripts
 [Version] Select which version to control
 [Wizard] Wizard setup
  -i | --INSDIR             : Installation Directory defaults: /opt/Nodes
  -a | --CHECKOUT           : git branch name
  -w | --WALLET             : Port to use for tkeosd defaults: 8900
  -c | --CONFIGDIR          : Directory of your config.ini file defaults: /home/Telos/control/defaults
  -p | --P2P                : Nodeos P2P Port defaults:  9876
  -t | --HTTP               : Nodeos Http Port defaults: 8888
  -d | --DATADIR            : Directory of Blocks/state  defaults: /data
  -f | --CONTROL            : Directory of control scripts defaults: /home/Telos/control/scripts
  -g | --GENESIS            : Genesis URL
  -h | --help               : This message



#This Tool helps sysadmins to build and Manage diferent Telos versions
#It will incorporate the following commands:
#nodeos starts nodeos
#stopnodeos stops nodeos
#backupnode stops nodeos makes and compress backups on your $DATADIR and starts nodeos again
#showlog outputs nodeos log created on your $NODESET directory
#teclos script to run teclos this script can be found in $NODESET directory
#tkeosd script to run tkeosd this script can be found in $NODESET directory
#version Wizard tool to select which nodeos version to control

Usage:
#Clone the repository in your $HOME directory 
git clone https://github.com/Daniel-TelosVe/Telos-Nodes
#First we need to Setup the machine(update, upgrade, setup ntpd, etc)
./NodeBranching.sh Initialize
#Then we can use the wizard to build nodeos 
./NodeBranching.sh Wizard
#After building you can use the provided config.ini and genesis.json placed at your $DEFAULT directory and change respective configurations

