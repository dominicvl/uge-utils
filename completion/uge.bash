# bash completion for uge commands

# Univa Grid Engine Documentation
# - User Guide, version 8.5.4:
#   https://www.univa.com/resources/files/univa_user_guide_univa__grid_engine_854.pdf

################################################################################
# UGE host attributes
################################################################################
__uge_host_attributes="arch calendar cpu h_core h_cpu h_data h_fsize hostname h_rss h_rt h_stack h_vmem load_avg load_long load_medium load_short m_core mem_free mem_total mem_used min_cpu_interval m_socket m_thread m_topology m_topology_inuse np_load_avg np_load_long np_load_medium np_load_short num_proc slots qname rerun s_core s_cpu s_data seq_no s_fsize s_rss s_rt s_stack s_vmem swap_free swap_total swap_used tmpdir virtual_free virtual_total virtual_used"

__uge_host_discrete_attributes=("arch" "m_core" "model" "m_socket" "m_thread" "num_proc" "project" "seq_no" "slots")

################################################################################
# UGE command options
################################################################################

__qacct_options=" -ar -A -b -d -D -e -f -g -h -help -j -l -o -pe -P -q -si -slots -t"

__qconf_options="-aattr -Aattr -acal -Acal -ace -ackpt -Ace -Ackpt -aconf -Aconf -adjs -adrs -ajc -Ajc -ae -Ae -ah -ahgrp -Ahgrp -arqs -Arqs -am -ao -ap -Ap -aprj -Aprj -aq -Aq -as -asi -Asi -astnode -astree -Astree -at -au -Au -auser -Auser -clearusage -clearltusage -cq -csi -dattr -Dattr -dcal -dce -dckpt -dconf -ddjs -ddrs -de -dh -dhgrp -djc -drqs -dm -do -dp -dprj -dq -ds -dsi -dstnode -dstree -du -dul -duser -help -ke -kec -kej -km -ks -kt -mattr -Mattr -mc -mce -mckpt -Mc -Mlur -mcal -Mcal -Mce -Mckpt -mconf -Mconf -me -Me -mhgrp -Mhgrp -mjc -Mjc -mrqs -Mrqs -mp -Mp -mprj -Mprj -mq -Mq -msconf -Msconf -msi -Msi -mstnode -Mstree -mstree -mu -Mu -muser -Muser -preferred -uha -purge -rattr -Rattr -sc -scal -scall -sce -sckpt -scel -sckptl -scl -sconf -sconfl -sdjs -sdjsl -sdrs -sdrsl -sdsl -se -secl -sec -sel -seld -sep -sh -shgrp -shgrp_tree -shgrp_resolved -shgrpl -si -sjc -sjcl -sds -slur -srqs -srqsl -sm -so -sobjl -sp -spl -sprj -sprjl -sprjld -sq -sql -ss -ssi -ssil -sss -ssconf -sstnode -rsstnode -sst -sstree -stl -su -suser -sul -suserl -tsm -Mlic -slic"

__qdel_options="-f -help -s -si -t -u"

__qhost_options=" -F -h -help -j -l -ncb -q -si -st -u -xml"

__qrsh_options=" -adds -ac -ar -A -b -bgio -binding -clear -clearp -clears -cwd -dc -display -e -h -hard -help -hold_jid -hold_jid_ad -inherit -j -jc -js -jsv -l -m -mods -masterl -masterq -mbind -notify -now -M -N -nostdin -noshell -o -P -p -par -pe -pty -q -R -rou -sc -si -soft -umask -v -verify -V -w -wd -xdv -xd -xd -verbose -suspend_remote"

__qsh_options="-adds -ac -ar -A -binding -clear -clearp -clears -cwd -dc -display -e -hard -help -j -jc -js -jsv -l -m -mods -masterl -masterq -mbind -now -M -N -o -P -p -par -pe -q -R -rou -sc -si -soft -S -umask -v -verify -V -w -wd -xdv -xd -verbose"

__qstat_options="-ext -explain -f -fjc -F -flt -g -g -g -help -j -l -ne -ncb -pe -nenv -njd -q -qs -r -rr -s -si -t -u -U -urg -pri -xml" 

