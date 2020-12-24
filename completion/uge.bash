# bash completion for uge commands

# Univa Grid Engine Documentation
# - User Guide, version 8.5.4:
#   https://www.univa.com/resources/files/univa_user_guide_univa__grid_engine_854.pdf

################################################################################
# UGE host attributes
################################################################################
__uge_host_attributes="arch calendar cpu h_core h_cpu h_data h_fsize hostname h_rss h_rt h_stack h_vmem load_avg load_long load_medium load_short m_core mem_free mem_total mem_used min_cpu_interval m_socket m_thread m_topology m_topology_inuse np_load_avg np_load_long np_load_medium np_load_short num_proc slots qname rerun s_core s_cpu s_data seq_no s_fsize s_rss s_rt s_stack s_vmem swap_free swap_total swap_used tmpdir virtual_free virtual_total virtual_used"

__uge_host_attributes="arch bu build calendar cpu cpu_cache cpu_code cpus_used cputype docker d_rt h_core h_cpu h_data health h_fsize hostname h_rss h_rt h_stack ht h_vmem kernel_version load_avg load_long load_medium load_short longidle mc m_cache_l1 m_cache_l2 m_cache_l3 m_core mem_avail mem_free mem_inst mem_total mem_used m_gpu min_cpu_interval m_mem_free m_mem_free_n0 m_mem_free_n1 m_mem_total m_mem_total_n0 m_mem_total_n1 m_mem_used m_numa_nodes model m_socket mtc m_thread m_topology m_topology_inuse m_topology_numa ncps np_load_avg np_load_long np_load_medium np_load_short num_proc os os_bit os_distribution os_minor os_version pool project qname qsc regress rerun res_id s_core s_cpu scratch_free s_data seq_no s_fsize slots s_rss s_rt s_stack s_vmem swap_free swap_total swap_used tmpdir vg virtual_free virtual_total virtual_used vm"

__uge_host_discrete_attributes=("arch" "bu" "cputype" "cpu_code" "docker" "health" "m_core" "m_gpu" "model" "m_socket" "m_thread" "num_proc" "os" "os_bit" "os_minor" "os_version" "os_distribution" "project" "qsc" "res_id" "seq_no" "slots" "vg")

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

################################################################################
# Helper functions retrieving information from the grid in real time.
# Involves calling commands like qconf and qhost.
################################################################################
# Echoes list of grid projects.
__uge_list_projects() {
  echo $(qconf -sprjl)
}

# Echoes list of host attributes.
__uge_list_host_attributes() {
  echo ${__uge_host_attributes}
}

__uge_verify_mode_options() {
#  verify mode (error|warning|none|just verify|poke) for jobs.
  echo "e w n v p"
}

__uge_list_binding_options() {
  echo "pe env set explicit linear striding"
}

__uge_host_attr_values() {
  # echoes list of possible values for a given attribute.
  local k=$prev
  local v=isInArray $__uge_host_discrete_attributes $k
  [[ $v -eq 0 ]] || return
  _val=$(qhost -F $k | grep $k | sort | uniq | sed -e 's/.*=//')
  #echo 1>&2 "output of qhost/grep/sor/uniq/sed: $_val"
  echo $_val
}

################################################################################
# Helper completion functions
################################################################################
__uge_complete() {
    #echo 1>&2 "Input to __uge_complete is $1"
    local IFS=$' \t\n' cur_="${3-$cur}"
    [[ $cur_ == *:* ]] && cur_="${cur#*:}"
    COMPREPLY=( $(compgen -P "${2-}" -W "$1" -S "${4-}" -- "$cur_") )
}

# The 'add no space' version.
__uge_completeNS() {
    #echo 1>&2 "Input to __uge_complete is $1"
    local IFS=$' \t\n' cur_="${3-$cur}"
    [[ $cur_ == *:* ]] && cur_="${cur#*:}"
    compopt -o nospace
    COMPREPLY=( $(compgen -P "${2-}" -W "$1" -S "${4-}" -- "$cur_") )
}

__uge_completeResourcesNS() {
    local IFS=$' \t\n' cur_="${3-$cur}"
    [[ $cur_ == *:* ]] && cur_="${cur#*:}"
    # Do not append a white space after completion.
    compopt -o nospace
    # Completion: insert the cumulative resource flags as prefix, appends '=' as suffix.
    COMPREPLY=( $(compgen -P "$_cumulative_resource_flags" -W "$1" -S "=" -- "$cur_") )
}

################################################################################
# Top level completion function
# qsh
################################################################################
_qsh()
{
    local cur prev words cword
    _init_completion -n : cur prev words cword || return

    if [ 0 -gt 1 ]; then
      echo 1>&2 ""
      echo "prev // cur: $prev // $cur" 1>&2
      echo "words: $words"              1>&2
      echo "cword: $cword"              1>&2
      echo "COMP_WORDS : ${COMP_WORDS}"                             1>&2
      echo "COMP_CWORD : ${COMP_CWORD}"                             1>&2
      echo "COMP_WORDS[COMP_CWORD] : ${COMP_WORDS[COMP_CWORD]}"     1>&2
      echo "COMP_LINE : ${COMP_LINE}"                               1>&2
      echo "COMP_POINT : ${COMP_POINT}"                             1>&2
      echo "COMP_KEY : ${COMP_KEY}"                                 1>&2
      echo "COMP_TYPE : ${COMP_TYPE}"                               1>&2
      echo "args : $@"                                              1>&2
      echo 1>&2 ""
    fi

    local lastword=$cur
    local whole_line=${COMP_LINE}
    _cumulative_resource_flags=""  # to hold previously completed option for the -l flag.

    # The following 13 lines should be placed in a function(s).
    if [[ $lastword == *"," ]]; then
      local res_flag_pos=`echo $whole_line | awk -v RS=" " -v s=-l '$0==s{print NR}'`
      local num_words=$(numWords $whole_line)
      local d=$(echo "$num_words - $res_flag_pos" | bc)
      if [ $d -eq 1 ]; then
        # We are trying to complete a resource flag (or a value).
        prev="-l"  # The true previous keyword.
        cur="--"   # The true current option to complete.
      fi
    elif [[ $lastword == *","* ]]; then
      prev="-l"  # The true previous word.
      _cumulative_resource_flags=$(dropLastOfCsv $cur)  # Previously completed options
      cur=$(lastOfCsv $cur)        # The true option to complete
    fi

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
        -now)
            __uge_complete "yes no"
            return ;;
        -[jR])
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
    complete -F _qsh qsh   # We don't use "-o nospace" as we let the function
                           # decides what's best based on the scenario.

################################################################################
# qconf
################################################################################
_qconf()
{
    local cur prev words cword
    _init_completion -n : cur prev words cword || return

    case $prev in
        -mprj)
            __uge_complete "$(__uge_list_projects)"
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
    complete -F _qonf qonf   # We don't use "-o nospace" as we let the function
                             # decides what's best based on the scenario.
