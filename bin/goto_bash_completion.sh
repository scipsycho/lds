_goto() {
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  commands=`goto help | grep -A 500 "Commands:" | grep -B 500 "Options:" | grep -v "\(Options\|Commands\):" | awk -F ":" '{ print $1 }' | tr "\n" " "`
  aliases=`cat $LDS_GOTO_FILE  | sed "s/local LDS_ALIAS_//g" | awk -F "=" '{ print $1 }' | tr "\n" " "`
  shortOptions=`goto help | ggrep -o -P '(?<!-)-\w+'  | tr "\n" " "`
  longOptions=`goto help | ggrep -o -P '\-\-\w+'  | tr "\n" " "`
  
  dictionary=""
  if [[ ${prev} == "goto" ]]
  then
    if [[ "${cur}" =~ --[a-z]* ]]
    then
      dictionary="${longOptions}"
    elif [[ "${cur}" =~ -[a-z]* ]]
    then
      dictionary="${shortOptions}"
    elif [[ "${cur}" =~ [a-z]* ]] 
    then
      dictionary="${commands} ${aliases}"
    fi
  elif [[ ${prev} == "-d" ]] || [[ ${prev} == "--deregister" ]]
  then
   dictionary="${aliases}" 
  fi
    COMPREPLY=( `compgen -W "${dictionary}" -- ${cur}` )
    return 0
}

complete -F _goto goto