__qsub_options=" -a -adds -ac -ar -A -b -binding -c -ckpt -clear -clearp -clears -cwd -C -dc -dl -e -h -hard -help -hold_jid -hold_jid_ad -i -j -jc -js -jsv -l -m -mods -masterl -masterq -mbind -notify -now -M -N -o -P -p -par -pe -pty -q -R -r -rou -rdi -sc -shell -si -soft -sync -S -t -tc -tcon -terse -umask -v -verify -V -w -wd -xdv -xd -xd_run_as_image_user -@"

################################################################################
# System related functions
################################################################################
# List available shells.
__uge_list_shells() {
  echo $(cat /etc/shells | grep -v nologin)
}

################################################################################
# Miscellaneous helper functions.
################################################################################
# Echoes number of words in input.
numWords() {
  local outarr=($(echo $* | tr " " " "))
  echo ${#outarr[@]}
}

# Given a comma separated string, echoes all elements but last.
dropLastOfCsv() {
  local tmparr=($(echo $* | tr "," " "))
  local s=($(echo "${#tmparr[@]} - 1" | bc)) # end of slice index
  local a=("${tmparr[@]:0:$s}")
  if [ $s -gt 0 ]; then
    echo "${a[@]},"
  fi
}

# Given a comma separated string, echoes last element.
lastOfCsv() {
  local tmparr=($(echo $* | tr "," " "))
  local p=($(echo "${#tmparr[@]} - 1" | bc))
  echo ${tmparr[$p]}
}

# Returns 0 if input string is inside input array.
# Usage:  isInArray <array> <string>
isInArray() {
  local array="$1[@]"
  local key=$2
  local inarray=1 # out value 1: not found, 0: found.
  for element in "${!array}"; do
    if [[ $element == "$key" ]]; then
        inarray=0  # found
        break
    fi
  done
  return $inarray
}

_updateForResources() {
  local lastword=$1
  [[ "$lastword" == "" ]] && return
  [[ $lastword == "-"* ]] && return
  local whole_line=$2
  if [[ $lastword == *"," ]]; then
    local res_flag_pos=`echo $whole_line | awk -v RS=" " -v s=-l '$0==s{print NR}'`
    local num_words=$(numWords $whole_line)
    local d=$(echo "$num_words - $res_flag_pos" | bc)
    if [ $d -eq 1 ]; then
      # We are trying to complete a resource flag (or a value).
      eval "$3='-l'"  # The true previous keyword.
      eval "$4='--'"   # The true current option to complete.
    fi
  elif [[ $lastword == *","* ]]; then
    eval "$3='-l'"  # The true previous word.
    eval "$4=$(lastOfCsv $lastword)"        # The true option to complete
    eval "$5=$(dropLastOfCsv $lastword)"    # Previously completed options
  fi
}

__debugPrintAll() {
  echo 1>&2 ""
  echo "prev : $prev"  1>&2
  echo "cur  : $cur"   1>&2
  echo "words: $words" 1>&2
  echo "cword: $cword" 1>&2
  echo "COMP_WORDS : ${COMP_WORDS}"                         1>&2
  echo "COMP_CWORD : ${COMP_CWORD}"                         1>&2
  echo "COMP_WORDS[COMP_CWORD] : ${COMP_WORDS[COMP_CWORD]}" 1>&2
  echo "COMP_LINE  : ${COMP_LINE}"                          1>&2
  echo "COMP_POINT : ${COMP_POINT}"                         1>&2
  echo "COMP_KEY   : ${COMP_KEY}"                           1>&2
  echo "COMP_TYPE  : ${COMP_TYPE}"                          1>&2
  echo "args : $@"                                          1>&2
  echo 1>&2 ""
}

################################################################################
# Helper functions retrieving information from the grid in real time.
# Involves calling commands like qconf and qhost.
################################################################################
__uge_list_projects() {
  # Echoes list of grid projects.
  echo $(qconf -sprjl)
}

__uge_list_host_attributes() {
  # Echoes list of host attributes.
  echo ${__uge_host_attributes}
}

__uge_verify_mode_options() {
  # Echoe possible verify modes (error|warning|none|just verify|poke) for jobs.
  echo "e w n v p"
}

__uge_list_binding_options() {
  echo "pe env set explicit linear striding"
}

__uge_host_attr_values() {
  # Echoes list of possible values for a given host attribute.
  local k=$prev
  local v=isInArray $__uge_host_discrete_attributes $k
  [[ $v -eq 0 ]] || return
  _val=$(qhost -F $k | grep $k | sort | uniq | sed -e 's/.*=//')
  echo $_val
}

__uge_list_host_states() {
  # Echoes host states c(onfiguration ambiguous), a(larm), suspend A(larm),
  # E(rror) state or attached (m)essage().
  echo "a c A E m"
}

__uge_list_job_states() {
  # Echoes possible job states.
  echo "r s z S N P hu ho hs hd hj ha h a"
}

__uge_list_queue_states() {
  # Echoes possible queue states.
  echo "a c d o s u A C D E S"
}

################################################################################
# Helper completion functions
#                      -P <prefix> -W <tocomplete> -S <suffix>
#COMPREPLY=( $(compgen -P "${2-}" -W "$1" -S "${4-}" -- "$cur_") )
################################################################################
__uge_complete() {
local IFS=$' \t\n' cur_="${cur}"
[[ $cur_ == *:* ]] && cur_="${cur#*:}"
COMPREPLY=( $(compgen -W "$1" -- "$cur_") )
}

# The 'add no space' version.
__uge_completeNS() {
local IFS=$' \t\n' cur_="${cur}"
[[ $cur_ == *:* ]] && cur_="${cur#*:}"
compopt -o nospace
COMPREPLY=( $(compgen -W "$1" -- "$cur_") )
}

__uge_completeResourcesNS() {
  local IFS=$' \t\n' cur_="${3-$cur}"
  [[ $cur_ == *:* ]] && cur_="${cur#*:}"
  # Do not append a white space after completion.
  compopt -o nospace
  # Completion: insert the cumulative resource flags as prefix, appends '=' as suffix.
  COMPREPLY=( $(compgen -P "$_cumulative_resource_flags" -W "$1" -S "=" -- "$cur_") )
}

__uge_filenames() {
  COMPREPLY=( $(compgen -o bashdefault -o nospace -f ${cur}) )
}

__uge_directories() {
  COMPREPLY=( $(compgen -o bashdefault -o nospace -d ${cur}) )
}

__uge_filedirectories() {
  COMPREPLY=( $(compgen -o bashdefault -o nospace -d ${cur} -S '/') )
  COMPREPLY+=( $(compgen -o bashdefault -o nospace -f ${cur}) )
}

################################################################################
# Top level completion functions
################################################################################


################################################################################
# qconf
################################################################################
_qconf() {
  local cur prev words cword
  _init_completion -n : cur prev words cword || return
  case $prev in
    -mprj | -sprj)
      __uge_complete "$(__uge_list_projects)"
      return ;;
  esac
  case $cur in
    -*)
      __uge_complete "$__qconf_options"
      return ;;
    *)
      return ;;
  esac
} &&
  complete -F _qconf qconf  # We don't use "-o nospace" as we let the function
                            # decides what's best based on the scenario.

