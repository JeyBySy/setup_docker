#!/bin/bash
get_password() {
    clear
    printf "Enter your sudo pasword: "
    read -s pass
}
check_and_update(){
    echo $pass | sudo -S apt update
}

required_packages(){    
    sudo apt-get install ca-certificates curl

    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update -y

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
}

main(){
    while [ !check_and_update ];
    do
        get_password
        check_and_update
        if [ $? -eq 0 ]; then
            required_packages 
            break
        fi
    done
}

main
