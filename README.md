████████╗███████╗██╗      ██████╗ ███████╗      ██╗   ██╗███████╗███╗   ██╗███████╗███████╗██╗   ██╗███████╗██╗      █████╗
╚══██╔══╝██╔════╝██║     ██╔═══██╗██╔════╝      ██║   ██║██╔════╝████╗  ██║██╔════╝╚══███╔╝██║   ██║██╔════╝██║     ██╔══██╗
   ██║   █████╗  ██║     ██║   ██║███████╗█████╗██║   ██║█████╗  ██╔██╗ ██║█████╗    ███╔╝ ██║   ██║█████╗  ██║     ███████║
   ██║   ██╔══╝  ██║     ██║   ██║╚════██║╚════╝╚██╗ ██╔╝██╔══╝  ██║╚██╗██║██╔══╝   ███╔╝  ██║   ██║██╔══╝  ██║     ██╔══██║
   ██║   ███████╗███████╗╚██████╔╝███████║       ╚████╔╝ ███████╗██║ ╚████║███████╗███████╗╚██████╔╝███████╗███████╗██║  ██║
   ╚═╝   ╚══════╝╚══════╝ ╚═════╝ ╚══════╝        ╚═══╝  ╚══════╝╚═╝  ╚═══╝╚══════╝╚══════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
                                           CREATING A BETTER WORLD, BLOCK BY BLOCK.                                                                                              

usage: ./NodeBranching.sh [Initialize, Setup or Version] [OPTIONS]
 Positional (Initialize, Setup, Version,Wizard)
 OPTIONS:
 [Initialize] first setup run once
 [Setup] Build Nodeos and creates start and stop scripts
 [Version] Select which version to control
  -a | --CHECKOUT            : git branch name
  -w | --WALLET            : Port to use for tkeosd defaults 8900
  -c | --CONFIGDIR            : Directory of your config.ini file defaults /home/Telos/control/defaults
  -d | --DATADIR            : Directory of Blocks/state  defaults to /data
  -f | --CONTROL            : Directory of control scripts defaults /home/Telos/control/scripts
  -h | --help              : This message