################################################################################
# qrsh
################################################################################
_qrsh() {
  local cur prev words cword
  _init_completion -n : cur prev words cword || return
  # Print debug.
  [[ 0 -gt 1 ]] && __debugPrintAll
  local lastword="$cur"
  local whole_line="${COMP_LINE}"
  _cumulative_resource_flags=""  # to hold previously completed options for
                                 # the -l flag.
  # Updates prev, cur and _cumulative_resource_flags variables if we are
  # currently completing resource attributes from the -l argument.
  _updateForResources "$lastword" "$whole_line" prev cur _cumulative_resource_flags
  # Start with trivial cases: expand possible values for known - options.
  case $prev in
    -P)
      __uge_complete "$(__uge_list_projects)"
      return ;;
    -l)
      __uge_completeResourcesNS "$(__uge_list_host_attributes)"
      return ;;
    -binding)
      __uge_completeNS "$(__uge_list_binding_options)"
      return ;;
    -now | -j | -R)
      __uge_complete "yes no"
      return ;;
    -w)
      __uge_complete "$(__uge_verify_mode_options)"
      return ;;
  esac
  case $cur in
    -*)
      __uge_complete "$__qrsh_options"
      return ;;
    *)
    return ;;
  esac
} &&
  complete -F _qrsh qrsh # We don't use "-o nospace" as we let the function
                         # decides what's best based on the scenario.

