#!/bin/bash

# </ By Multtimy >

export IFS='
'

# Colors
red="\e[01;31m"; green="\e[01;32m"; yellow="\e[01;33m"
blue="\e[01;34m"; cyan="\e[01;36m"; end="\e[00m"

BOX="${blue}[${cyan}*${blue}]${end}"

# Cancel function
CANCEL(){
	echo -e "\n${blue} >>> ${red}Process Canceled${blue} <<<${end}\n"
	tput cnorm
	exit 0
}

# Error function
ERROR(){
	infoError="$1"
	scriptName=${0##*/}
	echo -e "\n${red}Error ${scriptName%.*}${end}:\n\t${blue}${infoError}${end}\n"
	tput cnorm
	exit 0
}

trap CANCEL INT
trap ERROR SIGTERM

# Help Menu function
HELPMENU(){
	clear
	scriptName=${0##*/}
	echo -e "${blue}USE ${green}${scriptName%.*}${end}:\n"
	echo -e "${green} -g${end}\tSelect and Generate a type of hash (md5, sha1, sha224, sha256, sha384, sha512).\n"
	echo -e "${green} -c${end}\tCheck hash of the file (md5, sha1, sha224, sha256, sha384, sha512)"
	echo -e "   \t(typing hash or paste the hash).\n"
	echo -e "${green} -f${end}\tSelect a file for generate hash o check.\n"
	echo -e "${green} -h${end}\tShow the help menu."
	echo -e "${green} --help${end}\n"
}

# Check the file function
CHECKFILE(){
	clear
	local file=$1
	echo -e "${BOX} ${yellow}Checking if exist the ${green}${file} ${yellow}file${end}.......\c"; sleep 1
	if [[ -f ${file} ]]; then
		echo -e "${green} done ${end}"; sleep 1
	else
		ERROR "The ${file} not exist, please check that exist."
	fi
}

# Generate hash function
GENERATEHASH(){
	local type=$1
	local file=$2	
	local hash=$(${type}sum ${file} | awk '{print $1}')
	local name=$(${type}sum ${file} | awk '{print $2}')

	echo -e "\n${green}---------------------------------------------------------------${end}"
	echo -e "${green} HASH ${type} ${end}-> ${yellow}${hash}${end}"
	echo -e "${green} FILE NAME ${end}-> ${yellow}${name}"
	echo -e "${green}---------------------------------------------------------------${end}\n"
   
	tput cnorm
	echo -en "${blue}Save hash in a file text ${blue}[${yellow}Y/N${blue}]${end}...${green}? ${end}"; read save
	tput civis
	if [[ ${save} == 'y' || ${save} == 'Y' ]]; then
		`echo -e "FILE NAME: ${name}" > ${PWD}/hash.txt 2>/dev/null`
		`echo -e "HASH FILE: ${hash}" >> ${PWD}/hash.txt 2>/dev/null`
		if [[ $? -eq 0 ]]; then
			echo -e "${green}File Saved in ${PWD}/hash.txt Susessfully...!${end}"
		else
			ERROR "Error to the Save hash"
		fi
	fi
}

# Checking hash of file function
CHECKHASH(){
	local hash=$1
	local file=$2
	local hashType=(md5 sha1 sha224 sha256 sha384 sha512)
	
	for hType in ${hashType[@]}; do
		local genhash=$(${hType}sum ${file} | awk '{print $1}' 2>/dev/null)
		if [[ ${hash} == ${genhash} ]]; then
			local bool='true'
			local type=${hType}
			break
		else
			local bool='false'
		fi
	done

	if [[ ${bool} == 'true' ]]; then
		echo -e "\n${green}--------------------------------------------------------------------------------------------${end}"
		echo -e " File Name: ${cyan}${file} ${blue}(${yellow}hash type ${blue}[${green}${type}${blue}])${end}"
		echo -e "\n ${green}${hash}${yellow} == ${blue}${genhash}${end}\n"
		echo -e " Status: ${green}Equals, The File Has Not Been Altered${end}"
		echo -e "${green}-------------------------------------------------------------------------------------------${end}\n"
	else
		echo -e "\n${red}---------------------------------------------------------------${end}"
		echo -e "   File Name: ${cyan}${file}"
		echo -e "\n        ${green}${hash}${yellow} != ${red}No Hashes${end}\n"
		echo -e "   Status: ${red}Not Equal, Check File Integrity${end}"
		echo -e "${red}--------------------------------------------------------------${end}\n"
	fi
}

# Main function
if [[ $# -eq 4 ]]; then
	declare -i count=0
	while getopts ":g:c:f:h:" args; do
		case ${args} in
			g) GENERATE=$OPTARG; let count+=1;;
			c) CHECK=$OPTARG; let count+=1;;
			f) FILE=$OPTARG; let count+=1;;
		esac
	done

	if [[ ${count} -ne 0 ]]; then
		tput civis
		if [[ ! -z ${FILE} ]]; then
			if [[ -n ${GENERATE} ]]; then
				CHECKFILE ${FILE}
				echo -e "${BOX} ${yellow}Generating hash ${blue}${GENERATE} ${yellow}to the ${green}${FILE} ${yellow}file${end}......."
				GENERATEHASH ${GENERATE} ${FILE}
			elif [[ -n ${CHECK} ]]; then
					CHECKFILE ${FILE}
					echo -e "${BOX} ${yellow}Checking the hash of the file${end}........"
					CHECKHASH ${CHECK} ${FILE}
			else
				HELPMENU
			fi
		else
			ERROR "Error of syntax, Not been append a file, use -f for add a file."
		fi
		tput cnorm
	else
		HELPMENU
	fi
else
	HELPMENU
fi
