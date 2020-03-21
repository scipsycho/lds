function _goto() {
  local cur prev opts __lds_goto_completion_commands __lds_goto_completion_aliases __lds_goto_completion_shortOptions __lds_goto_completion_longOptions
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"

  __lds_goto_completion_commands=`goto help | grep -A 500 "Commands:" | grep -B 500 "Options:" | grep -v "\(Options\|Commands\):" | awk -F ":" '{ print $1 }' | tr "\n" " "`
  __lds_goto_completion_aliases=`cat $LDS_GOTO_FILE  | sed "s/local LDS_ALIAS_//g" | awk -F "=" '{ print $1 }' | tr "\n" " "`
  __lds_goto_completion_shortOptions=`goto help | ggrep -o -P '(?<!-)-\w+'  | tr "\n" " "`
  __lds_goto_completion_longOptions=`goto help | ggrep -o -P '\-\-\w+'  | tr "\n" " "`
  
  __lds_goto_completion_dictionary=""
  if [[ ${prev} == "goto" ]]
  then
    if [[ "${cur}" =~ --[a-z]* ]]
    then
      __lds_goto_completion_dictionary="${__lds_goto_completion_longOptions}"
    elif [[ "${cur}" =~ -[a-z]* ]]
    then
      __lds_goto_completion_dictionary="${__lds_goto_completion_shortOptions}"
    elif [[ "${cur}" =~ [a-z]* ]] 
    then
      __lds_goto_completion_dictionary="${__lds_goto_completion_commands} ${__lds_goto_completion_aliases}"
    fi
  elif [[ ${prev} == "-d" ]] || [[ ${prev} == "--deregister" ]]
  then
   __lds_goto_completion_dictionary="${__lds_goto_completion_aliases}" 
  fi
    COMPREPLY=( `compgen -W "${__lds_goto_completion_dictionary}" -- ${cur}` )
    return 0
}

complete -F _goto goto
