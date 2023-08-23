readReq(){
    msg=$1
    until [ ! $arg == "" ]
    do
        read -p "$msg" arg
    done
    echo ${arg}
}

readOpt(){
    msg=$1
    default=$2 
    read -p "$msg" arg 
    echo ${arg:-$default}
}