################################################################################
# qsh
################################################################################
_qsh() {
  local cur prev words cword
  _init_completion -n : cur prev words cword || return
  # Print debug.
  [[ 0 -gt 1 ]] && __debugPrintAll
  local lastword="$cur"
  local whole_line="${COMP_LINE}"
  _cumulative_resource_flags=""  # to hold previously completed options for
                                 # the -l flag.
  # Updates prev, cur and _cumulative_resource_flags variables if we are
  # currently completing resource attributes from the -l argument.
  _updateForResources "$lastword" "$whole_line" prev cur _cumulative_resource_flags
  # Start with trivial cases: expand possible values for known - options.
  case $prev in
    -P)
      __uge_complete "$(__uge_list_projects)"
      return ;;
    -S)
      __uge_complete "$(__uge_list_shells)"
      return ;;
    -l)
      __uge_completeResourcesNS "$(__uge_list_host_attributes)"
      return ;;
    -binding)
      __uge_completeNS "$(__uge_list_binding_options)"
      return ;;
    -b | -now | -j | -pty | -R)
      __uge_complete "yes no"
      return ;;
    -w)
      __uge_complete "$(__uge_verify_mode_options)"
      return ;;
  esac
  case $cur in
    -*)
      __uge_complete "$__qsh_options"
      return ;;
    *)
    return ;;
  esac
} &&
  complete -F _qsh qsh # We don't use "-o nospace" as we let the function
                       # decides what's best based on the scenario.

################################################################################
# qstat
################################################################################
_qstat()
{
  local cur prev words cword
  _init_completion -n : cur prev words cword || return
  # Print debug.
  [[ 0 -gt 1 ]] && __debugPrintAll
  local lastword="$cur"
  local whole_line="${COMP_LINE}"
  _cumulative_resource_flags=""  # to hold previously completed options for
                                 # the -l flag.
  # Updates prev, cur and _cumulative_resource_flags variables if we are
  # currently completing resource attributes from the -l argument.
  _updateForResources "$lastword" "$whole_line" prev cur _cumulative_resource_flags
  # Start with trivial cases: expand possible values for known - options.
  case $prev in
    -s)
      __uge_complete "$(__uge_list_job_states)"
      return ;;
    -qs)
      __uge_complete "$(__uge_list_queue_states)"
      return ;;
    -explain)
      __uge_complete "$(__uge_list_host_states)"
      return ;;
    -l)
      __uge_completeResourcesNS "$(__uge_list_host_attributes)"
      return ;;
  esac
  case $cur in
    -*)
      __uge_complete "$__qstat_options"
      return ;;
    *)
      __uge_filedirectories
      return ;;
  esac
} &&
  complete -F _qstat qstat # We don't use "-o nospace" as we let the function
                           # decides what's best based on the scenario.

################################################################################
# qsub
################################################################################
_qsub()
{
  local cur prev words cword
  _init_completion -n : cur prev words cword || return
  # Print debug.
  [[ 0 -gt 1 ]] && __debugPrintAll
  local lastword="$cur"
  local whole_line="${COMP_LINE}"
  _cumulative_resource_flags=""  # to hold previously completed options for
                                 # the -l flag.
  # Updates prev, cur and _cumulative_resource_flags variables if we are
  # currently completing resource attributes from the -l argument.
  _updateForResources "$lastword" "$whole_line" prev cur _cumulative_resource_flags
  # Start with trivial cases: expand possible values for known - options.
  case $prev in
    -P)
      __uge_complete "$(__uge_list_projects)"
      return ;;
    -S)
      __uge_complete "$(__uge_list_shells)"
      return ;;
    -l)
      __uge_completeResourcesNS "$(__uge_list_host_attributes)"
      return ;;
    -binding)
      __uge_completeNS "$(__uge_list_binding_options)"
      return ;;
    -b | -j | -now | -pty | -r | -R | -rdi | -shell)
      __uge_complete "yes no"
      return ;;
    -w)
      __uge_complete "$(__uge_verify_mode_options)"
      return ;;
    -xd_run_as_image_user)
      __uge_complete "yes no"
      return ;;
  esac
  case $cur in
    -*)
    __uge_complete "$__qsub_options"
    return ;;
  *)
    __uge_filedirectories
    return ;;
  esac
} &&
  complete -F _qsub qsub # We don't use "-o nospace" as we let the function
                         # decides what's best based on the scenario.
