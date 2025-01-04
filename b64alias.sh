https://Hackertips.today presents -                                                                                       
                                                                       ,--,             
                                                                      ,--.'|             
                                             ,---,       ,---.     ,--,  | :             
                             ,---,         ,---.'|      /     \ ,---.'|  : '             
     ,----._,.           ,-+-. /  |        |   | :     /    / ' ;   : |  | ;  .--.--.    
    /   /  ' /   ,---.  ,--.'|'   |        :   : :    .    ' /  |   | : _' | /  /    '   
   |   :     |  /     \|   |  ,"' |        :     |,-.'    / ;   :   : |.'  ||  :  /`./   
   |   | .\  . /    /  |   | /  | |        |   : '  ||   :  \   |   ' '  ; :|  :  ;_     
   .   ; ';  |.    ' / |   | |  | |        |   |  / :;   |   ``.\   \  .'. | \  \    `.  
   '   .   . |'   ;   /|   | |  |/         '   : |: |'   ;      \`---`:  | '  `----.   \ 
    `---`-'| |'   |  / |   | |--'          |   | '/ :'   |  .\  |     '  ; | /  /`--'  / 
    .'__/\_: ||   :    |   |/              |   :    ||   :  ';  :     |  : ;'--'.     /  
    |   :    : \   \  /'---'               /    \  /  \   \    /      '  ,/   `--'---'   
     \   \  /   `----'                     `-'----'    `---`--`       '--'               
      `--`-'                                                                             
        [ Gen b64 s - Generate [ encode/decode [ Base64 Strings in Linux on the Fly ]
                

Verify you have python3 installed and pip3 install base64   (and sys) prior to running


alias genb64s='function _genb64s() { if [[ "$1" == "-d" ]]; then python3 -c "import base64, sys; print(base64.b64decode(sys.argv[1]).decode())" "$2"; elif [[ $1 =~ ^[0-9]+$ ]]; then python3 -c "import os, base64; print(base64.b64encode(os.urandom(int($1))).decode())" "$1"; else python3 -c "import base64, sys; print(base64.b64encode(sys.argv[1].encode()).decode())" "$1"; fi; }; _genb64s'

Example:

[ ENCODE ]
bash$ genb64s "I Love Hacking On LinkedIN"
Output: SSBMb3ZlIEhhY2tpbmcgT24gTGlua2VkSU4=


[ DECODE ]
bash$ genb64s -d "SSBMb3ZlIEhhY2tpbmcgT24gTGlua2VkSU4="
I Love Hacking On LinkedIN


01/03/2025
