#!/bin/bash
PROCSARRAY=( $(ls /proc | egrep '[0-9]') )
COUNT=0
printf "%-20s\n" "Number of PROCS: ${#PROCSARRAY[@]}"
for PROC in ${PROCSARRAY[@]}
do
  if [ -d /proc/${PROC} ]
  then
    PROCINFO=$(cat /proc/${PROC}/stat | awk '{print $2}' | tr -d '(' | tr -d ')' | cut -d'/' -f1)
    PROCCMDARRAY+=( "${PROCINFO}" )
  fi
done
printf "Unique processes:\n"
SORTED=( $(for INFO in ${PROCCMDARRAY[@]}; do echo $INFO; done | sort) )
UNIQUE=( $(for INFO in ${SORTED[@]}; do echo ${INFO}; done | uniq -c) )
for PROC in ${UNIQUE[@]}
do
  if [ ${COUNT} -eq 0 ]
  then
    NUM=${PROC}
    let COUNT=COUNT+1
  else
    printf "%-20s%s\n" "${PROC}:" "${NUM}"
    COUNT=0
  fi
done
exit 0
